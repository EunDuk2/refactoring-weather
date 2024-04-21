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
    func cellCount() -> Int
    func setCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func didSelectRow(tableView: UITableView, indexPath: IndexPath)
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
    
    private func initialSetUp() {
        self.backgroundColor = .white
        delegate.setNavigationItem(buttonItem: UIBarButtonItem(title: "화씨", image: nil, target: self, action: #selector(onBarButton)))
        
        layTable()
        
        refreshControl.addTarget(self,
                                 action: #selector(onRefreshControl),
                                 for: .valueChanged)
        
        tableView.refreshControl = refreshControl
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "WeatherCell")
        
        tableView.dataSource = self
        tableView.delegate = self
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

extension WeatherView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate.cellCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return delegate.setCell(tableView: tableView, indexPath: indexPath)
    }
}

extension WeatherView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectRow(tableView: tableView, indexPath: indexPath)
    }
}
