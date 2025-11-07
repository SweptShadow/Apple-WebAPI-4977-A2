import SwiftUI

struct MainTabView: View {
    
    @StateObject private var authService = AuthService()
    
    var body: some View {
        
        Group {
            if authService.isAuthenticated {
                TabView {
                    AIView()
                        .tabItem {
                            Image(systemName: "brain.head.profile")
                            Text("AI")
                        }
                    
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.circle")
                            Text("Profile")
                        }
                    
                    AboutView()
                        .tabItem {
                            Image(systemName: "info.circle")
                            Text("About")
                        }
                }
                .accentColor(.appPrimary)
                .environmentObject(authService)
            } else {
                LoginView()
                    .environmentObject(authService)
            }
        }
    }
}

#Preview {
    MainTabView()
}
