//
//  DetailImageView.swift
//  PrographProject
//
//  Created by Dylan_Y on 2/2/24.
//

import UIKit

class DetailImageView: UIView {
    
    private var idimage = UIImage()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // TODO: 기본이미지 삭제
        imageView.image = UIImage(named: ["praha", "thumbnail", "thumbnail-2", "thumbnail-3", "praha2"].randomElement()!)
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeImage(name: String) {
        let a = ["praha", "thumbnail", "praha3", "praha2"]
        imageView.image = UIImage(named: a.randomElement()!)
    }
    
    func configureContents() {
        guard let image = imageView.image else { return }
        
        let imageRatio = image.size.height/image.size.width
        let frameRatio = self.frame.size.height/self.frame.size.width
        
        if imageRatio >= frameRatio {
            imageView.contentMode = .scaleAspectFill
        } else {
            imageView.contentMode = .scaleAspectFit
        }
        
        layoutIfNeeded()
    }
}
