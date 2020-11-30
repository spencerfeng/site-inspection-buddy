//
//  ProjectDetails.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 29/11/20.
//

import SwiftUI

struct ProjectDetails: View {
    let project: Project
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        Text("Project details")
    }
}
