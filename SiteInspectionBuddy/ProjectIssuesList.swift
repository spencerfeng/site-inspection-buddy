//
//  ProjectIssuesList.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 4/12/20.
//

import SwiftUI

struct ProjectIssuesList: View {
    var project: Project
    
    @State var selectedIssueId: UUID? = nil
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest var issues: FetchedResults<Issue>
    
    init(project: Project) {
        self.project = project
        self._issues = FetchRequest(
            entity: Issue.entity(),
            sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)],
            predicate: NSPredicate(format: "project == %@", project))
    }
    
    var body: some View {
        List {
            ForEach(issues, id: \.id) { issue in
                NavigationLink(
                    destination: IssueDetails(issue: issue),
                    tag: issue.id!,
                    selection: $selectedIssueId
                ) {
                    Button(issue.title!) {
                        self.selectedIssueId = issue.id
                    }
                }
                .listRowBackground(self.selectedIssueId == issue.id ? Color(red: 242/255, green: 242/255, blue: 242/255) : Color.clear)
            }
        }
        .navigationBarTitle(Text("Issues"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            withAnimation(.easeInOut(duration: 1.0)) {
                let newIssue = addIssue()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.selectedIssueId = newIssue.id
                }
            }
        }) {
            Image(systemName: "plus")
        })
    }
    
    func addIssue() -> Issue {
        let newIssue = Issue(context: managedObjectContext)
        let now = Date()
        
        newIssue.id = UUID()
        newIssue.createdAt = now
        newIssue.title = "Issue \(issues.count + 1)"
        newIssue.project = project
        
        saveContext()
        
        return newIssue
    }
    
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            // TODO: proper error handling
            print("Error saving managed object context: \(error)")
        }
    }
}
