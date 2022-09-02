//
//  StationCell.swift
//  SubwayStation
//
//  Created by 이석원 on 2022/09/02.
//

import UIKit
import SnapKit

final class StationCell: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24.0, weight: .bold)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        
        return label
    }()
    
    func setup() {
        layer.cornerRadius = 12.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10
        backgroundColor = .systemBackground

        setupViews()
        
        titleLabel.text = "오이도행 - 오이도방면"
        descriptionLabel.text = "길음역 도착"
    }

}

private extension StationCell{
    func setupViews() {
        [titleLabel, descriptionLabel].forEach{ addSubview($0) }
        
        titleLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().inset(16.0)
            $0.top.equalToSuperview().inset(16.0)
        }
        descriptionLabel.snp.makeConstraints{
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            $0.bottom.equalToSuperview().inset(16.0)
        }
    }
}
