//
//  WeatherViewController.swift
//  WeatherForecast
//
//  Created by EUNSUNG on 4/15/24.
//

import UIKit

protocol WeatherDetailPresentable {
    func setWeatherForecastInfo(weatherForecaseInfo: WeatherForecastInfo?)
    func setCityInfo(cityInfo: City?)
    func setTempUnit(tempUnit: TempUnit)
    func showDetailViewController(on navigationController: UINavigationController?)
}

class WeatherViewController: UIViewController, WeatherViewDelegate {
    private var weatherJSON: WeatherJSON?
    private var tempUnit: TempUnit = .metric
    private let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
    
    private let presentable: WeatherDetailPresentable
    private let imageManager: ImageManager
    
    init(presentable: WeatherDetailPresentable, imageManager: ImageManager) {
        self.presentable = presentable
        self.imageManager = imageManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    override func loadView() {
        view = WeatherView(delegate: self)
    }
    
    func setTitle(titleText: String) {
        navigationItem.title = titleText
    }
    
    private func convertTimeToDateString(timeInterval: TimeInterval) -> String {
        let date: Date = Date(timeIntervalSince1970: timeInterval)
        return dateFormatter.string(from: date)
    }
    
    private func setImageFromURL(icon: String, imageView: UIImageView) {
        let urlString: String = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        
        if let image = imageManager.getImageChache(forKey: urlString) {
            imageView.image = image
        }
        Task {
            guard let image = await imageManager.downloadImage(urlString: urlString) else {
                return
            }
            imageManager.setImageChache(image: image, forKey: urlString)
            imageView.image = image
        }
    }
    
    // protocol function
    func setNavigationItem(buttonItem: UIBarButtonItem) {
        navigationItem.rightBarButtonItem = buttonItem
    }
    
    func changeTempUnit() {
        tempUnit = tempUnit == .imperial ? .metric : .imperial
        navigationItem.rightBarButtonItem?.title = tempUnit == .imperial ? "화씨" : "섭씨"
    }
    
    func refresh() {
        guard let json = decodeWeatherJSON(dataName: "weather") else {
            return
        }
        weatherJSON = json
        setTitle(titleText: (weatherJSON?.city.name)!)
    }
    
    func cellCount() -> Int {
        return weatherJSON?.weatherForecast.count ?? 0
    }
    
    func setCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        
        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell,
              let weatherForecastInfo = weatherJSON?.weatherForecast[indexPath.row] else {
            return cell
        }
        
        cell.weatherLabel.text = weatherForecastInfo.weather.main
        cell.descriptionLabel.text = weatherForecastInfo.weather.description
        cell.temperatureLabel.text = "\(weatherForecastInfo.main.temp)\(tempUnit.expression)"
        cell.dateLabel.text = convertTimeToDateString(timeInterval: weatherForecastInfo.dt)
        setImageFromURL(icon: weatherForecastInfo.weather.icon, imageView: cell.weatherIcon)

        return cell
    }
    
    func didSelectRow(tableView: UITableView, indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presentable.setWeatherForecastInfo(weatherForecaseInfo: weatherJSON?.weatherForecast[indexPath.row])
        presentable.setCityInfo(cityInfo: weatherJSON?.city)
        presentable.setTempUnit(tempUnit: tempUnit)
        presentable.showDetailViewController(on: navigationController)
    }
}

extension WeatherViewController {
    private func fetchWeatherJSON(dataName: String) -> Data? {
        guard let data = NSDataAsset(name: dataName)?.data else {
            return nil
        }
        return data
    }
    
    private func decodeWeatherJSON(dataName: String) -> WeatherJSON? {
        let jsonDecoder: JSONDecoder = .init()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

        guard let data = fetchWeatherJSON(dataName: dataName) else {
            return nil
        }
        do {
            return try jsonDecoder.decode(WeatherJSON.self, from: data)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
