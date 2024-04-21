//
//  WeatherForecast - WeatherDetailViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class WeatherDetailViewController: UIViewController, WeatherDetailViewDelegate {
    
    var weatherForecastInfo: WeatherForecastInfo?
    var cityInfo: City?
    var tempUnit: TempUnit = .metric
    
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
        temperatureLabel.text = "현재 기온 : \(listInfo.main.temp)\(tempUnit.expression)"
        feelsLikeLabel.text = "체감 기온 : \(listInfo.main.feelsLike)\(tempUnit.expression)"
        maximumTemperatureLable.text = "최고 기온 : \(listInfo.main.tempMax)\(tempUnit.expression)"
        minimumTemperatureLable.text = "최저 기온 : \(listInfo.main.tempMin)\(tempUnit.expression)"
        popLabel.text = "강수 확률 : \(listInfo.main.pop * 100)%"
        humidityLabel.text = "습도 : \(listInfo.main.humidity)%"
        
        if let cityInfo {
            sunriseTimeLabel.text = "일출 : \(cityDateFormatter().string(from: Date(timeIntervalSince1970: cityInfo.sunrise)))"
            sunsetTimeLabel.text = "일몰 : \(cityDateFormatter().string(from: Date(timeIntervalSince1970: cityInfo.sunset)))"
        }
        setIconImage(icon: listInfo.weather.icon, iconImageView: iconImageView)
    }
}
