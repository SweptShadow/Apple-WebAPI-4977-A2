import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authService: AuthService
    @StateObject private var viewModel = AuthViewModel()
    @State private var showRegistration = false
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 30) {
                
                Spacer()
                
                // MARK: - Glowing App Icon / Title
                VStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Color.purple.opacity(0.5), Color.clear],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 90
                                )
                            )
                            .blur(radius: 12)
                        
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.purple, Color.pink, Color.blue],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 90, height: 90)
                            .shadow(color: .purple.opacity(0.7), radius: 15)
                            .overlay(
                                Image(systemName: "brain.head.profile")
                                    .font(.system(size: 45))
                                    .foregroundColor(.white)
                            )
                    }
                    
                    Text("AI Assistant")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.bottom, 10)
                
                
                // MARK: - Glassy Login Form
                VStack(spacing: 18) {
                    
                    // Email
                    glassField(placeholder: "Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    // Password
                    glassSecureField(placeholder: "Password", text: $viewModel.password)
                    
                    
                    // Login Button
                    Button(action: {
                        Task { await viewModel.login() }
                    }) {
                        HStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            }
                            Text("Login")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: viewModel.isFormValid ?
                                    [Color.purple, Color.blue] :
                                    [Color.gray.opacity(0.4), Color.gray.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .purple.opacity(0.4), radius: 12, y: 5)
                    }
                    .disabled(!viewModel.isFormValid || viewModel.isLoading)
                    
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                
                // MARK: - Register Link
                Button {
                    showRegistration = true
                } label: {
                    Text("Don't have an account? Register")
                        .foregroundColor(.purple.opacity(0.8))
                        .fontWeight(.medium)
                        .underline()
                }
                .padding(.bottom, 40)
                
                
            }
            .background(neonBackground)
            .navigationBarHidden(true)
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") {}
            } message: {
                Text(viewModel.errorMessage)
            }
            .sheet(isPresented: $showRegistration) {
                RegisterView()
                    .environmentObject(authService)
            }
        }
        .onAppear { viewModel.setAuthService(authService) }
    }
}


// MARK: - Glassy TextField
func glassField(placeholder: String, text: Binding<String>) -> some View {
    ZStack(alignment: .leading) {
        if text.wrappedValue.isEmpty {
            Text(placeholder)
                .foregroundColor(.white.opacity(0.45))
                .padding(.leading, 14)
        }
        
        TextField("", text: text)
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
    }
    .background(
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.white.opacity(0.08))
            .background(.ultraThinMaterial)
    )
    .overlay(
        RoundedRectangle(cornerRadius: 12)
            .stroke(Color.white.opacity(0.12), lineWidth: 1)
    )
}


// MARK: - Glassy SecureField
func glassSecureField(placeholder: String, text: Binding<String>) -> some View {
    ZStack(alignment: .leading) {
        if text.wrappedValue.isEmpty {
            Text(placeholder)
                .foregroundColor(.white.opacity(0.45))
                .padding(.leading, 14)
        }
        
        SecureField("", text: text)
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
    }
    .background(
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.white.opacity(0.08))
            .background(.ultraThinMaterial)
    )
    .overlay(
        RoundedRectangle(cornerRadius: 12)
            .stroke(Color.white.opacity(0.12), lineWidth: 1)
    )
}


#Preview {
    LoginView()
        .environmentObject(AuthService.shared)
}
