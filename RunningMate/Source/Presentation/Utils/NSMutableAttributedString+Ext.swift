//
//  NSMutableAttributedString+Ext.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/30.
//

import UIKit

extension NSMutableAttributedString {
    
    func addImage(_ image: UIImage, isLeft: Bool) {
        let imageAttachment = NSTextAttachment(image: image)
        let strImage = NSAttributedString(attachment: imageAttachment)
        if isLeft {
            self.insert(strImage, at: 0)
            self.insert(NSAttributedString(string: " "), at: 1)
        } else {
            self.append(NSAttributedString(string: " "))
            self.append(strImage)
        }
    }
}
