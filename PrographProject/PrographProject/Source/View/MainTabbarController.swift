//
//  MainTabbarController.swift
//  PrographProject
//
//  Created by Dylan_Y on 1/29/24.
//

import UIKit

final class MainTabbarController: UITabBarController {
    let mainTabImageName = "house"
    let secondTabImageName = "cards"
    
    let mainViewController = MainViewController()
    let secondViewController = RandomPhotoViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabbar()
        ConfigureTabbarAppearance()
    }
    
    func configureTabbar() {
        setViewControllers([
            mainViewController,
            secondViewController
        ], animated: true)
        
        mainViewController.tabBarItem.image = UIImage(named: mainTabImageName)
        secondViewController.tabBarItem.image = UIImage(named: secondTabImageName)
        tabBar.backgroundColor = .label
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .systemGray
    }
    
    private func ConfigureTabbarAppearance() {
        let tabbarAppearance = UITabBarAppearance()
        
        tabbarAppearance.backgroundColor = .black
        tabBar.standardAppearance = tabbarAppearance
        tabBar.scrollEdgeAppearance = tabbarAppearance
    }
}
