//
//  ColorPickerBarButtonItemView.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 21/12/20.
//

import Foundation
import UIKit

class ColorPickerBarButtonItemView: UIButton {
    var color: UIColor
    
    init(color: UIColor, frame: CGRect) {
        self.color = color
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        color.setFill()
        
        let path = UIBezierPath(ovalIn: rect)
        path.fill()
    }
}
