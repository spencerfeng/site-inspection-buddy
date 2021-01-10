//
//  ProjectIssuesListItem.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 30/12/20.
//

import SwiftUI

struct ProjectIssuesListItem: View {
    var issue: Issue
    @Binding var selectedIssueId: UUID?
    
    @State var featuredImageData: Data? = nil
    @State var featuredImageThumb: UIImage? = nil
    
    var body: some View {
        NavigationLink(
            destination: IssueDetails(
                issue: issue,
                backgroundImageData: $featuredImageData,
                backgroundImageThumb: $featuredImageThumb
            ),
            tag: issue.id!,
            selection: $selectedIssueId
        ) {
            Button(action: {
                self.selectedIssueId = issue.id
            }) {
                HStack {
                    Image(uiImage: featuredImageThumb ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40, alignment: .center)
                        .cornerRadius(5)
                    Text(issue.title!)
                }
            }
        }
        .onAppear {
            if !issue.photosArray.isEmpty {
                guard let currentPhotoData = issue.photosArray[0].photoData,
                      let currentPhotoThumb = Helper.getThumbnailForImage(
                        imageData: currentPhotoData,
                        size: CGSize(width: 40, height: 40)
                      )
                else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    featuredImageData = currentPhotoData
                    featuredImageThumb = currentPhotoThumb
                }
            }
        }
    }
}
