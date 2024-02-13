//
//  MainViewController.swift
//  PrographProject
//
//  Created by Dylan_Y on 1/29/24.
//

import UIKit

protocol BookMarkConformable: AnyObject {
    func tapBookmark(id: String, isDelete: Bool, imageData: ImageData)
}

final class MainViewController: UIViewController {
    private var dataSource: UICollectionViewDiffableDataSource<MainSection, ImageData>?
    private var page = 0
    
    private let logoView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage.prographyLogo
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .mainlayout)
        
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureLayout()
        configureCollectionView()
        configureBookmarkData()
        fetchThirtyData()
    }
    
    private func configureSectionOfSnapshot() {
        guard var snapshot = dataSource?.snapshot() else {
            fatalError("DATASOURCE ERROR")
        }
        snapshot.appendSections([.bookmark, .recents])
        dataSource?.apply(snapshot)
    }
    
    private func configureBookmarkData() {
        guard var snapshot = dataSource?.snapshot() else {
            fatalError("DATASOURCE ERROR")
        }
        switch CoreDataManager.shared.fetchData() {
        case .success(let bookmarkDatas):
            for bookmarkData in bookmarkDatas {
                var image: UIImage? = nil
                
                guard let id = bookmarkData.id else {
                    return
                }
                
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
            dataSource?.apply(snapshot)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    private func fetchThirtyData() {
        
        NetworkManager.shared.fetchData(with: .main(page: page, perPage: 30, orderBy: .latest)) { result in
            switch result {
            case .success(let mainImageDatas):
                
                for mainImageData in mainImageDatas {
                    
                    NetworkManager.shared.fetchImage(urlString: mainImageData.urls.regular) { result in
                        switch result {
                        case .success(let imageData):
                            DispatchQueue.main.async {
                                let processedData = ImageData(id: mainImageData.id,
                                                              description: mainImageData.description,
                                                              urlString: mainImageData.urls.regular,
                                                              uiimage: imageData,
                                                              userName: mainImageData.user.username
                                )
                                
                                guard var snapshot = self.dataSource?.snapshot() else {
                                    fatalError("SnapShot Binding Error _ Fetch Data")
                                }
                                
                                snapshot.appendItems([processedData], toSection: .recents)
                                self.dataSource?.apply(snapshot)
                            }
                            
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            case .failure(_):
                fatalError("CollectionView Fetch ERROR")
            }
        }
        
        self.page += 1
    }
}

//MARK: - CollectionView
extension MainViewController {
    
    private func configureCollectionView() {
        self.collectionView.delegate = self
        
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.id)
        collectionView.register(MainHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: MainHeaderView.id)
        
        configureDataSource()
        configureSectionOfSnapshot()
    }
    
    private func configureDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<MainSection, ImageData>(collectionView: self.collectionView,
                                                                                     cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.id, for: indexPath) as! PhotoCell
            let image = itemIdentifier.uiimage ?? UIImage(resource: .praha)
            
            if indexPath.section == 0 {
                cell.configure(with: image, title: "")
            } else {
                let title = itemIdentifier.userName ?? "Prograpy"
                cell.configure(with: image, title: title)
            }
            
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
}

//MARK: - CollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                         withReuseIdentifier: MainHeaderView.id,
                                                                         for: indexPath) as! MainHeaderView
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let snapshot = dataSource?.snapshot() else { return }
        
        if indexPath.section == 0 {
            let imageData = snapshot.itemIdentifiers(inSection: .bookmark)
            let detilViewController = DetailViewController(type: .mainBookmark, id: imageData[indexPath.row].id)
            detilViewController.delegate = self
            present(detilViewController, animated: true)
        } else {
            let imageData = snapshot.itemIdentifiers(inSection: .recents)
            let detilViewController = DetailViewController(type: .mainRecent, id: imageData[indexPath.row].id)
            detilViewController.delegate = self
            present(detilViewController, animated: true)
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            fetchThirtyData()
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

//MARK: - Delegate
extension MainViewController: BookMarkConformable {
    func tapBookmark(id: String, isDelete: Bool, imageData: ImageData) {
        if isDelete {
            guard var snapshot = dataSource?.snapshot() else { return }
            snapshot.deleteItems([imageData])
            
            dataSource?.apply(snapshot)
        } else {
            guard var snapshot = dataSource?.snapshot() else { return }
            snapshot.appendItems([imageData], toSection: .bookmark)
            dataSource?.apply(snapshot)
        }
    }
}
