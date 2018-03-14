//
//  ViewController.swift
//  ExploreCollectionLayout
//
//  Created by Dennis Oberhoff on 12.03.18.
//  Copyright © 2018 Dennis Oberhoff. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func loadView() {
        view = UICollectionView(frame: .zero, collectionViewLayout: DOExploreCollectionLayout())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.black
        collectionView?.dataSource = self
        collectionView?.register(DOExploreCollectionCell.self, forCellWithReuseIdentifier: String(describing: DOExploreCollectionCell.self))
        collectionView?.register(DOExploreHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                 withReuseIdentifier: String(describing: DOExploreHeaderView.self))
        layout?.sectionHeaderHeight = 30
        layout?.heroHeight = 240
        layout?.itemSize = CGSize(width: 150, height: 250)
        layout?.delegate = self
    }

    var collectionView: UICollectionView? {
        return view as? UICollectionView
    }

    var layout: DOExploreCollectionLayout? {
        return collectionView?.collectionViewLayout as? DOExploreCollectionLayout
    }

    func typeForSection(section: Int) -> DOSectionType {
        return section % 5 == 0 ? .hero : .normal
    }
}

extension ViewController: DOExploreCollectionLayoutDelegate {
    func collectionView(_: UICollectionView?, layout _: DOExploreCollectionLayout, typeForSectionAt section: Int) -> DOSectionType {
        return typeForSection(section: section)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let identifier = String(describing: DOExploreHeaderView.self)
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
        let header = reusableView as? DOExploreHeaderView
        header?.titleLabel.text = "Header \(indexPath.section)"
        return reusableView
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = typeForSection(section: indexPath.section)
        let imageName = (type == .normal ? "Poster" : "Backdrop") + String((indexPath.row + indexPath.section) % 7)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DOExploreCollectionCell.self), for: indexPath)
        let exploreCell = cell as? DOExploreCollectionCell
        exploreCell?.imageView.image = UIImage(named: imageName)
        exploreCell?.gradientView.isHidden = type == .normal
        return cell
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return 15
    }

    func numberOfSections(in _: UICollectionView) -> Int {
        return 100
    }
}
