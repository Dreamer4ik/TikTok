//
//  ProfileViewController.swift
//  TikTok
//
//  Created by Ivan Potapenko on 20.04.2022.
//

import UIKit
import ProgressHUD

class ProfileViewController: UIViewController {

    var isCurrentUserProfile: Bool {
        if let username = UserDefaults.standard.string(forKey: "username") {
            return user.username.lowercased() == username.lowercased()
        }
        return false
    }

    enum PicturePickerType {
        case camera
        case photoLibrary
    }

    var user: User

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false

        collectionView.register(
            ProfileHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier
        )

        collectionView.register(PostCollectionViewCell.self,
                                forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        return collectionView
    }()

    private var posts = [PostModel]()

    private var followers = [String]()
    private var following = [String]()
    private var isFollower: Bool = false

    // MARK: - Init

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = user.username.capitalized
        view.backgroundColor = .systemTeal
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self

        let username = UserDefaults.standard.string(forKey: "username")?.capitalized ?? "Me"
        if title == username {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "gear"),
                style: .done,
                target: self,
                action: #selector(didTapSettings)
            )
        }
        fetchPosts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchPosts()
    }

    private func fetchPosts() {
        DatabaseManager.shared.getPosts(for: user) { [weak self] postModels in
            DispatchQueue.main.async {
                self?.posts = postModels.reversed()
                self?.collectionView.reloadData()
            }
        }
    }

    @objc private func didTapSettings() {
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

}

// MARK: - CollectionView

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let postModel = posts[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PostCollectionViewCell.identifier,
            for: indexPath
        ) as? PostCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: postModel)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // open post
        HapticsManager.shared.vibrateForSelection()
        let post = posts[indexPath.row]
        let vc = PostViewController(model: post)
        vc.delegate = self
        vc.title = "Video"
        navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (view.width - 12)/3
        return CGSize(width: width, height: width * 1.5)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier,
                for: indexPath
              ) as? ProfileHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        header.delegate = self

        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()

        DatabaseManager.shared.getRelationships(for: user, type: .followers) { [weak self] followers in
            defer {
                group.leave()
            }
            self?.followers = followers
        }

        DatabaseManager.shared.getRelationships(for: user, type: .following) { [weak self] following in
            defer {
                group.leave()
            }
            self?.following = following
        }

        DatabaseManager.shared.isValidRelationship(
            for: user,
            type: .followers
        ) { [weak self] isFollower in
            defer {
                group.leave()
            }
            self?.isFollower = isFollower
        }

        group.notify(queue: .main) {
            let viewModel = ProfileHeaderViewModel(
                avatarImageURL: self.user.profilePictureURL,
                followerCount: self.followers.count,
                followingCount: self.following.count,
                isFollowing: self.isCurrentUserProfile ? nil : self.isFollower
            )
            header.configure(with: viewModel)
        }

        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.width, height: 300)
    }
}

extension ProfileViewController: ProfileHeaderCollectionReusableViewDelegate {
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel) {

        HapticsManager.shared.vibrateForSelection()

        if isCurrentUserProfile {
            // Edit profile
            let vc = EditProfileViewController()
            let navVC = UINavigationController(rootViewController: vc)
            present(navVC, animated: true)
        } else {
            // Follow or unfollow current users profile that we are viewing
            if self.isFollower {
                // unfollow
                DatabaseManager.shared.updateRelationship(for: user, follow: false) { [weak self] success in
                    if success {
                        DispatchQueue.main.async {
                            self?.isFollower = false
                            self?.collectionView.reloadData()
                        }

                    } else {

                    }
                }
            } else {
                // follow
                DatabaseManager.shared.updateRelationship(for: user, follow: true) { [weak self] success in
                    if success {
                        DispatchQueue.main.async {
                            self?.isFollower = true
                            self?.collectionView.reloadData()
                        }
                    } else {

                    }
                }
            }
        }
    }

    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapFollowersButtonWith viewModel: ProfileHeaderViewModel) {
        HapticsManager.shared.vibrateForSelection()
        let vc = UserListViewController(type: .followers, user: user)
        vc.users = followers
        navigationController?.pushViewController(vc, animated: true)
    }

    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapFollowingButtonWith viewModel: ProfileHeaderViewModel) {
        HapticsManager.shared.vibrateForSelection()
        let vc = UserListViewController(type: .following, user: user)
        vc.users = following
        navigationController?.pushViewController(vc, animated: true)
    }

    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView, didTapAvatarFor viewModel: ProfileHeaderViewModel) {
        guard isCurrentUserProfile else {
            return
        }

        HapticsManager.shared.vibrateForSelection()

        let actionSheet = UIAlertController(title: "Profile Picture", message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.presentProfilePicturePicker(type: .camera)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.presentProfilePicturePicker(type: .photoLibrary)
            }
        }))

        present(actionSheet, animated: true)
    }

    func presentProfilePicturePicker(type: PicturePickerType) {
        let picker = UIImagePickerController()
        picker.sourceType = type == .camera ? .camera : .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }

        ProgressHUD.show("Uploading...")
        StorageManager.shared.uploadProfilePicture(with: image) { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let downloadURL):
                    UserDefaults.standard.setValue(downloadURL.absoluteString, forKey: "profile_picture_url")
                    HapticsManager.shared.vibrateForType(for: .success)
                    strongSelf.user = User(
                        username: strongSelf.user.username,
                        profilePictureURL: downloadURL,
                        identifier: strongSelf.user.identifier
                    )
                    ProgressHUD.showSuccess("Updated!")
                    strongSelf.collectionView.reloadData()
                case .failure:
                    HapticsManager.shared.vibrateForType(for: .error)
                    ProgressHUD.showError("Failed to upload profile picture.")
                }
            }
        }
    }

}

extension ProfileViewController: PostViewControllerDelegate {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel) {
        // Present comments
    }

    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel) {
        // Push another profile
    }

    func didTapFollowButton(_ vc: PostViewController, didTapFollowButtonFor post: PostModel, button: UIButton) {
        // Follow user
    }

}
