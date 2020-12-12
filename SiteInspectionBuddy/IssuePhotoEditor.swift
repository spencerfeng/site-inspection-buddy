    //
    //  IssuePhotoEditor.swift
    //  SiteInspectionBuddy
    //
    //  Created by Spencer Feng on 10/12/20.
    //

    import SwiftUI

    struct IssuePhotoEditor: View {
        @Environment(\.presentationMode) var presentationMode
        
        let image: UIImage

        var body: some View {
            NavigationView {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                // TODO: save drawing changes
                            }) {
                               Text("Done")
                           }
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                               Text("Cancel")
                           }
                        }
                        ToolbarItemGroup(placement: .bottomBar) {
                            // TODO: add drawing tools button
                            Button("Button 1", action: {})
                            Spacer()
                            Button("Button 2", action: {})
                            Spacer()
                            Button("Button 3", action: {})
                            Spacer()
                            Button("Button 4", action: {})
                        }
                    }
                    .navigationBarTitle(Text("Annotations"), displayMode: .inline)
            }
        }
    }
