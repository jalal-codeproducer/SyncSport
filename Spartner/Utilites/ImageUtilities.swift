//
//  ImageUtilities.swift
//  Spartner
//
//  Created by Mohammed Jalal Alamer on 20.03.25.
//

import SwiftUI
import UIKit

class ImageUtilities {
    static func imageToBase64String(_ image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        return imageData.base64EncodedString()
    }

    func base64StringToImage(_ base64String: String) -> Image? {
        guard let imageData = Data(base64Encoded: base64String) else {
            return nil
        }
        guard let uiImage = UIImage(data: imageData) else { return nil }

        return Image(uiImage: uiImage)
    }
}
