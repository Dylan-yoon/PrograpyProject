//
//  RandomPhotoViewController.swift
//  PrographProject
//
//  Created by Dylan_Y on 1/30/24.
//

import UIKit

class RandomPhotoViewController: UIViewController {
    
    private let logoView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage.prographyLogo
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let cardView: RandomCardView = {
        let card = RandomCardView()
        
        card.translatesAutoresizingMaskIntoConstraints = false
        
        return card
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        cardView.delegate = self
        
        configureLayout()
    }
    
    private func configureLayout() {
        view.addSubview(logoView)
        view.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            logoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 25),
            cardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            cardView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        logoView.setContentHuggingPriority(.required, for: .vertical)
    }
}

extension RandomPhotoViewController: RandomCardViewDelegate {
    func infoButtonTapped(id: String) {
        present(DetailViewController(type: .cardView, id: id), animated: true)
    }
}
