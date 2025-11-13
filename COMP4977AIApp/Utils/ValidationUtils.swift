import Foundation

enum ValidationError: LocalizedError {
    case invalidEmail
    case invalidPassword
    case invalidName
    case passwordsDoNotMatch
    case fieldRequired(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        case .invalidPassword:
            return "Password must be at least 6 characters long"
        case .invalidName:
            return "Name must be at least 2 characters long"
        case .passwordsDoNotMatch:
            return "Passwords do not match"
        case .fieldRequired(let field):
            return "\(field) is required"
        }
    }
}

class ValidationUtils {
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    static func isValidName(_ name: String) -> Bool {
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && name.count >= 2
    }
    
    static func passwordsMatch(_ password: String, _ confirmPassword: String) -> Bool {
        return password == confirmPassword
    }
    
    // MARK: - Validation Methods with Errors
    
    static func validateEmail(_ email: String) throws {
        guard !email.isEmpty else {
            throw ValidationError.fieldRequired("Email")
        }
        guard isValidEmail(email) else {
            throw ValidationError.invalidEmail
        }
    }
    
    static func validatePassword(_ password: String) throws {
        guard !password.isEmpty else {
            throw ValidationError.fieldRequired("Password")
        }
        guard isValidPassword(password) else {
            throw ValidationError.invalidPassword
        }
    }
    
    static func validateName(_ name: String, fieldName: String) throws {
        guard !name.isEmpty else {
            throw ValidationError.fieldRequired(fieldName)
        }
        guard isValidName(name) else {
            throw ValidationError.invalidName
        }
    }
    
    static func validatePasswordConfirmation(_ password: String, _ confirmPassword: String) throws {
        try validatePassword(password)
        guard !confirmPassword.isEmpty else {
            throw ValidationError.fieldRequired("Password confirmation")
        }
        guard passwordsMatch(password, confirmPassword) else {
            throw ValidationError.passwordsDoNotMatch
        }
    }
    
    static func formatDate(_ date: Date) -> String {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter.string(from: date)
    }
    
    static func formatDateTime(_ date: Date) -> String {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
}
