//
//  ExploreCollectionCell.swift
//  ExploreCollectionLayout
//
//  Created by Dennis Oberhoff on 12.03.18.
//  Copyright © 2018 Dennis Oberhoff. All rights reserved.
//

import Foundation
import UIKit

public final class DOExploreCollectionCell: UICollectionViewCell {
    public let imageView = UIImageView()
    public let gradientView = GradientView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        clipsToBounds = true
        layer.backgroundColor = UIColor.darkGray.cgColor

        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        addSubview(gradientView)

        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            gradientView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5, constant: 0.0),
            gradientView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            gradientView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

open class GradientView: UIView {
    open override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

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
        clipsToBounds = true
        backgroundColor = nil
        gradientLayer?.endPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer?.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer?.colors = [
            UIColor.black.withAlphaComponent(0.8),
            UIColor.black.withAlphaComponent(0.0),
        ].flatMap({ $0.cgColor })
        gradientLayer?.locations = [0.0, 1.0].map({ NSNumber(value: $0) })
        gradientLayer?.rasterizationScale = UIScreen.main.scale
        gradientLayer?.shouldRasterize = true
    }

    public var gradientLayer: CAGradientLayer? {
        return layer as? CAGradientLayer
    }

    open override static var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}
