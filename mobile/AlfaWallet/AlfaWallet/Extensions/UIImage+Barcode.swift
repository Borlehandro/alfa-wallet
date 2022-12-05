//
//  UIImage+Barcode.swift
//  AlfaWallet
//
//  Created by Кирилл Прокофьев on 04.12.2022.
//

import UIKit

extension UIImage {

    convenience init?(barcode: String) {
        let data = barcode.data(using: .ascii)
        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else {
            return nil
        }

//        let backgroundColor: CIColor = CIColor(cgColor: UIColor.clear.cgColor)
//        let barcodeColor: CIColor = CIColor(cgColor: UIColor.white.cgColor)
//
//        filter.setValue(barcodeColor, forKey: "inputColor0")
//        filter.setValue(backgroundColor, forKey: "inputColor1")

        filter.setValue(0, forKey: "inputQuietSpace")
        filter.setValue(data, forKey: "inputMessage")
        guard let ciImage = filter.outputImage else {
            return nil
        }
        self.init(ciImage: ciImage)
    }

}
