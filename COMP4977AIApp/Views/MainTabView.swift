import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
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
    }
}

#Preview {
    MainTabView()
}
