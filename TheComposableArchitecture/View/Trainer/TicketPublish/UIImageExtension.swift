//
//  UIImageExtension.swift
//  TheComposableArchitecture
//
//  Created by 東　秀斗 on 2022/09/01.
//

import Foundation
import UIKit

extension UIImage {
    static func makeQrCode(text: String) -> UIImage? {
        guard let textUTF = text.data(using: .utf8) else { return nil }
        guard let qr = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": textUTF]) else { return nil }
        let cGAffineTransform: CGAffineTransform = CGAffineTransform(scaleX: 8, y: 8)
        guard let ciImage = qr.outputImage?.transformed(by: cGAffineTransform) else { return nil }
        guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
