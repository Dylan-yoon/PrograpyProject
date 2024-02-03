//
//  MainViewController.swift
//  PrographProject
//
//  Created by Dylan_Y on 1/29/24.
//

import UIKit

final class MainViewController: UIViewController {
    
    //    private let viewModel = MainViewModel()
    private var dataSource: UICollectionViewDiffableDataSource<MainSection, ImageData>?
    
    private let logoView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage.prographyLogo
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .mainlayout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureLayout()
        configureCollectionView()
        configureDataSource()
        configureSectionOfSnapshot()
        configureBookmarkData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func configureCollectionView() {
        self.collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.id)
        collectionView.register(MainHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainHeaderView.id)
    }
    
    private func configureDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<MainSection, ImageData>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.id, for: indexPath) as! PhotoCell
            
            let image = itemIdentifier.uiimage ?? UIImage(resource: .praha)
            let title = itemIdentifier.userName ?? "Prograpy"
            
            cell.configure(with: image, title: title)
            
            return cell
        })
        
        // Header
        let headerRegistration = UICollectionView.SupplementaryRegistration<MainHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) {
            (supplementaryView, string, indexPath) in
            switch indexPath.section {
            case 0:
                supplementaryView.configure(with: "북마크")
            case 1:
                supplementaryView.configure(with: "최신 이미지")
            default:
                supplementaryView.configure(with: "Unknown Section: \(indexPath.section)")
            }
        }
        
        dataSource?.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: index)
        }
    }
    
    private func configureSectionOfSnapshot() {
        guard var snapshot = dataSource?.snapshot() else {
            fatalError("DATASOURCE ERROR")
        }
        snapshot.appendSections([.bookmark, .recents])
        dataSource?.apply(snapshot)
    }
    
    private func configureBookmarkData() {
        
        switch CoreDataManager.shared.fetchData() {
        case .success(let bookmarkDatas):
            
            guard var snapshot = dataSource?.snapshot() else {
                fatalError("DATASOURCE ERROR")
            }
            
            for bookmarkData in bookmarkDatas {
                print(bookmarkData)
                
                guard let id = bookmarkData.id else {
                    print("here?")
                    return
                }
                
                var image: UIImage? = nil
                
                if let imageData = bookmarkData.imageData {
                    image = UIImage(data: imageData)
                }
                
                
                snapshot.appendItems([ImageData(id: id,
                                                description: bookmarkData.detail,
                                                urlString: bookmarkData.url,
                                                uiimage: image,
                                                userName: bookmarkData.username)],
                                     toSection: .bookmark)
            }
            
            print(snapshot.itemIdentifiers)
            dataSource?.apply(snapshot)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}

//MARK: - CollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainHeaderView.id, for: indexPath) as! MainHeaderView
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

//MARK: - Layout
extension MainViewController {
    private func configureLayout() {
        view.addSubview(logoView)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            logoView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            logoView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        logoView.setContentHuggingPriority(.required, for: .vertical)
    }
}
