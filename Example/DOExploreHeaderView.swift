//
//  ExploreHeaderView.swift
//  ExploreCollectionLayout
//
//  Created by Dennis Oberhoff on 12.03.18.
//  Copyright © 2018 Dennis Oberhoff. All rights reserved.
//

import Foundation
import UIKit

public final class DOExploreHeaderView: UICollectionReusableView {
    public let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func configure() {
        layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = UIColor.white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            titleLabel.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }
}
