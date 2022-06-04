//
//  OuterScrollView.swift
//  RunningMate
//
//  Created by 윤재욱 on 2022/05/28.
//

import UIKit

class OuterScrollView: UIScrollView, UIGestureRecognizerDelegate {
    
    weak var childScrollView: UIScrollView?
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let childScrollView = childScrollView {
            return otherGestureRecognizer.view == childScrollView.panGestureRecognizer.view
        }
        return true
    }
}
