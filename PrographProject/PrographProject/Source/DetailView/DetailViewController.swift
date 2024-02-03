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
    
    private var activityIndicator = UIActivityIndicatorView()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        
        button.setImage(.x, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        
        return button
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "USER NAME"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .white
        
        return label
    }()
    
    private let downLoadButton: UIButton = {
        let button = UIButton()
        
        button.setImage(.download.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let bookMarkButton: UIButton = {
        let button = UIButton()
        
        button.isOpaque = true
        button.setImage(.bookmark.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .white
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2
        label.text = "DESCRIPTION DESCRIPTION DESCRIPTION prahaDESCRIPTION prahaDESCRIPTION "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .white
        
        return label
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        
        label.text = "#TAG #TAG"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .white
        
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
        
    }
}

extension DetailViewController {
    private func configureLayout() {
        
        [cancelButton, userNameLabel, downLoadButton, bookMarkButton, imageContentsView, bottomStackView].forEach(view.addSubview(_:))
        [titleLabel, descriptionLabel, tagLabel].forEach(bottomStackView.addArrangedSubview(_:))
        
        view.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        let margin = view.layoutMarginsGuide
        
        // TOP
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: margin.topAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            cancelButton.widthAnchor.constraint(equalTo: cancelButton.heightAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: view.frame.height/20),
            
            userNameLabel.topAnchor.constraint(equalTo: cancelButton.topAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 10),
            userNameLabel.trailingAnchor.constraint(equalTo: downLoadButton.leadingAnchor, constant: -10),
            userNameLabel.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            
            downLoadButton.topAnchor.constraint(equalTo: cancelButton.topAnchor),
            downLoadButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            downLoadButton.trailingAnchor.constraint(equalTo: bookMarkButton.leadingAnchor, constant: -10),
            downLoadButton.widthAnchor.constraint(equalTo: downLoadButton.heightAnchor),
            
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
        
        //activityIndicator
        imageContentsView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func configureButton() {
        cancelButton.layer.cornerRadius = view.frame.size.height/40
    }
    
    private func configureInitBookMarkButton() {
        switch detailType {
        case .mainBookmark:
            bookMarkButton.layer.opacity = 0.3
        case .mainRecent:
            bookMarkButton.layer.opacity = 1
        case .cardView:
            bookMarkButton.layer.opacity = 0.3
        }
    }
    
    private func fetchDataForID() {
        NetworkManager.fetchData(api: .id(id: defaultID)) { result in
            switch result {
            case .success(let data):
                guard let data = data.first else { return }
                
                NetworkManager.fetchImage(urlString: data.urls.regular) { result in
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
        
        guard let imageData = imageData else { return }
        userNameLabel.text = imageData.userName
        imageContentsView.changeImage(uiimage: imageData.uiimage ?? UIImage(resource: .praha))
        guard let description = imageData.description else { return }
        descriptionLabel.text = description
    }
}
