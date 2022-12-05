//
//  CardsOverlappingFlowLayout.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import UIKit

class CardsOverlappingLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        // This allows us to make intersection and overlapping
        // A negative number implies overlapping whereas positive implies space between the adjacent edges of two cells.
        minimumLineSpacing = -92
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        for currentLayoutAttributes: UICollectionViewLayoutAttributes in layoutAttributes! {
            // zIndex - Specifies the item’s position on the z-axis.
            // Unlike a layer's zPosition, changing zIndex allows us to change not only layer position,
            // but tapping/UI interaction logic too as it moves the whole item.
            currentLayoutAttributes.zIndex = currentLayoutAttributes.indexPath.row + 1
        }
        return layoutAttributes
    }
}
