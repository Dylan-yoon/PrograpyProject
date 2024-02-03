//
//  RandomPhotoViewController.swift
//  PrographProject
//
//  Created by Dylan_Y on 1/30/24.
//

import UIKit

class RandomPhotoViewController: UIViewController {
    
    let logoView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage.prographyLogo
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let cardview: RandomCardView = {
        let card = RandomCardView()
        
        card.translatesAutoresizingMaskIntoConstraints = false
        
        return card
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(logoView)
        view.addSubview(cardview)
        
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            logoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            cardview.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 25),
            cardview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            cardview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            cardview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        logoView.setContentHuggingPriority(.required, for: .vertical)
    }
}
