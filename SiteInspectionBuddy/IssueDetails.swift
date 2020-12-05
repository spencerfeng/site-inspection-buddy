//
//  IssueDetails.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 5/12/20.
//

import SwiftUI

struct IssueDetails: View {
    var issue: Issue
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .navigationBarTitle(Text(issue.title!), displayMode: .inline)
    }
}
