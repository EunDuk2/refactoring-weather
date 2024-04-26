//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherDetailViewController: UIViewController, WeatherDetailViewDelegate, WeatherDetailPresentable {
    
    var weatherForecastInfo: WeatherForecastInfo?
    var cityInfo: City?
    var temperature: Temperature?
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd(EEEEE) a HH:mm"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle()
    }
    
    override func loadView() {
        view = WeatherDetailView(delegate: self)
    }
    
    private func setNavigationTitle() {
        guard let listInfo = weatherForecastInfo else { return }
        
        let date: Date = Date(timeIntervalSince1970: listInfo.dt)
        navigationItem.title = dateFormatter.string(from: date)
    }
    
    private func cityDateFormatter() -> DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = .none
        formatter.timeStyle = .short
        formatter.locale = .init(identifier: "ko_KR")
        
        return formatter
    }
    
    private func setIconImage(icon:String, iconImageView: UIImageView) {
        Task {
            let urlString: String = "https://openweathermap.org/img/wn/\(icon)@2x.png"

            guard let url: URL = URL(string: urlString),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let image: UIImage = UIImage(data: data) else {
                return
            }

            iconImageView.image = image
        }
    }
    
    // protocol function
    func setValue(weatherGroupLabel: UILabel, weatherDescriptionLabel: UILabel, temperatureLabel: UILabel, feelsLikeLabel: UILabel, maximumTemperatureLable: UILabel, minimumTemperatureLable: UILabel, popLabel: UILabel, humidityLabel: UILabel, sunriseTimeLabel: UILabel, sunsetTimeLabel: UILabel, iconImageView: UIImageView) {
        guard let listInfo = weatherForecastInfo else { return }
        
        weatherGroupLabel.text = listInfo.weather.main
        weatherDescriptionLabel.text = listInfo.weather.description
        guard let temperature = temperature else {return}
        temperatureLabel.text = "현재 기온 : \(temperature.getTemperature(temp: listInfo.main.temp))\(temperature.unit)"
        feelsLikeLabel.text = "체감 기온 : \(listInfo.main.feelsLike)\(temperature.unit)"
        maximumTemperatureLable.text = "최고 기온 : \(listInfo.main.tempMax)\(temperature.unit)"
        minimumTemperatureLable.text = "최저 기온 : \(listInfo.main.tempMin)\(temperature.unit)"
        popLabel.text = "강수 확률 : \(listInfo.main.pop * 100)%"
        humidityLabel.text = "습도 : \(listInfo.main.humidity)%"
        
        if let cityInfo {
            sunriseTimeLabel.text = "일출 : \(cityDateFormatter().string(from: Date(timeIntervalSince1970: cityInfo.sunrise)))"
            sunsetTimeLabel.text = "일몰 : \(cityDateFormatter().string(from: Date(timeIntervalSince1970: cityInfo.sunset)))"
        }
        setIconImage(icon: listInfo.weather.icon, iconImageView: iconImageView)
    }
    
    func setWeatherForecastInfo(weatherForecaseInfo: WeatherForecastInfo?) {
        self.weatherForecastInfo = weatherForecaseInfo
    }
    
    func setCityInfo(cityInfo: City?) {
        self.cityInfo = cityInfo
    }
    
    func setTemperature(temperature: Temperature) {
        self.temperature = temperature
    }
    
    func showDetailViewController(on navigationController: UINavigationController?) {
        navigationController?.show(self, sender: self)
    }
}
