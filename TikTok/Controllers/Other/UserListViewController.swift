//
//  UserListViewController.swift
//  TikTok
//
//  Created by Ivan Potapenko on 20.04.2022.
//

import UIKit

class UserListViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()

    private let noUsersLabel: UILabel = {
        let label = UILabel()
        label.text = "No Users"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()

    enum ListType: String {
        case followers
        case following
    }

    let user: User
    let type: ListType
    public var users = [String]()

    // MARK: - Init

    init(type: ListType, user: User) {
        self.type = type
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        switch type {
        case .followers:
            title = "Followers"
        case .following:
            title = "Following"
        }

        if users.isEmpty {
            view.addSubview(noUsersLabel)
            noUsersLabel.sizeToFit()
        } else {
            tableView.delegate = self
            tableView.dataSource = self
            view.addSubview(tableView)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if tableView.superview == view {
            tableView.frame = view.bounds
        } else {
            noUsersLabel.center = view.center
        }

    }

}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = users[indexPath.row].lowercased()
        return cell
    }

}
