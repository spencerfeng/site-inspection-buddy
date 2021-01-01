//
//  ReportController.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 1/1/21.
//

import Foundation
import UIKit

class ReportController: UIViewController {
    let project: Project
    
    init(project: Project) {
        self.project = project
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
