//
//  RandomCardView.swift
//  PrographProject
//
//  Created by Dylan_Y on 2/3/24.
//

import UIKit

protocol RandomCardViewDelegate: AnyObject {
    func infoButtonTapped(id: String)
}

class RandomCardView: UIView, UIGestureRecognizerDelegate {
    
    private var allData: [ImageData] = []
    private var index: Int = 0
    
    weak var delegate: RandomCardViewDelegate?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "praha")
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
            
        return imageView
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        
        button.setImage(.x.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 26
        
        return button
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton()
        
        button.setImage(.bookmark.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.contentMode = .scaleAspectFit
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 36
        
        return button
    }()
    
    let infoButton: UIButton = {
        let button = UIButton()
        
        button.setImage(.information.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 26
        
        return button
    }()
    
    var stackView: UIStackView = {
        let stackview = UIStackView()
        
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.distribution = .equalSpacing
        stackview.spacing = 10
        stackview.translatesAutoresizingMaskIntoConstraints = false
        
        return stackview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureView()
        configureLayout()
        addGesture()
        addTargetButtons()
        
        inins()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.cornerRadius = 12
    }
    
    private func configureLayout() {
        [imageView, stackView].forEach(addSubview(_:))
        [cancelButton, bookmarkButton, infoButton].forEach(stackView.addArrangedSubview(_:))
        
        self.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        let margin = self.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: margin.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1-(120/421)),
            
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: margin.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: margin.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: margin.bottomAnchor),
            
            cancelButton.widthAnchor.constraint(equalToConstant: 52),
            cancelButton.heightAnchor.constraint(equalToConstant: 52),
            
            bookmarkButton.widthAnchor.constraint(equalToConstant: 72),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 72),
            
            infoButton.widthAnchor.constraint(equalToConstant: 52),
            infoButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
}

//MARK: - DataFetch

extension RandomCardView {
    
    private func inins() {
        fetchFiveData(count: 1) {
            DispatchQueue.main.async {
                self.imageView.image = self.allData.first?.uiimage
            }
        }
        
        fetchFiveData(count: 5) {}
    }
    
    private func fetchFiveData(count: Int ,completion: @escaping () -> Void) {
        let api = UnsplashAPI.random(count: count)
        
        NetworkManager.fetchData(api: api) { result in
            switch result {
            case .success(let mainImageDtaDTO):
                
                for data in mainImageDtaDTO {
                    NetworkManager.fetchImage(urlString: data.urls.regular) { result in
                        switch result {
                        case .success(let imageData):
                            let processedData = ImageData(id: data.id,
                                                          description: data.description,
                                                          urlString: data.urls.regular,
                                                           uiimage: imageData,
                                                           userName: data.user.username
                            )
                            self.allData.append(processedData)
                            completion()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}

//MARK: - ButtonAction
extension RandomCardView {
    
    private func addTargetButtons() {
        cancelButton.addTarget(nil, action: #selector(tapCancelButton), for: .touchUpInside)
        bookmarkButton.addTarget(nil, action: #selector(tapBookmarkButton), for: .touchUpInside)
        infoButton.addTarget(nil, action: #selector(tapInfoButton), for: .touchUpInside)
    }
    
    @objc private func tapCancelButton() {
        rightToLeftAnimation()
    }
    
    @objc private func tapBookmarkButton() {
        addBookmark()
        leftToRightAnimation()
    }
    
    @objc private func tapInfoButton() {
        // 데이터 전송
        delegate?.infoButtonTapped(id: allData[index].id)
    }
    
    private func nextCard() {
        index += 1
        if index > allData.count - 4 {
            fetchFiveData(count: 5) {}
        }
    }
    
    private func addBookmark() {
        do {
            try CoreDataManager.shared.saveData(
                BookmarkData(
                    detail: allData[self.index].description,
                    id: allData[self.index].id,
                    url: "")
            )
        } catch {
            fatalError("CoreData Save Error")
        }
    }
}

extension RandomCardView {
    
    private func addGesture() {
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftToRight))
        swipeRightGestureRecognizer.direction = .right
        self.addGestureRecognizer(swipeRightGestureRecognizer)
        
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightToLeft))
        swipeLeftGestureRecognizer.direction = .left
        self.addGestureRecognizer(swipeLeftGestureRecognizer)
    }
    
    @objc private func swipeLeftToRight() {
        addBookmark()
        leftToRightAnimation()
    }
    
    @objc private func swipeRightToLeft() {
        rightToLeftAnimation()
    }
    
    private func leftToRightAnimation() {
        nextCard()
        
        UIView.transition(with: self, duration: 1,options: .transitionFlipFromLeft) {
            self.imageView.image = self.allData[self.index].uiimage
        }
    }
    
    private func rightToLeftAnimation() {
        nextCard()
        
        UIView.transition(with: self, duration: 1,options: .transitionFlipFromRight) {
            self.imageView.image = self.allData[self.index].uiimage
        }
    }
}
