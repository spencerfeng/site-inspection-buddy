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
    
    @State var featuredImage: UIImage? = nil
    var defaultFeaturedImage = UIImage()
    
    var body: some View {
        NavigationLink(
            destination: IssueDetails(issue: issue, backgroundImage: $featuredImage),
            tag: issue.id!,
            selection: $selectedIssueId
        ) {
            Button(action: {
                self.selectedIssueId = issue.id
            }) {
                HStack {
                    Image(uiImage: featuredImage ?? defaultFeaturedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40, alignment: .center)
                        .cornerRadius(5)
                    Text(issue.title!)
                }
            }
        }
        .onAppear {
            if (featuredImage == nil) {
                if (issue.photosArray.count > 0) {
                    guard let photoData = issue.photosArray[0].photoData else { return }
                    guard let updatedFeaturedImage = UIImage(data: photoData) else { return }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        featuredImage = updatedFeaturedImage
                    }
                }
            }
        }
    }
}
