//
//  DOScrollView.swift
//  DOExploreCollectionLayout
//
//  Created by Dennis Oberhoff on 13.03.18.
//  Copyright © 2018 Dennis Oberhoff. All rights reserved.
//

import Foundation
import UIKit

internal final class DOScrollView: UIScrollView, UIGestureRecognizerDelegate {
    var sectionFrame: CGRect = .zero

    func gestureRecognizer(_: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer.name == String(describing: DOScrollView.self)
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let collectionView = gestureRecognizer.view as? UICollectionView else { return false }
        let position = panGestureRecognizer.location(in: collectionView)
        return sectionFrame.contains(position)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let collectionView = gestureRecognizer.view as? UICollectionView else { return false }
        let position = touch.location(in: collectionView)
        return sectionFrame.contains(position)
    }
}
