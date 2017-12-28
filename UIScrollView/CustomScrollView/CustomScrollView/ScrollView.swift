//
//  ScrollView.swift
//  CustomScrollView
//
//  Created by Seong ho Hong on 2017. 12. 28..
//  Copyright © 2017년 Razeware. All rights reserved.
//

import UIKit

class ScrollView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(panView(with:)))
        addGestureRecognizer(panGesture)
    }
    
    @objc func panView(with gestureRecognizer: UIPanGestureRecognizer) {
        let transaltion = gestureRecognizer.translation(in: self)
        UIView.animate(withDuration: 0.2, animations: {
            self.bounds.origin.y = self.bounds.origin.y - transaltion.y
        })
        
        gestureRecognizer.setTranslation(CGPoint.zero, in: self)
    }
}
