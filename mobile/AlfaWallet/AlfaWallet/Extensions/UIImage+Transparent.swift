//
//  UIImage+Transparent.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import UIKit

extension UIImage {

    func makeTransparent() -> UIImage? {
        guard let rawImage = self.cgImage else { return nil}
        let colorMasking: [CGFloat] = [255, 255, 255, 255, 255, 255]
        UIGraphicsBeginImageContext(self.size)

        if let maskedImage = rawImage.copy(maskingColorComponents: colorMasking),
            let context = UIGraphicsGetCurrentContext() {
            context.translateBy(
                x: 0.0,
                y: self.size.height
            )
            context.scaleBy(
                x: 1.0,
                y: -1.0
            )
            context.draw(
                maskedImage,
                in: CGRect(x: 0,
                           y: 0,
                           width: self.size.width,
                           height: self.size.height
                          )
            )
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return finalImage
        }

        return nil
    }
}
