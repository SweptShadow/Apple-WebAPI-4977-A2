import SwiftUI

struct RegisterView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authService: AuthService
    @StateObject private var viewModel = AuthViewModel()
    
    @State private var showToolbar = false
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                
                VStack(spacing: 28) {
                    
                    // MARK: - Header
                    VStack(spacing: 8) {
                        Text("Create Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 30)
                        
                        Text("Let's get you set up!")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    
                    // MARK: - Registration Form
                    VStack(spacing: 18) {
                        
                        glassField("First Name", text: $viewModel.firstName)
                        glassField("Last Name", text: $viewModel.lastName)
                        
                        glassField("Email", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        glassSecureField("Password", text: $viewModel.password)
                        
                        glassSecureField("Confirm Password", text: $viewModel.confirmPassword)
                        
                        
                        // MARK: - Validation messages
                        if !viewModel.password.isEmpty && viewModel.password.count < 6 {
                            Text("Password must be at least 6 characters")
                                .font(.caption)
                                .foregroundColor(.red.opacity(0.9))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        if !viewModel.confirmPassword.isEmpty &&
                            viewModel.password != viewModel.confirmPassword {
                            Text("Passwords do not match")
                                .font(.caption)
                                .foregroundColor(.red.opacity(0.9))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        
                        // MARK: - Register Button
                        Button(action: {
                            Task {
                                await viewModel.register()
                                if !viewModel.showError { dismiss() }
                            }
                        }) {
                            HStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                }
                                
                                Text("Register")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: viewModel.isRegistrationFormValid ?
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
                        .disabled(!viewModel.isRegistrationFormValid || viewModel.isLoading)
                        
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer(minLength: 40)
                }
            }
            .background(neonBackground)
            .navigationBarTitleDisplayMode(.inline)
            
            // MARK: - Cancel Button (Glowing)
            .toolbar {
                if showToolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white)
                                Text("Cancel")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.async {
                    showToolbar = true
                }
            }
            
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK") {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}


// MARK: - Glassy TextField Component
func glassField(_ placeholder: String, text: Binding<String>) -> some View {
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
func glassSecureField(_ placeholder: String, text: Binding<String>) -> some View {
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
    RegisterView()
        .environmentObject(AuthService.shared)
}
