//
//  ExploreViewController.swift
//  TikTok
//
//  Created by Ivan Potapenko on 20.04.2022.
//

import UIKit

class ExploreViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search..."
        bar.layer.cornerRadius = 8
        bar.layer.masksToBounds = true
        return bar
    }()
    
    private var sections = [ExploreSection]()
    
    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configureModels()
        setUpSearchBar()
        setUpCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    private func setUpSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    private func configureModels() {
        var cells = [ExploreCell]()
        for _ in 0...30 {
            let cell = ExploreCell.banner(
                viewModel: ExploreBannerViewModel(
                    image: UIImage(named: "test"),
                    title: "Banner",
                    handler: {
                        
                    }
                )
            )
            cells.append(cell)
        }
        // Banner
        sections.append(
            ExploreSection(
                type: .banners,
                cells: cells
            )
        )
        
        var posts = [ExploreCell]()
        for _ in 0...40 {
            posts.append(
                .post(viewModel: ExplorePostViewModel(thumbnailImage: UIImage(named: "test"), caption: "This is awesome post and a sooooo long caption......", handler: {
                    
                }))
            )
        }
        // Trending posts
        sections.append(
            ExploreSection(
                type: .trendingPosts,
                cells: posts            )
        )
        // Users
        sections.append(
            ExploreSection(
                type: .users,
                cells: [
                    .user(viewModel: ExploreUserViewModel(profilePictureURL: nil,
                                                          username: "potus",
                                                          followerCount: 0,
                                                          handler: {
                                                              
                                                          })),
                    .user(viewModel: ExploreUserViewModel(profilePictureURL: nil,
                                                          username: "dreamer",
                                                          followerCount: 0,
                                                          handler: {
                                                              
                                                          })),
                    .user(viewModel: ExploreUserViewModel(profilePictureURL: nil,
                                                          username: "gordon",
                                                          followerCount: 0,
                                                          handler: {
                                                              
                                                          })),
                    .user(viewModel: ExploreUserViewModel(profilePictureURL: nil,
                                                          username: "kadyk",
                                                          followerCount: 0,
                                                          handler: {
                                                              
                                                          })),
                    .user(viewModel: ExploreUserViewModel(profilePictureURL: nil,
                                                          username: "vyrvu",
                                                          followerCount: 0,
                                                          handler: {
                                                              
                                                          })),
                    .user(viewModel: ExploreUserViewModel(profilePictureURL: nil,
                                                          username: "uk",
                                                          followerCount: 0,
                                                          handler: {
                                                              
                                                          })),
                    .user(viewModel: ExploreUserViewModel(profilePictureURL: nil,
                                                          username: "again",
                                                          followerCount: 0,
                                                          handler: {
                                                              
                                                          })),
                ]
            )
        )
        // Trending hashtags
        sections.append(
            ExploreSection(
                type: .trendingHashTags,
                cells: [
                    .hashtag(viewModel: ExploreHashtagViewModel(text: "foryou", icon: UIImage(systemName: "number.circle"), count: 1, handler: {
                        
                    })),
                    .hashtag(viewModel: ExploreHashtagViewModel(text: "tiktok", icon: UIImage(systemName: "number.circle"), count: 1, handler: {
                        
                    })),
                    .hashtag(viewModel: ExploreHashtagViewModel(text: "awesome", icon: UIImage(systemName: "number.circle"), count: 1, handler: {
                        
                    })),
                    .hashtag(viewModel: ExploreHashtagViewModel(text: "great", icon: UIImage(systemName: "number.circle"), count: 1, handler: {
                        
                    })),
                    .hashtag(viewModel: ExploreHashtagViewModel(text: "fit4life", icon: UIImage(systemName: "number.circle"), count: 1, handler: {
                        
                    })),
                    .hashtag(viewModel: ExploreHashtagViewModel(text: "m1pro", icon: UIImage(systemName: "number.circle"), count: 1, handler: {
                        
                    })),
                ]
            )
        )
        // Recommended
        sections.append(
            ExploreSection(
                type: .recommended,
                cells: posts
            )
        )
        // Popular
        sections.append(
            ExploreSection(
                type: .popular,
                cells: posts
            )
        )
        // new/recent
        sections.append(
            ExploreSection(
                type: .new,
                cells: posts
            )
        )
    }
    
    private func setUpCollectionView() {
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection? in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell"
        )
        
        collectionView.register(ExploreBannerCollectionViewCell.self,
                                forCellWithReuseIdentifier: ExploreBannerCollectionViewCell.identifier
        )
        
        collectionView.register(ExplorePostCollectionViewCell.self,
                                forCellWithReuseIdentifier: ExplorePostCollectionViewCell.identifier
        )
        
        collectionView.register(ExploreUserCollectionViewCell.self,
                                forCellWithReuseIdentifier: ExploreUserCollectionViewCell.identifier
        )
        
        collectionView.register(ExploreHashtagCollectionViewCell.self,
                                forCellWithReuseIdentifier: ExploreHashtagCollectionViewCell.identifier
        )
        
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
        case .banner(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreBannerCollectionViewCell.identifier,
                for: indexPath
            ) as? ExploreBannerCollectionViewCell else {
                return  collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: viewModel)
            return cell
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExplorePostCollectionViewCell.identifier,
                for: indexPath
            ) as? ExplorePostCollectionViewCell else {
                return  collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: viewModel)
            return cell
        case .hashtag(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreHashtagCollectionViewCell.identifier,
                for: indexPath
            ) as? ExploreHashtagCollectionViewCell else {
                return  collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: viewModel)
            return cell
        case .user(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreUserCollectionViewCell.identifier,
                for: indexPath
            ) as? ExploreUserCollectionViewCell else {
                return  collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
        case .banner(let viewModel):
            break
        case .post(let viewModel):
            break
        case .hashtag(let viewModel):
            break
        case .user(let viewModel):
            break
        }
    }
    
    
}

extension ExploreViewController: UISearchBarDelegate {
    
}

// MARK: - Section Layouts

extension ExploreViewController {
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type
        
        switch sectionType {
        case .banners:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4,
                                                         leading: 4,
                                                         bottom: 4,
                                                         trailing: 4)
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(200)
                ),
                subitems: [item])
            // Section Layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            //Return
            return sectionLayout
        case .users:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4,
                                                         leading: 4,
                                                         bottom: 4,
                                                         trailing: 4)
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(150),
                    heightDimension: .absolute(200)
                ),
                subitems: [item])
            // Section Layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            //Return
            return sectionLayout
        case .trendingHashTags:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4,
                                                         leading: 4,
                                                         bottom: 4,
                                                         trailing: 4)
            // Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60)
                ),
                subitems: [item]
            )
            
            // Section Layout
            let sectionLayout = NSCollectionLayoutSection(group: verticalGroup)
            //Return
            return sectionLayout
        case .trendingPosts, .recommended, .new:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4,
                                                         leading: 4,
                                                         bottom: 4,
                                                         trailing: 4)
            // Group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(100),
                    heightDimension: .absolute(300)
                ),
                subitem: item,
                count: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(110),
                                                   heightDimension: .absolute(300)
                                                  ),
                subitems: [verticalGroup])
            // Section Layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            //Return
            return sectionLayout
        case .popular:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4,
                                                         leading: 4,
                                                         bottom: 4,
                                                         trailing: 4)
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(110),
                                                   heightDimension: .absolute(200)
                                                  ),
                subitems: [item]
            )
            // Section Layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            //Return
            return sectionLayout
        }
        
    }
}
