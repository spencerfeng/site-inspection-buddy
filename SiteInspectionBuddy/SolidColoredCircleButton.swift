//
//  SolidColoredCircleButton.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 24/12/20.
//

import Foundation
import UIKit

class SolidColoredCircleButton: UIButton {
    var color: UIColor
    
    init(color: UIColor) {
        self.color = color
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
