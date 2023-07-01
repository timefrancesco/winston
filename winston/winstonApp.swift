//
//  winstonApp.swift
//  winston
//
//  Created by Igor Marcossi on 23/06/23.
//

import SwiftUI
import SimpleHaptics

@main
struct winstonApp: App {
  let persistenceController = PersistenceController.shared
  @State var redditAPI = RedditAPI()
  
  @State var haptics = SimpleHapticGenerator()


    var body: some Scene {
        WindowGroup {
            Tabber()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(redditAPI)
                .environmentObject(haptics)
                .onOpenURL(perform: redditAPI.monitorAuthCallback)
        }
    }
}