//
//  NoticeViewController.swift
//  08.remoteControll
//
//  Created by YHChoi on 2022/08/02.
//

import UIKit

class NoticeViewController: UIViewController {

    var noticeContents: (title: String, detail: String, date: String)?
    
    @IBOutlet var noticeView: UIView!

    @IBOutlet var lblNoticeTitle: UILabel!
    @IBOutlet var lblNoticeDetail: UILabel!
    @IBOutlet var lblNoticeDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noticeView.layer.cornerRadius = 6
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        guard let noticeContents = noticeContents else {
            return
        }
        lblNoticeTitle.text = noticeContents.title
        lblNoticeDetail.text = noticeContents.detail
        lblNoticeDate.text = noticeContents.date
    }
    
    
    @IBAction func tabBtnDone(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
    
}
