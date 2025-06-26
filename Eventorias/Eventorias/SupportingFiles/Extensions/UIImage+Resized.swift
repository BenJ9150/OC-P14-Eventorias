//
//  UIImage+Resized.swift
//  Eventorias
//
//  Created by Benjamin LEFRANCOIS on 20/06/2025.
//

import SwiftUI

extension UIImage {

    func resized(to targetSize: CGSize) -> UIImage {
        guard self.size != .zero else {
            return self
        }
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        return UIGraphicsImageRenderer(size: targetSize, format: format).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    func jpegData(maxSize: CGFloat) throws -> Data {
        guard self.size != .zero else {
            throw AppError.invalidImage
        }

        let maxDimension = max(self.size.width, self.size.height)
        let finalImage: UIImage

        if maxDimension <= maxSize {
            finalImage = self
        } else {
            let scaleRatio = maxSize / maxDimension
            let targetSize = CGSize(
                width: self.size.width * scaleRatio,
                height: self.size.height * scaleRatio
            )

            let format = UIGraphicsImageRendererFormat.default()
            let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)

            finalImage = renderer.image { _ in
                self.draw(in: CGRect(origin: .zero, size: targetSize))
            }
        }

        guard let data = finalImage.jpegData(compressionQuality: 0.8) else {
            throw AppError.invalidImage
        }

        return data
    }
}
