//
//  ProjectInfo.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 30/11/20.
//

import SwiftUI

struct ProjectInfo: View {
    var project: Project
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var title = ""
    @State var client = ""
    
    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Title", text: $title)
                    .modifier(TextFieldClearButton(text: $title))
                    .onAppear {
                        title = project.title ?? ""
                    }
            }
            Section(header: Text("Client")) {
                TextField("Client", text: $client)
                    .modifier(TextFieldClearButton(text: $client))
                    .onAppear {
                        client = project.client ?? ""
                    }
            }
        }
        .onDisappear {
            if (title != "") {
                project.title = title
            }
            project.client = client
            
            saveContext()
        }
        .navigationBarTitle(Text("Project Info"), displayMode: .inline)
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
