//
//  DateFormatter+Variants.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 29/11/20.
//

import SwiftUI

extension DateFormatter {
    static let regularDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, HH:mm"
        return formatter
    }()
}
