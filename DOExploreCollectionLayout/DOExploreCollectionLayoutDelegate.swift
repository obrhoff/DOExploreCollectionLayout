//
//  DOExploreCollectionLayoutDelegate.swift
//  DOExploreCollectionLayout
//
//  Created by Dennis Oberhoff on 13.03.18.
//  Copyright © 2018 Dennis Oberhoff. All rights reserved.
//

import Foundation
import UIKit

public protocol DOExploreCollectionLayoutDelegate: class {
    func collectionView(_: UICollectionView?, layout _: DOExploreCollectionLayout, sizeForMore section: Int)
        -> CGSize

    func collectionView(_: UICollectionView?, layout _: DOExploreCollectionLayout, typeForSectionAt section: Int)
        -> DOSectionType

    func collectionView(_: UICollectionView?, layout: DOExploreCollectionLayout, heightForHero section: Int)
        -> CGFloat

    func collectionView(_: UICollectionView?, layout: DOExploreCollectionLayout, sizeForItemAt: IndexPath)
        -> CGSize

    func collectionView(_: UICollectionView?, layout: DOExploreCollectionLayout, section: Int, scrollOffset: CGPoint)
}

public extension DOExploreCollectionLayoutDelegate {
    func collectionView(_: UICollectionView?, layout _: DOExploreCollectionLayout, sizeForMore section: Int)
        -> CGSize { return .zero }

    func collectionView(_: UICollectionView?, layout: DOExploreCollectionLayout,
                        sizeForItemAt _: IndexPath) -> CGSize { return layout.itemSize }

    func collectionView(_: UICollectionView?, layout: DOExploreCollectionLayout,
                        heightForHero _: Int) -> CGFloat { return layout.heroHeight }

    func collectionView(_: UICollectionView?, layout _: DOExploreCollectionLayout,
                        section: Int, scrollOffset: CGPoint) {}

    func collectionView(_: UICollectionView?, layout _: DOExploreCollectionLayout,
                        typeForSectionAt section: Int) -> DOSectionType { return .normal }
}
