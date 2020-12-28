//
//  IssueDetails.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 5/12/20.
//

import SwiftUI

struct IssueDetails: View {
    var issue: Issue
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var isShowPhotoLibrary = false
    @State private var backgroundImage = UIImage()
    @State private var annotationImage = UIImage()
    @State private var isShowPhotoEditor = false
    
    var body: some View {
        GeometryReader { geometry in
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
                .isEmpty(issue.hasPhotos)
                .frame(width: geometry.size.width, height: 300, alignment: .center)
                .sheet(isPresented: $isShowPhotoLibrary) {
                    ImagePicker(sourceType: .photoLibrary, onSelectImage: { image in
                        self.backgroundImage = image
                        
                        let newPhoto = Photo(context: managedObjectContext)
                        let now = Date()
                        
                        newPhoto.id = UUID()
                        newPhoto.createdAt = now
                        newPhoto.photoData = image.jpegData(compressionQuality: 0.5)
                        newPhoto.issue = self.issue
                        
                        saveContext()
                    })
                }
                
                ZStack {
                    Image(uiImage: backgroundImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width, height: 300, alignment: .center)
                        .clipped()
                        .overlay(Image(uiImage: annotationImage).resizable().scaledToFit())
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                backgroundImage = UIImage(data: issue.photosArray[0].photoData!)!
                                if let annotationData = issue.photosArray[0].annotationData {
                                    if let imgFromAnnotationData = UIImage(data: annotationData) {
                                        annotationImage = imgFromAnnotationData
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
                                annotationImage = UIImage()
                                
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
                .isEmpty(!issue.hasPhotos)
                .fullScreenCover(isPresented: $isShowPhotoEditor, content: {
                    DrawingPadControllerRepresentation(backgroundImage: $backgroundImage, annotationImage: $annotationImage, strokeColor: Constants.DRAWING_DEFAULT_COLOR, photo: self.issue.firstPhoto!)
                })
            }
            .background(Color(red: 242/255, green: 242/255, blue: 242/255))
            
        }
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
