//
//  ProjectsList.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 29/11/20.
//

import SwiftUI

struct ProjectsList: View {
    @State var selectedProjectId: UUID? = nil
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
        entity: Project.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Project.createdAt, ascending: false)]
    ) var projects: FetchedResults<Project>
    
    init() {
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(projects, id: \.id) { project in
                    NavigationLink(
                        destination: ProjectDetails(project: project),
                        tag: project.id!,
                        selection: $selectedProjectId
                    ) {
                        Button(project.title!) {
                            self.selectedProjectId = project.id
                        }
                    }
                    .listRowBackground(self.selectedProjectId == project.id ? Color(red: 242/255, green: 242/255, blue: 242/255) : Color.clear)
                }
                .onDelete(perform: deleteProject)
            }
            .onDisappear {
                self.selectedProjectId = nil
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle(Text("Projects"))
            .navigationBarItems(trailing: Button(action: {
                withAnimation(.easeInOut(duration: 1.0)) {
                    let newProject = addProject()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.selectedProjectId = newProject.id
                    }
                }
            }) {
                Image(systemName: "plus")
            })
        }
    }
    
    func deleteProject(at offsets: IndexSet) {
        offsets.forEach { index in
            let project = self.projects[index]
            self.managedObjectContext.delete(project)
        }
        
        saveContext()
    }
    
    func addProject() -> Project {
        let newProject = Project(context: managedObjectContext)
        let now = Date()
        
        newProject.id = UUID()
        newProject.createdAt = now
        newProject.title = "Project - " + DateFormatter.regularDateFormatter.string(from: now)
        
        saveContext()
        
        return newProject
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

struct ProjectsList_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsList()
    }
}
