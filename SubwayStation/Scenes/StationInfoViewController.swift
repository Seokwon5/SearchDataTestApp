//
//  StationInfoViewController.swift
//  SubwayStation
//
//  Created by 이석원 on 2022/09/02.
//
import Alamofire
import UIKit
import SnapKit

final class StationInfoViewController: UIViewController {
    private let station: Station
    private var realtimeArrivarList: [StationArrivalDataResponseModel.RealTimeArrival] = []
    
    private lazy var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        
        return refreshControl
    }()
    

    
    private lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(
            width: view.frame.width - 32.0, height: 100.0)//너비는 전체에서 32뺀만큼 높이는 100
        layout.sectionInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0) //전체 마진 16씩
        layout.scrollDirection = .vertical //상하 스크롤
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.register(StationCell.self, forCellWithReuseIdentifier: "StationCell")
        
        collectionView.refreshControl = refreshControl
        
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
        
        navigationItem.title = station.stationName
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{ $0.edges.equalToSuperview() }
        
        fetchData()
    }
    
    @objc private func fetchData() {
        
        let stationName = station.stationName
        let urlString = "http://swopenAPI.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/\(stationName.replacingOccurrences(of: "역", with: ""))"
        AF.request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of: StationArrivalDataResponseModel.self) {[weak self] response in
                self?.refreshControl.endRefreshing()
                
                guard case .success(let data) = response.result else { return }
                
                self?.realtimeArrivarList = data.realtimeArrivalList
                self?.collectionView.reloadData()
                
            }
            .resume()
    }
    
}

extension StationInfoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StationCell", for: indexPath) as? StationCell
        
        let realTimeArrival = realtimeArrivarList[indexPath.row]
        cell?.setup(with: realTimeArrival)
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realtimeArrivarList.count
    }
}


