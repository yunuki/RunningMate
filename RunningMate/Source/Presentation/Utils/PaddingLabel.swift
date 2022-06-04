//
//  PaddingLabel.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/31.
//

import UIKit

class PaddingLabel: UILabel {
    
    private var padding: UIEdgeInsets = .zero
    
    init(frame: CGRect = .zero, padding: UIEdgeInsets) {
        super.init(frame: frame)
        self.padding = padding
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += (padding.top + padding.bottom)
        contentSize.width += (padding.left + padding.right)
        return contentSize
    }
}
