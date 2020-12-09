//
//  IssueDetails.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 5/12/20.
//

import SwiftUI

struct IssueDetails: View {
    var issue: Issue
    
    var hasPhotos: Bool {
        return issue.photosArray.count > 0
    }
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var isShowPhotoLibrary = false
    @State private var currentImage = UIImage()
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Button(action: {
                    // TODO: show camera
                }) {
                    HStack {
                        Image(systemName: "camera").foregroundColor(.black)
                        Text("Camera").foregroundColor(.black)
                    }
                }
                .frame(width: (geometry.size.width - 3 * Constants.DEFAULT_MARGIN) / 2.0, height: Constants.DEFAULT_BUTTON_HEIGHT)
                .overlay(
                    RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1)
                )
                Spacer()
                Button(action: {
                    self.isShowPhotoLibrary = true
                }) {
                    HStack {
                        Image(systemName: "photo.on.rectangle").foregroundColor(.black)
                        Text("Gallery").foregroundColor(.black)
                    }
                }
                .frame(width: (geometry.size.width - 3 * Constants.DEFAULT_MARGIN) / 2.0, height: Constants.DEFAULT_BUTTON_HEIGHT)
                .overlay(
                    RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1)
                )
            }
            .padding(.horizontal, Constants.DEFAULT_MARGIN)
            .padding(.vertical, 20)
            .isEmpty(hasPhotos)
            
            VStack {
                Image(uiImage: currentImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: 300, alignment: .center)
                    .clipped()
                    .isEmpty(!hasPhotos)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            currentImage = UIImage(data: issue.photosArray[0].photoData!)!
                        }
                    }
            }
            .background(Color(red: 242/255, green: 242/255, blue: 242/255))
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, onSelectImage: { image in
                self.currentImage = image
                
                let newPhoto = Photo(context: managedObjectContext)
                let now = Date()
                
                newPhoto.id = UUID()
                newPhoto.createdAt = now
                newPhoto.photoData = image.jpegData(compressionQuality: 0.5)
                newPhoto.issue = self.issue
                
                saveContext()
            })
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
