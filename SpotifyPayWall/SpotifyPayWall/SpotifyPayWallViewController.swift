//
//  SpotifyPayWallViewController.swift
//  SpotifyPayWall
//
//  Created by Kay on 2022/08/29.
//

import UIKit

enum Section {
    case main
}

class SpotifyPayWallViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let colors: [UIColor] = [.systemPurple,.systemOrange, .systemPink, .systemRed]
    let info: [BannerInfo] = BannerInfo.list
    typealias Item = BannerInfo
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alwaysBounceVertical = false
        // Presentation
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as? BannerCollectionViewCell else {
                return nil
            }
            cell.configure(itemIdentifier)
            cell.backgroundColor = self.colors[indexPath.item]
            return cell
        })
        
        // Data -> snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(info, toSection: .main)
        dataSource.apply(snapshot)
        
        // Layout
        collectionView.collectionViewLayout = layout()
        
        // Page Control
        pageControl.numberOfPages = info.count
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        section.visibleItemsInvalidationHandler = { (item, offset, env) in
            let index = Int((offset.x / env.container.contentSize.width).rounded(.up))
            print(">>>> \(index)")
            self.pageControl.currentPage = index
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
