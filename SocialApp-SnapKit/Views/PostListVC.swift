//
//  PostListVC.swift
//  SocialApp
//
//  Created by Oleksandr Bretsko on 1/2/2021.
//

import UIKit
import SnapKit

class PostListVC: UIViewController {
    
    let tableView = UITableView()
    
    var posts = [Post]()
    
    var netService: NetworkingService! 
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        view.backgroundColor = UIColor.white
        navigationItem.title = "Posts"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
        
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.cellReuseId)
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        reloadPosts()
    }
    
    //MARK: - Methods

    @objc func addButtonPressed() {
        let newPostVC = NewPostVC()
        self.navigationController?.pushViewController(newPostVC, animated: true)
    }
    
    //MARK: - Network

    func reloadPosts() {
        netService.loadPosts { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .failure(let error):
                //TODO: handle error
                print("ERROR: \(error)")
                
            case .success(let posts):
                print("INFO: \(posts.count) posts received from network")
                DispatchQueue.main.async {
                    strongSelf.posts = posts
                    strongSelf.tableView.reloadData()
                }
            }
        }
    }
}

//MARK: - TableView

extension PostListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !posts.isEmpty else {
            return UITableViewCell()
        }
        let cell =
            self.tableView.dequeueReusableCell(withIdentifier: PostCell.cellReuseId, for: indexPath) as! PostCell
        cell.configure(with: posts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        let vc = PostVC()
        vc.netService = netService
        vc.post = posts[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

