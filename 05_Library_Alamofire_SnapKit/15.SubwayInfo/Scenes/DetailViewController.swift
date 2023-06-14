//
//  DetailViewController.swift
//  15.SubwayInfo
//
//  Created by yeonhoc5 on 2022/09/05.
//

import UIKit
import SnapKit
import Alamofire

class DetailViewController: UIViewController {

    private let station: Station
    
    var arrivalList: [ArrivalList] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: view.frame.width - 32.0, height: 80.0)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(DetailCell.self, forCellWithReuseIdentifier: "DetailCell")
        
        return collectionView
    }()
    
    init(station: Station) {
        self.station = station
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .orange
        navigationItem.title = "\(station.stationName)역"
        fetchData()
        configureCollectionView()
        collectionView.refreshControl = refreshControl
    }
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }

    @objc func fetchData() {
//        refreshControl.endRefreshing()
        let stationName = station.stationName
//        if stationName.last == "역" {
//            stationName.removeLast()
//        }
        let urlString = "http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/\(stationName)"
        AF.request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of: StationArrivalDataResponseModel.self) { [weak self] response in
                self?.refreshControl.endRefreshing()
                guard case .success(let data) = response.result else { return }
                self?.arrivalList = data.arrivalList
            }
            .resume()
    }
}


extension DetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrivalList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath) as? DetailCell else { return UICollectionViewCell() }
        cell.backgroundColor = .systemBackground
        cell.layer.cornerRadius = 20
        cell.configureCell(with: arrivalList[indexPath.row])
        
        UIView.animate(withDuration: 1, delay: 0) {
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.1
//            cell.layer.shadowOffset = CGSize(width: 0, height: 5)
            cell.layer.shadowRadius = 5
        }
        return cell
    }
}
