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
    
    private let authService = AuthService()
    
    var isFormValid: Bool {
        
        !email.isEmpty && !password.isEmpty && isValidEmail(email)
    }
    
    var isRegistrationFormValid: Bool {
        
        isFormValid && !firstName.isEmpty && !lastName.isEmpty &&
        password == confirmPassword && password.count >= 6
    }
    
    func login() async {
        
        await MainActor.run {
            
            isLoading = true
            errorMessage = ""
            showError = false
        }
        
        do {
            
            try await authService.login(email: email, password: password)
            
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
    
    func register() async {
        
        await MainActor.run {
            
            isLoading = true
            errorMessage = ""
            showError = false
        }
        
        do {
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
    
    private func isValidEmail(_ email: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailPred.evaluate(with: email)
    }
}
