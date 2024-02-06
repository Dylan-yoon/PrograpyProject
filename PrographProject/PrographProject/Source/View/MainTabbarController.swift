//
//  MainTabbarController.swift
//  PrographProject
//
//  Created by Dylan_Y on 1/29/24.
//

import UIKit

final class MainTabbarController: UITabBarController {
    private let mainTabImageName = "house"
    private let secondTabImageName = "cards"
    
    private let mainViewController = MainViewController()
    private let secondViewController = RandomPhotoViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabbar()
    }
    
    private func configureTabbar() {
        setViewControllers([mainViewController, secondViewController], animated: true)
        
        mainViewController.tabBarItem.image = UIImage(named: mainTabImageName)
        secondViewController.tabBarItem.image = UIImage(named: secondTabImageName)
        tabBar.backgroundColor = .label
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .systemGray
        
        configureTabbarAppearance()
    }
    
    private func configureTabbarAppearance() {
        let tabbarAppearance = UITabBarAppearance()
        
        tabbarAppearance.backgroundColor = .black
        tabBar.standardAppearance = tabbarAppearance
        tabBar.scrollEdgeAppearance = tabbarAppearance
    }
}
