//
//  ReportControllerRepresentation.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 1/1/21.
//

import SwiftUI
import UIKit

struct ReportControllerRepresentation: UIViewControllerRepresentable {
    let project: Project
    
    func makeUIViewController(context: Context) -> ReportController {
        return ReportController(project: project)
    }
    
    func updateUIViewController(_ uiViewController: ReportController, context: Context) {}

}
