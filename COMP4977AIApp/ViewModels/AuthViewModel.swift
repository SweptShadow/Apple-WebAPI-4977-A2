import Foundation
import Combine

class AuthViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var confirmPassword = ""
    
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var showError = false
    
    var authService: AuthService?
    
    func setAuthService(_ service: AuthService) {
        self.authService = service
    }
    
    var isFormValid: Bool {
        do {
            try ValidationUtils.validateEmail(email)
            try ValidationUtils.validatePassword(password)
            return true
        } catch {
            return false
        }
    }
    
    var isRegistrationFormValid: Bool {
        do {
            try ValidationUtils.validateEmail(email)
            try ValidationUtils.validateName(firstName, fieldName: "First name")
            try ValidationUtils.validateName(lastName, fieldName: "Last name")
            try ValidationUtils.validatePasswordConfirmation(password, confirmPassword)
            return true
        } catch {
            return false
        }
    }
    
    func login() async {
        await MainActor.run {
            isLoading = true
            errorMessage = ""
            showError = false
        }
        
        // Validate input first
        do {
            try ValidationUtils.validateEmail(email)
            try ValidationUtils.validatePassword(password)
        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = error.localizedDescription
                showError = true
            }
            return
        }
        
        // Proceed with API call
        do {
            print("🔐 Attempting login with email: \(email)")
            guard let authService = authService else {
                throw NetworkError.authenticationFailed
            }
            try await authService.login(email: email, password: password)
            print("✅ Login successful!")
            await MainActor.run {
                isLoading = false
                clearForm()
            }
        } catch {
            print("❌ Login failed with error: \(error)")
            print("❌ Error description: \(error.localizedDescription)")
            await MainActor.run {
                isLoading = false
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
    
    func register() async {
        await MainActor.run {
            isLoading = true
            errorMessage = ""
            showError = false
        }
        
        // Validate input first
        do {
            try ValidationUtils.validateEmail(email)
            try ValidationUtils.validateName(firstName, fieldName: "First name")
            try ValidationUtils.validateName(lastName, fieldName: "Last name")
            try ValidationUtils.validatePasswordConfirmation(password, confirmPassword)
        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = error.localizedDescription
                showError = true
            }
            return
        }
        
        // Proceed with API call
        do {
            guard let authService = authService else {
                throw NetworkError.authenticationFailed
            }
            try await authService.register(firstName: firstName, lastName: lastName, email: email, password: password)
            await MainActor.run {
                isLoading = false
                clearForm()
            }
        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
    
    private func clearForm() {
        email = ""
        password = ""
        firstName = ""
        lastName = ""
        confirmPassword = ""
    }
}
