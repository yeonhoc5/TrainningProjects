//
//  RepositoryCell.swift
//  23-2.githubRe
//
//  Created by yeonhoc5 on 2023/05/12.
//

import UIKit
import SnapKit

class RepositoryCell: UITableViewCell {
    
    let lblName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let lblDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 2
        return label
    }()
    
    let imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    let lblCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    let lblLanguage: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        [lblName, lblDescription, imgView, lblCount, lblLanguage].forEach {
            contentView.addSubview($0)
        }
        
        lblName.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview().inset(20)
            $0.height.equalTo(30)
        }
        
        lblDescription.snp.makeConstraints {
            $0.leading.trailing.equalTo(lblName)
            $0.top.equalTo(lblName.snp.bottom)
        }
        
        imgView.snp.makeConstraints {
            $0.leading.equalTo(lblName)
            $0.top.equalTo(lblDescription.snp.bottom).offset(10)
            $0.width.height.equalTo(20)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        lblCount.snp.makeConstraints {
            $0.leading.equalTo(imgView.snp.trailing).offset(10)
            $0.centerY.equalTo(imgView)
        }
        
        lblLanguage.snp.makeConstraints {
            $0.leading.equalTo(lblCount.snp.trailing).offset(10)
            $0.centerY.equalTo(imgView)
        }
    }
}
