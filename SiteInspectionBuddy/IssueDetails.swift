//
//  IssueDetails.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 5/12/20.
//

import SwiftUI

struct IssueDetails: View {
    var issue: Issue
    @Binding var backgroundImageData: Data?
    @Binding var backgroundImageThumb: UIImage?
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var backgroundImage: UIImage?
    @State private var isShowPhotoLibrary = false
    @State private var annotationImage: UIImage? = nil
    @State private var isShowPhotoEditor = false
    @State private var title = ""
    @State private var assignee = ""
    @State private var comment = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Group {
                    VStack {
                        Text("Add a photo for this issue").padding(.bottom)
                        HStack {
                            Button(action: {
                                // TODO: show camera
                            }) {
                                Image(systemName: "camera")
                                    .padding()
                                    .foregroundColor(Color.white)
                                    .background(Color.blue)
                                    .mask(Circle())
                            }
                            
                            Button(action: {
                                self.isShowPhotoLibrary = true
                            }) {
                                Image(systemName: "photo.on.rectangle")
                                    .padding()
                                    .foregroundColor(Color.white)
                                    .background(Color.blue)
                                    .mask(Circle())
                            }
                        }
                    }
                    .isEmpty(self.issue.photosArray.count > 0)
                    .frame(width: geometry.size.width, height: 300, alignment: .center)
                    .sheet(isPresented: $isShowPhotoLibrary) {
                        ImagePicker(sourceType: .photoLibrary, onSelectImage: { image in
                            let newPhoto = Photo(context: managedObjectContext)
                            let newPhotoData = image.jpegData(compressionQuality: 0.5)
                            let now = Date()
                            
                            newPhoto.id = UUID()
                            newPhoto.createdAt = now
                            newPhoto.photoData = newPhotoData
                            newPhoto.issue = self.issue
                            
                            saveContext()
                            
                            guard let photoData = newPhotoData else { return }
                            
                            self.backgroundImageThumb = Helper.getThumbnailForImage(
                                imageData: photoData,
                                size: CGSize(width: 40, height: 40)
                            )
                            
                            self.backgroundImage = Helper.getThumbnailForImage(
                                imageData: photoData,
                                size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                            )
                        })
                    }
                    
                    ZStack {
                        Image(uiImage: backgroundImage ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width, height: 300, alignment: .center)
                            .clipped()
                            .overlay(Image(uiImage: annotationImage ?? UIImage()).resizable().scaledToFit())
                            .onAppear {
                                if (backgroundImage == nil) {
                                    DispatchQueue.global(qos: .userInitiated).async {
                                        guard let imageData = self.backgroundImageData,
                                              let bgImageFromData = Helper.getThumbnailForImage(
                                                    imageData: imageData,
                                                    size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                                              )
                                        else { return }
                                        
                                        DispatchQueue.main.async {
                                            self.backgroundImage = bgImageFromData
                                        }
                                        
                                        guard let annotationData = self.issue.photosArray[0].annotationData,
                                              let imgFromAnnotationData = UIImage(data: annotationData)
                                        else { return }
                                        
                                        DispatchQueue.main.async {
                                            self.annotationImage = imgFromAnnotationData
                                        }
                                    }
                                }
                            }
                        HStack {
                            Button(action: {
                                isShowPhotoEditor = true
                            }) {
                                Image(systemName: "square.and.pencil")
                                    .padding()
                                    .foregroundColor(Color.white)
                                    .background(Color.green)
                                    .mask(Circle())
                            }
                            Button(action: {
                                if (issue.photosArray.count > 0) {
                                    managedObjectContext.delete(issue.photosArray[0])
                                    saveContext()
                                    
                                    // TODO: what if deleting this photo from Core Data failed
                                    backgroundImage = UIImage()
                                    backgroundImageThumb = UIImage()
                                    annotationImage = nil
                                    
                                }
                            }) {
                                Image(systemName: "trash")
                                    .padding()
                                    .foregroundColor(Color.white)
                                    .background(Color.red)
                                    .mask(Circle())
                            }
                        }
                    }
                    .isEmpty(self.issue.photosArray.count <= 0)
                    .fullScreenCover(isPresented: $isShowPhotoEditor, content: {
                        DrawingPadControllerRepresentation(
                            backgroundImage: backgroundImage ?? UIImage(),
                            annotationImage: $annotationImage,
                            strokeColor: Constants.DRAWING_DEFAULT_COLOR,
                            photo: self.issue.photosArray[0]
                        )
                    })
                }
                .background(Color(red: 242/255, green: 242/255, blue: 242/255))
                
                Form {
                    Section(header: Text("Title")) {
                        TextField("Title", text: $title)
                            .modifier(TextFieldClearButton(text: $title))
                            .onAppear {
                                title = issue.title ?? ""
                            }
                    }
                    Section(header: Text("Assignee")) {
                        TextField("Assignee", text: $assignee)
                            .modifier(TextFieldClearButton(text: $assignee))
                            .onAppear {
                                assignee = issue.assignee ?? ""
                            }
                    }
                    Section(header: Text("Comment")) {
                        TextEditor(text: $comment)
                            .onAppear {
                                comment = issue.comment ?? ""
                            }
                    }
                }
                .onDisappear {
                    if (title != "") {
                        issue.title = title
                    }
                    
                    if (assignee != "") {
                        issue.assignee = assignee
                    }
                    
                    if (comment != "") {
                        issue.comment = comment
                    }
                    
                    saveContext()
                }
            }
        }
        .background(Color(red: 242/255, green: 242/255, blue: 242/255))
        .navigationBarTitle(Text(issue.title!), displayMode: .inline)
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
