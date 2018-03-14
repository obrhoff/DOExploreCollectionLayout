//
//  ExploreCollectionLayout.swift
//  ExploreCollectionLayout
//
//  Created by Dennis Oberhoff on 11.03.18.
//  Copyright © 2018 Dennis Oberhoff. All rights reserved.
//

import UIKit

public enum DOSectionType {
    case hero
    case normal
}

open class DOExploreCollectionLayout: UICollectionViewLayout, UIScrollViewDelegate {
    public weak var delegate: DOExploreCollectionLayoutDelegate?
    public var currentPageIndicatorTintColor = UIColor.white
    public var pageIndicatorTintColor = UIColor.gray

    public private(set) var headerAttributes = [Int: UICollectionViewLayoutAttributes]()
    public private(set) var footerAttributes = [Int: UICollectionViewLayoutAttributes]()
    public private(set) var decorationAttributes = [Int: UICollectionViewLayoutAttributes]()
    public private(set) var itemAttributes = [Int: [Int: UICollectionViewLayoutAttributes]]()
    public private(set) var attributes = [UICollectionViewLayoutAttributes]()

    private var cachedOffsets = [Int: CGPoint]()
    private var cachedScrollFrame = [Int: CGRect]()
    private var attachedScrollViews = [Int: DOScrollView]()
    private var cachedScrollViews = [DOScrollView]()
    private var cachedSize: CGSize = .zero
    private var contentSize: CGSize = .zero
    private let pageIndicatorHeight: CGFloat = 30

    public override init() {
        super.init()
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    private func commonInit() {
        register(DOExplorePagerView.self, forDecorationViewOfKind: String(describing: DOExplorePagerView.self))
    }

    open override func invalidateLayout() {
        reset()
        buildLayout()
        updateLayout()
        super.invalidateLayout()
    }

    private func buildLayout() {
        if (collectionView?.bounds.size.equalTo(.zero)) == true {
            return
        }
        var currentYOffset: CGFloat = 0
        let sections = collectionView?.numberOfSections ?? 0
        let width = collectionView?.bounds.width ?? 0.0

        for section in 0 ..< sections {
            var sectionAttributes = [Int: UICollectionViewLayoutAttributes]()
            var lastAttributes: UICollectionViewLayoutAttributes?
            let rowCount = collectionView?.numberOfItems(inSection: section) ?? 0
            let sectionType = delegate?.collectionView(collectionView, layout: self, typeForSectionAt: section) ?? .normal
            let sectionPath = IndexPath(row: 0, section: section)

            currentYOffset += section == 0 ? contentInsets.top : 0.0
            var beginYOffset = currentYOffset

            if section > 0 {
                let supplementaryKind = UICollectionElementKindSectionHeader
                let headerAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: supplementaryKind,
                                                                       with: sectionPath)
                headerAttribute.size = CGSize(width: width, height: sectionHeaderHeight)
                headerAttribute.frame.origin.x = 0
                headerAttribute.frame.origin.y = currentYOffset + headerDistance
                currentYOffset = headerAttribute.frame.maxY
                beginYOffset = headerAttribute.frame.maxY
                headerAttributes[section] = headerAttribute
            }

            for row in 0 ..< rowCount {
                let isFirst = row == 0
                let lastMaxX = lastAttributes?.frame.maxX ?? (sectionType == .normal ? contentInsets.left : 0.0)
                let indexPath = IndexPath(row: row, section: section)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                if sectionType == .hero {
                    let heroHeight = delegate?.collectionView(collectionView, layout: self, heightForHero: section) ?? self.heroHeight
                    attribute.frame.size = CGSize(width: width, height: heroHeight)
                } else {
                    let itemSize = delegate?.collectionView(collectionView, layout: self, sizeForItemAt: indexPath) ?? self.itemSize
                    attribute.frame.size = itemSize
                }
                attribute.frame.origin.x = lastMaxX + ((sectionType == .normal && !isFirst) ? itemDistance : 0)
                attribute.frame.origin.y = lastAttributes?.frame.minY ?? (beginYOffset + (sectionType == .normal ? itemDistance : 0))
                sectionAttributes[indexPath.row] = attribute
                lastAttributes = attribute
            }

            currentYOffset = sectionAttributes.values.max(by: { $0.frame.maxY > $1.frame.maxY })?.frame.maxY ?? 0.0

            if sectionType == .hero {
                let decoratorIdentifier = String(describing: DOExplorePagerView.self)
                let decoratorAttribute = DOExploreCollectionViewLayoutAttributes(forDecorationViewOfKind: decoratorIdentifier, with: sectionPath)
                decoratorAttribute.frame = CGRect(x: 0, y: currentYOffset - pageIndicatorHeight, width: width, height: pageIndicatorHeight)
                decoratorAttribute.zIndex = 5
                decoratorAttribute.layout = self
                decorationAttributes[section] = decoratorAttribute
            }

            let lastFrame = lastAttributes?.frame ?? .zero
            let sectionHeight = sectionAttributes.values.max(by: { $0.bounds.height > $1.bounds.height })?.bounds.height ?? 0.0
            let sectionWidth = lastFrame.maxX + contentInsets.right
            let sectionFrame = CGRect(x: 0, y: lastFrame.minY, width: sectionWidth, height: sectionHeight)
            itemAttributes[section] = sectionAttributes
            cachedScrollFrame[section] = sectionFrame
        }
        attributes += [headerAttributes, footerAttributes, decorationAttributes].flatMap({ $0.values })
        attributes += itemAttributes.flatMap({ $0.value.values })
        contentSize = CGSize(width: width, height: currentYOffset + contentInsets.bottom)
        cachedSize = collectionView?.bounds.size ?? .zero
    }

    internal func updateLayout() {
        updateLayout(newBounds: nil)
    }

    internal func updateLayout(newBounds: CGRect?) {
        let currentBounds = newBounds ?? collectionView?.bounds ?? .zero
        adjustPageIndicators(newBounds: currentBounds)
        adjustTopHeader(newBounds: currentBounds)
        adjustSections(newBounds: currentBounds)
        adjustScrollViews(newBounds: currentBounds)
    }

    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        updateLayout(newBounds: newBounds)
        return !(newBounds.size.width == cachedSize.width)
    }

    open override func layoutAttributesForSupplementaryView(ofKind _: String, at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
        return headerAttributes[indexPath.section]
    }

    open override func layoutAttributesForDecorationView(ofKind _: String, at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
        return decorationAttributes[indexPath.section]
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes[indexPath.section]?[indexPath.row]
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes?]()
        for section in visibleSections(in: rect) {
            attributes.append(headerAttributes[section])
            attributes.append(footerAttributes[section])
            attributes.append(decorationAttributes[section])
            attributes += itemAttributes[section]?.map({ $0.1 }) ?? [UICollectionViewLayoutAttributes?]()
        }
        return attributes.flatMap({ $0 }).filter({ rect.intersects($0.frame) })
    }

    public func visibleSections(in rect: CGRect) -> [Int] {
        return cachedScrollFrame.filter({ $0.value.intersects(rect) }).map({ $0.key })
    }

    private func adjustPageIndicators(newBounds: CGRect) {
        for section in visibleSections(in: newBounds) {
            let layout = decorationAttributes[section] as? DOExploreCollectionViewLayoutAttributes
            guard let reusableView = layout?.reusableView else {
                continue
            }
            let attributes = itemAttributes[section]
            let decoratorView = reusableView as? DOExplorePagerView
            let midX = collectionView?.bounds.midX ?? 0.0
            let centeredAttribute = attributes?.max { (first, second) -> Bool in
                return fabs(first.value.frame.midX - midX) > fabs(second.value.frame.midX - midX)
            }
            decoratorView?.pageIndicator.numberOfPages = collectionView?.numberOfItems(inSection: section) ?? 0
            decoratorView?.pageIndicator.currentPage = centeredAttribute?.value.indexPath.row ?? 0
        }
    }

    open func adjustTopHeader(newBounds: CGRect) {
        guard stickyHero == true, newBounds.origin.y <= 0, let topAttributes = itemAttributes[0] else { return }
        for attribute in topAttributes {
            var attributeFrame = attribute.value.frame
            attributeFrame.origin.y = newBounds.origin.y + contentInsets.top
            attribute.value.frame = attributeFrame
        }
        let decoratorAttribute = decorationAttributes[0]
        let width = collectionView?.bounds.width ?? 0.0
        let decoratorPath = IndexPath(row: 0, section: 0)
        let maxY = topAttributes.values.max(by: { $0.frame.maxY > $1.frame.maxY })?.frame.maxY ?? 0.0
        decoratorAttribute?.frame = CGRect(x: 0, y: maxY - pageIndicatorHeight, width: width, height: pageIndicatorHeight)

        let invalidationContext = UICollectionViewLayoutInvalidationContext()
        invalidationContext.invalidateItems(at: topAttributes.map({ $0.value.indexPath }))
        invalidationContext.invalidateDecorationElements(ofKind: String(describing: DOExplorePagerView.self), at: [decoratorPath])
        invalidateLayout(with: invalidationContext)
    }

    private func adjustSections(newBounds: CGRect) {
        for section in visibleSections(in: newBounds) {
            let scrollView = attachedScrollViews[section]
            let contentOffset = scrollView?.contentOffset ?? .zero
            if cachedOffsets[section]?.equalTo(contentOffset) == true {
                continue
            }
            let invalidationAttributes = itemAttributes[section]
            let sectionType = delegate?.collectionView(collectionView, layout: self, typeForSectionAt: section) ?? .normal
            let margin: CGFloat = sectionType == .normal ? contentInsets.left : 0.0

            let minX = (invalidationAttributes?.reduce(CGFloat.greatestFiniteMagnitude, { currentX, attribute in
                min(currentX, attribute.value.frame.minX)
            }) ?? 0.0) - margin

            let offset = -contentOffset.x - minX
            invalidationAttributes?.forEach({ attribute in
                attribute.value.frame = attribute.value.frame.offsetBy(dx: offset, dy: 0.0)
            })
            cachedOffsets[section] = contentOffset
            delegate?.collectionView(collectionView, layout: self, section: section, scrollOffset: contentOffset)
        }
        let context = UICollectionViewLayoutInvalidationContext()
        invalidateLayout(with: context)
    }

    private func adjustScrollViews(newBounds: CGRect) {
        let visibleSections = self.visibleSections(in: newBounds)
        let addSections = visibleSections.filter({ !attachedScrollViews.keys.contains($0) })
        let removeSections = attachedScrollViews.filter({ !visibleSections.contains($0.key) }).map({ $0.key })

        for removeSection in removeSections {
            guard let scrollView = attachedScrollViews.removeValue(forKey: removeSection) else { return }
            collectionView?.removeGestureRecognizer(scrollView.panGestureRecognizer)
            cachedOffsets[removeSection] = scrollView.contentOffset
            cachedScrollViews.append(scrollView)
        }

        for addSection in addSections {
            let sectionType = delegate?.collectionView(collectionView, layout: self, typeForSectionAt: addSection) ?? .normal
            let scrollView = cachedScrollViews.popLast() ?? DOScrollView(frame: .zero)
            scrollView.frame = collectionView?.bounds ?? .zero
            scrollView.delegate = self
            scrollView.decelerationRate = UIScrollViewDecelerationRateNormal
            scrollView.isPagingEnabled = sectionType == .hero
            scrollView.bounces = sectionType == .normal
            scrollView.alwaysBounceHorizontal = true
            scrollView.sectionFrame = cachedScrollFrame[addSection] ?? .zero
            scrollView.contentSize = scrollView.sectionFrame.size
            scrollView.contentOffset = cachedOffsets[addSection] ?? .zero
            attachedScrollViews[addSection] = scrollView

            let gesture = scrollView.panGestureRecognizer
            gesture.maximumNumberOfTouches = 1
            gesture.name = String(describing: DOScrollView.self)
            collectionView?.addGestureRecognizer(gesture)
        }
    }

    public func scrollViewDidScroll(_: UIScrollView) {
        updateLayout()
    }

    private func reset() {
        headerAttributes.removeAll()
        footerAttributes.removeAll()
        decorationAttributes.removeAll()
        itemAttributes.removeAll()
        attributes.removeAll()
    }

    open override var collectionViewContentSize: CGSize {
        return contentSize
    }

    open override class var layoutAttributesClass: AnyClass {
        return DOExploreCollectionViewLayoutAttributes.self
    }

    public var stickyHero = false {
        didSet {
            invalidateLayout()
        }
    }

    public var sectionHeaderHeight: CGFloat = 50 {
        didSet {
            invalidateLayout()
        }
    }

    public var heroHeight: CGFloat = 300 {
        didSet {
            invalidateLayout()
        }
    }

    public var itemSize: CGSize = CGSize(width: 100, height: 100) {
        didSet {
            invalidateLayout()
        }
    }

    public var headerDistance: CGFloat = 20 {
        didSet {
            invalidateLayout()
        }
    }

    public var contentInsets = UIEdgeInsets(top: 0, left: 10, bottom: 40, right: 10) {
        didSet {
            invalidateLayout()
        }
    }

    public var itemDistance: CGFloat = 10 {
        didSet {
            invalidateLayout()
        }
    }

    deinit {
        reset()
    }
}
