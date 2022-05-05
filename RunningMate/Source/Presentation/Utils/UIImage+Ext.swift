//
//  UIImage+Ext.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/05.
//

import UIKit

extension UIImage {
    func resizeImage(to size: CGSize, point: CGPoint = .zero) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: point, size: size))
        }
    }
}
