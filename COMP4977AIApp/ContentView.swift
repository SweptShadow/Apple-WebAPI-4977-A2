import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        VStack {
            // Debug info
            Text("Debug: isAuthenticated = \(authService.isAuthenticated)")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top)
            
            if authService.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            print("[DEBUG] ContentView: onAppear - isAuthenticated = \(authService.isAuthenticated)")
        }
        .onChange(of: authService.isAuthenticated) { oldValue, newValue in
            print("[DEBUG] ContentView: isAuthenticated changed from \(oldValue) to \(newValue)")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthService())
}
