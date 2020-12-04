//
//  ProjectIssuesList.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 4/12/20.
//

import SwiftUI

struct ProjectIssuesList: View {
    var project: Project
    
    var body: some View {
        Text("Project Issues List")
            .navigationBarTitle(Text("Issues"), displayMode: .inline)
    }
}
