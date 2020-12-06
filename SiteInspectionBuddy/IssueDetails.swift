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
    
    @ViewBuilder
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
                    // TODO: show photo gallery
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
        }
        .navigationBarTitle(Text(issue.title!), displayMode: .inline)
    }
}
