//
//  DetailView.swift
//  PrographProject
//
//  Created by Dylan_Y on 2/2/24.
//

import UIKit

enum DetialType: String {
    case mainBookmark
    case mainRecent
    case cardView
}

final class DetailViewController: UIViewController {
    private var detailType: DetialType
    private var imageData: ImageData?
    private var defaultID: String
    private var isBookmarked: Bool
    private var activityIndicator = UIActivityIndicatorView()
    private var unsplashAPI = UnsplashAPI()
    
    weak var delegate: BookMarkConformable?
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        
        button.setImage(.x, for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "USER NAME"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let downLoadButton: UIButton = {
        let button = UIButton()
        
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.download.withRenderingMode(.alwaysTemplate), for: .normal)
        
        return button
    }()
    
    private let bookMarkButton: UIButton = {
        let button = UIButton()
        
        button.isOpaque = true
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.bookmark.withRenderingMode(.alwaysTemplate), for: .normal)
        
        return button
    }()
    
    private let imageContentsView: DetailImageView = {
        let view = DetailImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "TITLE"
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "DESCRIPTION DESCRIPTION DESCRIPTION prahaDESCRIPTION prahaDESCRIPTION "
        
        return label
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .white
        label.text = "#TAG #TAG"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        
        return label
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    init(type: DetialType, id: String) {
        self.detailType = type
        self.defaultID = id
        
        switch detailType {
        case .mainBookmark:
            self.isBookmarked = true
        case .mainRecent:
            self.isBookmarked = false
        case .cardView:
            self.isBookmarked = false
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.92)
        activityIndicator.startAnimating()
        fetchDataForID()
        configureInitBookMarkButton()
        
        configureLayout()
        configureButton()
        
        setAddTarget()
    }
}

//MARK: -Configure Layout
extension DetailViewController {
    
    private func configureLayout() {
        [cancelButton, userNameLabel, downLoadButton, bookMarkButton, imageContentsView, bottomStackView].forEach(view.addSubview(_:))
        [titleLabel, descriptionLabel, tagLabel].forEach(bottomStackView.addArrangedSubview(_:))
        
        let margin = view.layoutMarginsGuide
        view.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        // TOP
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: margin.topAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            cancelButton.widthAnchor.constraint(equalTo: cancelButton.heightAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: view.frame.height/20),
        ])
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: cancelButton.topAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 10),
            userNameLabel.trailingAnchor.constraint(equalTo: downLoadButton.leadingAnchor, constant: -10),
            userNameLabel.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            downLoadButton.topAnchor.constraint(equalTo: cancelButton.topAnchor),
            downLoadButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            downLoadButton.trailingAnchor.constraint(equalTo: bookMarkButton.leadingAnchor, constant: -10),
            downLoadButton.widthAnchor.constraint(equalTo: downLoadButton.heightAnchor),
        ])
        NSLayoutConstraint.activate([
            bookMarkButton.topAnchor.constraint(equalTo: cancelButton.topAnchor),
            bookMarkButton.trailingAnchor.constraint(equalTo: margin.trailingAnchor, constant: -10),
            bookMarkButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            bookMarkButton.widthAnchor.constraint(equalTo: bookMarkButton.heightAnchor),
            bookMarkButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
        ])
        
        // Image
        NSLayoutConstraint.activate([
            imageContentsView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: 15),
            imageContentsView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            imageContentsView.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            imageContentsView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -10)
        ])
        
        // Bottom
        NSLayoutConstraint.activate([
            bottomStackView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: margin.bottomAnchor)
        ])
        
        // ActivityIndicator
        imageContentsView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func configureButton() {
        cancelButton.layer.cornerRadius = view.frame.size.height/40
    }
    
    private func configureInitBookMarkButton() {
        if isBookmarked {
            bookMarkButton.layer.opacity = 0.3
        } else {
            bookMarkButton.layer.opacity = 1
        }
    }
}

// MARK: - FetchMethod
extension DetailViewController {
    
    private func fetchDataForID() {
        unsplashAPI.fetchData(with: defaultID) { result in
            switch result {
            case .success(let data):
//                guard let data = data else { return }
                
                NetworkManager.shared.fetchImage(urlString: data.urls.regular) { result in
                    switch result {
                    case .success(let image):
                        self.imageData = .init(id: data.id, description: data.description, urlString: data.urls.regular, uiimage: image, userName: data.user.username)
                        
                        DispatchQueue.main.async {
                            self.configureViewData()
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureViewData() {
        // 인디케이터 종료
        activityIndicator.stopAnimating()
        
        guard let imageData = imageData else {
            let data = ImageData.defaultData()
            
            userNameLabel.text = data.userName
            imageContentsView.changeImage(uiimage: data.uiimage ?? UIImage(resource: .praha))
            descriptionLabel.text = data.description
            
            return
        }
        
        if let description = imageData.description {
            descriptionLabel.text = description
        } else {
            descriptionLabel.text = "DESCRIPTION"
        }
        userNameLabel.text = imageData.userName
        imageContentsView.changeImage(uiimage: imageData.uiimage ?? UIImage(resource: .praha))
    }
}

//MARK: - Target Method
extension DetailViewController {
    
    private func setAddTarget() {
        cancelButton.addTarget(self, action: #selector(tapCancelButton), for: .touchUpInside)
        downLoadButton.addTarget(self, action: #selector(tapDownloadButton), for: .touchUpInside)
        bookMarkButton.addTarget(self, action: #selector(tapBookMarkButton), for: .touchUpInside)
    }
    
    @objc private func tapCancelButton() {
        self.dismiss(animated: true)
    }
    
    @objc private func tapDownloadButton() {
        
    }
    
    @objc private func tapBookMarkButton() {
        guard let imageData = imageData else {
            return
        }
        
        if isBookmarked {
            
            do {
                try CoreDataManager.shared.deleteDate(id: imageData.id)
            } catch {
                debugPrint(error.localizedDescription)
            }
        } else {
            
            let data = imageData.uiimage?.pngData()
            
            let bookmarkdata = BookmarkData(detail: imageData.description,
                                            id: imageData.id,
                                            url: imageData.urlString,
                                            username: imageData.userName,
                                            imageData: data)
            do {
                try CoreDataManager.shared.saveData(bookmarkdata)
            } catch {
                print(error.localizedDescription)
            }
            
        }
        
        delegate?.tapBookmark(id: imageData.id, isDelete: isBookmarked, imageData: imageData)
        isBookmarked.toggle()
        configureInitBookMarkButton()
    }
}
