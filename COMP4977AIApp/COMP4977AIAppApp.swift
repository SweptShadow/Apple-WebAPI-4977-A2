import SwiftUI

@main
struct COMP4977AIAppApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthService.shared)
        }
    }
}
