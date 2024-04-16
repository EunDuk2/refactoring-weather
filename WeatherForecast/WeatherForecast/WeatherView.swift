//
//  WeatherView.swift
//  WeatherForecast
//
//  Created by EUNSUNG on 4/15/24.
//

import UIKit

protocol WeatherViewDelegate {
    func setNavigationItem(buttonItem: UIBarButtonItem)
    func changeTempUnit()
    func refresh()
    func setTableViewDelegate(view: WeatherView)
}

class WeatherView: UIView {
    private var delegate:WeatherViewDelegate
    
    private var tableView: UITableView!
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private var icons: [UIImage]?
    
    init(delegate: WeatherViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        initialSetUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTableView() -> UITableView {
        return self.tableView
    }
    
    private func initialSetUp() {
        delegate.setNavigationItem(buttonItem: UIBarButtonItem(title: "화씨", image: nil, target: self, action: #selector(onBarButton)))
        
        layTable()
        
        refreshControl.addTarget(self,
                                 action: #selector(onRefreshControl),
                                 for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
        
        delegate.setTableViewDelegate(view: self)
//        tableView.dataSource = self
//        tableView.delegate = self
    }
    
    @objc private func onBarButton() {
        delegate.changeTempUnit()
        delegate.refresh()
        tableView.reloadData()
    }
    
    @objc private func onRefreshControl() {
        delegate.refresh()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    private func layTable() {
        tableView = .init(frame: .zero, style: .plain)
        self.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea: UILayoutGuide = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

//extension WeatherView: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        weatherJSON?.weatherForecast.count ?? 0
//        return 10
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
//        
//        guard let cell: WeatherTableViewCell = cell as? WeatherTableViewCell else {
//            return cell
//        }
//        
//        cell.dateLabel.text = "eunduk"
//        
//        return cell
//    }
//}
//
//extension WeatherView: UITableViewDelegate {
//    
//}
