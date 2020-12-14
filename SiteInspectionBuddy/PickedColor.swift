//
//  PickedColor.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 12/12/20.
//

import Foundation
import SwiftUI

enum PickedColor: CaseIterable {
    case black, blue, green, orange, red, yellow
    
    var color: Color {
        switch self {
        case .black:
            return Color.black
        case .blue:
            return Color.blue
        case .green:
            return Color.green
        case .orange:
            return Color.orange
        case .red:
            return Color.red
        case .yellow:
            return Color.yellow
        }
    }
    
    var uiColor: UIColor {
        switch self {
        case .black:
            return UIColor.black
        case .blue:
            return UIColor.blue
        case .green:
            return UIColor.green
        case .orange:
            return UIColor.orange
        case .red:
            return UIColor.red
        case .yellow:
            return UIColor.yellow
        }
    }
}
