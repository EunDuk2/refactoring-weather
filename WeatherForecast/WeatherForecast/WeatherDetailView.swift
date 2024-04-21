//
//  WeatherDetailView.swift
//  WeatherForecast
//
//  Created by EUNSUNG on 4/21/24.
//

import Foundation
import UIKit

protocol WeatherDetailViewDelegate {
    func setValue(weatherGroupLabel: UILabel, weatherDescriptionLabel: UILabel, temperatureLabel: UILabel, feelsLikeLabel: UILabel, maximumTemperatureLable: UILabel, minimumTemperatureLable: UILabel, popLabel: UILabel, humidityLabel: UILabel, sunriseTimeLabel: UILabel, sunsetTimeLabel: UILabel, iconImageView: UIImageView)
}

class WeatherDetailView: UIView {
    private let iconImageView: UIImageView = UIImageView()
    private let weatherGroupLabel: UILabel = UILabel()
    private let weatherDescriptionLabel: UILabel = UILabel()
    private let temperatureLabel: UILabel = UILabel()
    private let feelsLikeLabel: UILabel = UILabel()
    private let maximumTemperatureLable: UILabel = UILabel()
    private let minimumTemperatureLable: UILabel = UILabel()
    private let popLabel: UILabel = UILabel()
    private let humidityLabel: UILabel = UILabel()
    private let sunriseTimeLabel: UILabel = UILabel()
    private let sunsetTimeLabel: UILabel = UILabel()
    private let spacingView: UIView = UIView()
    
    private var delegate: WeatherDetailViewDelegate
    
    init(delegate: WeatherDetailViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        setUI()
        setValue()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.backgroundColor = .white
        spacingView.backgroundColor = .clear
        spacingView.setContentHuggingPriority(.defaultLow, for: .vertical)
        weatherGroupLabel.font = .preferredFont(forTextStyle: .largeTitle)
        weatherDescriptionLabel.font = .preferredFont(forTextStyle: .largeTitle)
        
        setStackView()
    }
    
    func setValue() {
        delegate.setValue(weatherGroupLabel: self.weatherGroupLabel, weatherDescriptionLabel: self.weatherDescriptionLabel, temperatureLabel: self.temperatureLabel, feelsLikeLabel: self.feelsLikeLabel, maximumTemperatureLable: self.maximumTemperatureLable, minimumTemperatureLable: self.minimumTemperatureLable, popLabel: self.popLabel, humidityLabel: self.humidityLabel, sunriseTimeLabel: self.sunriseTimeLabel, sunsetTimeLabel: self.sunsetTimeLabel, iconImageView: self.iconImageView)
    }
    
    func setStackView() {
        let mainStackView: UIStackView = .init(arrangedSubviews: [
            iconImageView,
            weatherGroupLabel,
            weatherDescriptionLabel,
            temperatureLabel,
            feelsLikeLabel,
            maximumTemperatureLable,
            minimumTemperatureLable,
            popLabel,
            humidityLabel,
            sunriseTimeLabel,
            sunsetTimeLabel,
            spacingView
        ])
        
        mainStackView.arrangedSubviews.forEach { subview in
            guard let subview: UILabel = subview as? UILabel else { return }
            subview.textColor = .black
            subview.backgroundColor = .clear
            subview.numberOfLines = 1
            subview.textAlignment = .center
            subview.font = .preferredFont(forTextStyle: .body)
        }
        
        mainStackView.axis = .vertical
        mainStackView.alignment = .center
        mainStackView.spacing = 8
        self.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea: UILayoutGuide = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,
                                                   constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,
                                                   constant: -16),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
            iconImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor,
                                                 multiplier: 0.3)
        ])
    }
}
