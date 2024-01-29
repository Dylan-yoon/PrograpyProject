//
//  MainTabbarController.swift
//  PrographProject
//
//  Created by Dylan_Y on 1/29/24.
//

import UIKit

class MainTabbarController: UITabBarController {
    
    let firstVC = FirstViewController()
    let secondVC = SecondViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setViewControllers([
            firstVC,
            secondVC
        ], animated: true)
        
        firstVC.tabBarItem.image = UIImage(systemName: "list.bullet")
        firstVC.tabBarItem.selectedImage = UIImage(systemName: "list.bullet.circle.fill")
        
        secondVC.tabBarItem.image = UIImage(systemName: "magnifyingglass.circle")
        secondVC.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")
        // Do any additional setup after loading the view.
    }
}

class FirstViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
    }
}

class SecondViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = .systemMint
    }
}
