//
//  DOExplorePagerView.swift
//  DOExploreCollectionLayout
//
//  Created by Dennis Oberhoff on 13.03.18.
//  Copyright © 2018 Dennis Oberhoff. All rights reserved.
//

import Foundation
import UIKit

internal final class DOExplorePagerView: UICollectionReusableView {
    public let pageIndicator = UIPageControl()
    private weak var layoutAttribute: DOExploreCollectionViewLayoutAttributes?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        isUserInteractionEnabled = false
        addSubview(pageIndicator)
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        pageIndicator.pageIndicatorTintColor = layoutAttribute?.layout?.pageIndicatorTintColor
        pageIndicator.currentPageIndicatorTintColor = layoutAttribute?.layout?.currentPageIndicatorTintColor
        layoutAttribute?.layout?.updateLayout(forced: false)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        pageIndicator.frame = bounds
    }

    public override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        layoutAttribute = (layoutAttributes as? DOExploreCollectionViewLayoutAttributes)
        layoutAttribute?.reusableView = self
        super.apply(layoutAttributes)
    }
}
