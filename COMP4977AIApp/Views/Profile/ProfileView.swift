import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authService: AuthService
    
    @State private var showToolbar = false
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 28) {
                
                // MARK: - Profile Header
                VStack(spacing: 14) {
                    
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.purple.opacity(0.6),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 90
                                )
                            )
                            .blur(radius: 16)
                        
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.purple, Color.pink, Color.blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 90, height: 90)
                            .shadow(color: .purple.opacity(0.6), radius: 12)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 45, weight: .medium))
                                    .foregroundColor(.white)
                            )
                    }
                    .padding(.top, 30)
                    
                    if let user = authService.currentUser {
                        Text(user.fullName)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                
                // MARK: - User Info
                VStack(spacing: 16) {
                    if let user = authService.currentUser {
                        ProfileInfoRow(title: "Full Name", value: user.fullName)
                        ProfileInfoRow(title: "Email", value: user.email)
                        ProfileInfoRow(title: "Account Created", value: ValidationUtils.formatDate(user.createdAt))
                        ProfileInfoRow(title: "Last Login", value: ValidationUtils.formatDate(user.lastLogin))
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // MARK: - Logout Button
                Button(action: {
                    authService.logout()
                }) {
                    Text("Logout")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.pink, .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .red.opacity(0.4), radius: 10, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
            .background(neonBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if showToolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Profile")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.async {
                    showToolbar = true
                }
            }
        }
    }
}


// MARK: - Info Row (Glassy Theme)
struct ProfileInfoRow: View {
    
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.white)
                .fontWeight(.medium)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.08))
                .background(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.25), radius: 6, y: 3)
    }
}


// MARK: - Background
var neonBackground: some View {
    LinearGradient(
        colors: [
            Color(red: 0.15, green: 0.0, blue: 0.3),
            Color(red: 0.05, green: 0.0, blue: 0.15),
            Color.black
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    .ignoresSafeArea()
}


#Preview {
    ProfileView()
        .environmentObject({
            let service = AuthService.shared
            service.currentUser = User(firstName: "John", lastName: "Doe", email: "john.doe@example.com")
            return service
        }())
}
