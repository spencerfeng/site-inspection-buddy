//
//  ProjectIssuesList.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 4/12/20.
//

import SwiftUI

struct ProjectIssuesList: View {
    @ObservedObject var project: Project
    
    @State var selectedIssueId: UUID? = nil
    @State var shouldDisableCreateNewIssueBtn = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest var issues: FetchedResults<Issue>
    
    init(project: Project) {
        self.project = project
        self._issues = FetchRequest(
            entity: Issue.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Issue.order, ascending: true),
                NSSortDescriptor(keyPath: \Issue.createdAt, ascending: true)
            ],
            predicate: NSPredicate(format: "project == %@", project))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                shouldDisableCreateNewIssueBtn = true
                withAnimation(.easeInOut(duration: 1.0)) {
                    let newIssue = addIssue()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.selectedIssueId = newIssue.id
                        self.shouldDisableCreateNewIssueBtn = false
                    }
                }
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill").foregroundColor(.blue)
                    Text("Create New").foregroundColor(.blue)
                }
            }
            .disabled(shouldDisableCreateNewIssueBtn)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 1)
            )
            .padding()
            
            Divider()
            
            List {
                ForEach(issues, id: \.id) { issue in
                    ProjectIssuesListItem(issue: issue, selectedIssueId: $selectedIssueId)
                    .listRowBackground(self.selectedIssueId == issue.id ? Color(red: 242/255, green: 242/255, blue: 242/255) : Color.clear)
                }
                .onDelete(perform: deleteIssues)
                .onMove(perform: moveIssue)
            }
            .onDisappear {
                self.selectedIssueId = nil
            }
        }
        .navigationBarTitle(Text("Issues"), displayMode: .inline)
        .navigationBarItems(trailing: EditButton())
    }
    
    func deleteIssues(at offsets: IndexSet) {
        for index in offsets {
            let issue = issues[index]
            managedObjectContext.delete(issue)
        }

        // TODO: find the reason why we can not call saveContext directly
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            saveContext()
        }
    }
    
    func moveIssue(from source: IndexSet, to destination: Int) {
        var revisedIssues: [Issue] = issues.map { $0 }
        
        revisedIssues.move(fromOffsets: source, toOffset: destination)
        
        for (index, _) in revisedIssues.enumerated() {
            revisedIssues[index].order = Int16(index)
        }
        
        saveContext()
    }
    
    func addIssue() -> Issue {
        let newIssue = Issue(context: managedObjectContext)
        let now = Date()
        
        newIssue.id = UUID()
        newIssue.createdAt = now
        newIssue.title = "Issue \(issues.count + 1)"
        newIssue.project = project
        newIssue.order = 10000
        
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
