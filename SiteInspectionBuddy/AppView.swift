//
//  AppView.swift
//  SiteInspectionBuddy
//
//  Created by Spencer Feng on 7/1/21.
//

import SwiftUI

struct AppView: View {
    var body: some View {
        TabView {
            ProjectsList()
                .tabItem {
                    Image(systemName: "tray.full")
                    Text("Projects")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
