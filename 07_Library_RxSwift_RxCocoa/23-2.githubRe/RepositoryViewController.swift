//
//  RepositoryViewController.swift
//  23-2.githubRe
//
//  Created by yeonhoc5 on 2023/05/12.
//

import UIKit
import RxSwift
import RxCocoa


class RepositoryViewController: UITableViewController {
    
    let organization = "Apple"
    var repositories = BehaviorSubject<[Repository]>(value: [])
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = organization + " Repositories"
        self.tableView.register(RepositoryCell.self, forCellReuseIdentifier: "cell")
        setRefreshableController()
    }
    
    func setRefreshableController() {
        let refreshController = UIRefreshControl()
        refreshController.tintColor = .systemTeal
        refreshController.attributedTitle = NSAttributedString(string: "기다리시오.")
        refreshController.addTarget(self, action: #selector(renewRepository), for: .valueChanged)
        self.refreshControl = refreshController
    }
    
    @objc func renewRepository() {
        fetchRepositories(of: self.organization)
    }
    
    func fetchRepositories(of organization: String) {
        Observable<String>.of(organization)
            .map { organization -> URL in
                return  URL(string: "https://api.github.com/orgs/\(organization)/repos")!
            }
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                let requset = URLRequest(url: url)
                return URLSession.shared.rx.response(request: requset)
            }
            .filter { response, _ in
                return (200..<300) ~= response.statusCode
            }
            .filter { _, data in
                return data.count > 0
            }
            .subscribe { _, data in
                let decoder = JSONDecoder()
                guard let decodedData = try? decoder.decode([Repository].self, from: data) else {
                    return  }
                self.repositories.onNext(decodedData)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            return try repositories.value().count
        } catch {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RepositoryCell else { return UITableViewCell() }
//        do {
//            let repository = self.repositories[indexPath.row]
        guard let repository = try? self.repositories.value()[indexPath.row] else { return cell }
            cell.lblName.text = repository.name
            cell.lblDescription.text = repository.description
            cell.imgView.image = UIImage(systemName: "star")
            cell.lblCount.text = String("\(repository.stargazersCount)")
            cell.lblLanguage.text = repository.language
//        } catch {
//            return cell
//        }
        return cell
    }
}

