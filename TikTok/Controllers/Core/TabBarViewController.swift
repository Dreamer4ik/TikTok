//
//  TabBarViewController.swift
//  TikTok
//
//  Created by Ivan Potapenko on 20.04.2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpControllers()
    }
    
    
    private func setUpControllers() {
        
        let home = HomeViewController()
        let explore = ExploreViewController()
        let camera = CameraViewController()
        let notifications = NotificationsViewController()
        let profile = ProfileViewController()
        
        home.title = "Home"
        explore.title = "Explore"
        notifications.title = "Notifications"
        profile.title = "Profile"
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: explore)
        let nav3 = UINavigationController(rootViewController: notifications)
        let nav4 = UINavigationController(rootViewController: profile)
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Explore", image: UIImage(systemName: "safari"), tag: 2)
        
        camera.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "buttonCamera"), tag: 3)
        camera.tabBarItem.imageInsets = UIEdgeInsets.init(top: 5,left: 0,bottom: -5,right: 0)
        

        nav3.tabBarItem = UITabBarItem(title: "Notifications", image: UIImage(systemName: "bell"), tag: 4)
        nav4.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 5)
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .black
            tabBar.tintColor = .white
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
            
        }else {
            tabBar.tintColor = .white
            tabBar.backgroundColor = .black
        }
    
        setViewControllers([nav1,nav2,camera,nav3,nav4], animated: false)
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                appearance.backgroundColor = .black
                tabBar.tintColor = .white
                tabBar.standardAppearance = appearance
                tabBar.scrollEdgeAppearance = tabBar.standardAppearance
                
            }else {
                tabBar.tintColor = .white
                tabBar.backgroundColor = .black
            }
        }
        else if item.tag == 2 {
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                appearance.backgroundColor = .secondarySystemBackground
                tabBar.tintColor = .black
                tabBar.standardAppearance = appearance
                tabBar.scrollEdgeAppearance = tabBar.standardAppearance
                
            }else {
                tabBar.tintColor = .black
                tabBar.backgroundColor = .secondarySystemBackground
            }

        }
        else if item.tag == 3 {
            
        }
        else if item.tag == 4 {
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                appearance.backgroundColor = .secondarySystemBackground
                tabBar.tintColor = .black
                tabBar.standardAppearance = appearance
                tabBar.scrollEdgeAppearance = tabBar.standardAppearance
                
            }else {
                tabBar.tintColor = .black
                tabBar.backgroundColor = .secondarySystemBackground
            }
        }
        else if item.tag == 5 {
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                appearance.backgroundColor = .secondarySystemBackground
                tabBar.tintColor = .black
                tabBar.standardAppearance = appearance
                tabBar.scrollEdgeAppearance = tabBar.standardAppearance
                
            }else {
                tabBar.tintColor = .black
                tabBar.backgroundColor = .secondarySystemBackground
            }
        }
    }
    
    
}
