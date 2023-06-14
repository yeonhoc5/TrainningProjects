//
//  DetailCell.swift
//  15.SubwayInfo
//
//  Created by yeonhoc5 on 2022/09/05.
//

import UIKit
import SnapKit

class DetailCell: UICollectionViewCell {
    
    private lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .label
        
        return label
    }()
    
    private lazy var lblSubTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    func configureCell(with arrivalInfo: ArrivalList) {
        backgroundColor = .systemBackground
        [lblTitle, lblSubTitle].forEach {
            addSubview($0)
        }
        lblTitle.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        lblSubTitle.snp.makeConstraints {
            $0.top.equalTo(lblTitle.snp.bottom).offset(10)
            $0.leading.equalTo(lblTitle)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        lblTitle.text = "\(arrivalInfo.currentStation)"
        lblSubTitle.text = "\(arrivalInfo.remainTime)"
    }
}
