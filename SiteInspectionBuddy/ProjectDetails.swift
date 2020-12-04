//
//  ProjectDetails.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 29/11/20.
//

import SwiftUI

struct ProjectDetails: View {
    let project: Project
    
    @State var selectedListItem: String? = nil
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    init(project: Project) {
        self.project = project
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    var body: some View {
        let EDIT_PROJECT_INFO = "Edit Project Info"
        let EDIT_PROJECT_ISSUES = "Edit Project Issues"
        
        List {
            Section {
                // Edit Project Info
                NavigationLink(
                    destination: ProjectInfo(project: project),
                    tag: EDIT_PROJECT_INFO,
                    selection: $selectedListItem
                ) {
                    Button(action: {
                        self.selectedListItem = EDIT_PROJECT_INFO
                    }) {
                        HStack {
                            Image(systemName: "info.circle").foregroundColor(.black)
                            Text(EDIT_PROJECT_INFO).foregroundColor(.black)
                        }
                    }
                }
                .listRowBackground(self.selectedListItem == EDIT_PROJECT_INFO ? Color(red: 242/255, green: 242/255, blue: 242/255) : Color.clear)
                
                // Edit Project Issues
                NavigationLink(
                    destination: ProjectIssuesList(project: project),
                    tag: EDIT_PROJECT_ISSUES,
                    selection: $selectedListItem
                ) {
                    Button(action: {
                        self.selectedListItem = EDIT_PROJECT_ISSUES
                    }) {
                        HStack {
                            Image(systemName: "list.bullet").foregroundColor(.black)
                            Text(EDIT_PROJECT_ISSUES).foregroundColor(.black)
                        }
                    }
                }
                .listRowBackground(self.selectedListItem == EDIT_PROJECT_ISSUES ? Color(red: 242/255, green: 242/255, blue: 242/255) : Color.clear)
            }
        }
        .onDisappear {
            self.selectedListItem = nil
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(Text("Details"), displayMode: .inline)
    }
}
