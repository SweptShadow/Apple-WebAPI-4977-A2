import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 24) {
                
                // Profile Header
                VStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.appPrimary)
                    
                    if let user = authService.currentUser {
                        Text(user.fullName)
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 20)
                
                // User Information
                VStack(spacing: 16) {
                    if let user = authService.currentUser {
                        ProfileInfoRow(title: "Full Name", value: user.fullName)
                        ProfileInfoRow(title: "Email", value: user.email)
                        ProfileInfoRow(title: "Account Created", value: ValidationUtils.formatDate(user.accountCreationDate))
                        ProfileInfoRow(title: "Last Login", value: ValidationUtils.formatDate(user.lastLoginDate))
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Logout Button
                Button(action: {
                    authService.logout()
                }) {
                    Text("Logout")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
            .background(Color.appBackground)
            .navigationTitle("Profile")
        }
    }
}

struct ProfileInfoRow: View {
    
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding()
        .background(Color.appSurface)
        .cornerRadius(8)
    }
}

#Preview {
    ProfileView()
        .environmentObject({
            let service = AuthService()
            service.currentUser = User(firstName: "John", lastName: "Doe", email: "john.doe@example.com")
            return service
        }())
}
