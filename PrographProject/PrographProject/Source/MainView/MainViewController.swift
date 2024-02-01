//
//  MainViewController.swift
//  PrographProject
//
//  Created by Dylan_Y on 1/29/24.
//

import UIKit

class MainViewController: UIViewController {
    
    let viewModel = MainViewModel()
    var dataSource: UICollectionViewDiffableDataSource<MainSection, MockData>!
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .mainlayout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureCollectionView()
        configureLayout()
        configureDataSource()
        
        bb()
        cc()
        cc()
        aa()
        aa()
        
        NetworkManager.fetchData { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print("ERROR다 이놈아 : ", error)
            }
        }
        
    }
    
    private func configureCollectionView() {
        self.collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.id)
        collectionView.register(MainHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainHeaderView.id)
    }
    
    private func configureLayout() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    private func configureDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<MainSection, MockData>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.id, for: indexPath) as! PhotoCell
            
            cell.configure(with: UIImage(named: itemIdentifier.imageName)!, title: itemIdentifier.title)
            
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
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: index)
        }
    }
    
    func bb() {
        var snapshot = dataSource.snapshot()
        snapshot.appendSections([.bookmark, .recents])
        dataSource.apply(snapshot)
    }
    
    func aa() {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([MockData(imageName: "praha", title: "asdfasdfasdfasdf")], toSection: .recents)
        dataSource.apply(snapshot)
    }
    
    func cc() {
        var snapshot = dataSource.snapshot()
        
        let data = MockData.generateMockDatas()
        
        for i in data {
            snapshot.appendItems([i], toSection: .recents)
        }
        snapshot.appendItems([MockData(imageName: "praha", title: "asdfasdfasdfasdf")], toSection: .bookmark)
        snapshot.appendItems([MockData(imageName: "thumbnail-2", title: "thumbnail-2")], toSection: .bookmark)
        snapshot.appendItems([MockData(imageName: "thumbnail-3", title: "thumbnail-3")], toSection: .bookmark)
        
        dataSource.apply(snapshot)
    }
}

//MARK: - CollectionViewDelegate
extension MainViewController:  UICollectionViewDelegate {
    
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
