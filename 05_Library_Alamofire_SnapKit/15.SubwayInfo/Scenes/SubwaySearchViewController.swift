//
//  SubwaySearchViewController.swift
//  15.SubwayInfo
//
//  Created by yeonhoc5 on 2022/09/05.
//

import UIKit
import Alamofire
import SnapKit

class SubwaySearchViewController: UIViewController {
    
    let searchBarController = UISearchController()
    
    var stationList: [Station] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureTableView()
    }
    
    func configureNavigation() {
        navigationItem.title = "지하철 도착 정보"
        navigationController?.navigationBar.tintColor = .white
        navigationItem.searchController = searchBarController
        searchBarController.searchBar.placeholder = "지하철역을 입력하세요."
        searchBarController.searchBar.tintColor = .white
        searchBarController.searchBar.searchTextField.tintColor = .white
        searchBarController.searchBar.searchTextField.textColor = UIColor.white
        searchBarController.searchBar.delegate = self
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.isHidden = true
    }
    
    private func requestStationName(from stationName: String) {
        let urlString = "http://openAPI.seoul.go.kr:8088/sample/json/SearchInfoBySubwayNameService/1/5/\(stationName)"
        AF.request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of: StationResponseModel.self) { [weak self] response in
                guard let self = self, case .success(let data) = response.result else { return }
                self.stationList = data.stations
        }
        .resume()
    }
    
}







extension SubwaySearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = true
        stationList = []
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        requestStationName(from: searchText)
    }
    
}


extension SubwaySearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let station = stationList[indexPath.row]
        cell.textLabel?.text = station.stationName
        cell.detailTextLabel?.text = station.lineNumber
        return cell
    }
}


extension SubwaySearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let station = stationList[indexPath.row]
        let detailVC = DetailViewController(station: station)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
