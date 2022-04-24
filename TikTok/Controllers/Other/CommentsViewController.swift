//
//  CommentsViewController.swift
//  TikTok
//
//  Created by Ivan Potapenko on 23.04.2022.
//

import UIKit

protocol CommentsViewControllerDelegate: AnyObject {
    func didTapCloseForComments(with viewController: CommentsViewController)
}

class CommentsViewController: UIViewController {
        
    private let post: PostModel
    
    weak var delegate: CommentsViewControllerDelegate?
    
    private var comments = [PostComment]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(CommentTableViewCell.self,
                       forCellReuseIdentifier: CommentTableViewCell.identifier)
        return table
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    init(post: PostModel) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        view.backgroundColor = .white
        fetchPostComments()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.frame = CGRect(x: view.width - 30, y: 10, width: 15, height: 15)
        tableView.frame = CGRect(
            x: 0,
            y: closeButton.bottom,
            width: view.width,
            height: view.height - closeButton.bottom
        )
    }
    
    @objc private func didTapClose() {
        delegate?.didTapCloseForComments(with: self)
    }
    
    private func fetchPostComments() {
        self.comments = PostComment.mockComments()
    }

}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentTableViewCell.identifier,
            for: indexPath
        ) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: comment)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
