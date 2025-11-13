import Foundation
import Combine

class AuthService: ObservableObject {
    
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var authToken: String?
    
    private let networkService = NetworkService.shared
    
    init() {
        
        // Check if user is already logged in
        checkAuthStatus()
    }
    
    private func checkAuthStatus() {
        
        // TODO: Implement token validation & user restoration fr UserDefaults/Keychain
        if let token = UserDefaults.standard.string(forKey: "auth_token") {
            
            self.authToken = token
            // TODO: Validate token w/ server and restore user
        }
    }
    
    func register(firstName: String, lastName: String, email: String, password: String) async throws {
        let registration = UserRegistration(
            firstName: firstName,
            lastName: lastName,
            email: email,
            passwordHash: password
        )
        
        do {
            let message = try await networkService.register(user: registration)
            print("Registration successful: \(message)")
        } catch {
            print("Registration failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    func login(email: String, password: String) async throws {
        let loginData = UserLogin(email: email, passwordHash: password)
        
        do {
            let response = try await networkService.login(credentials: loginData)
            
            await MainActor.run {
                self.isAuthenticated = true
                self.authToken = response.token
                
                // Convert backend user data to local User model
                self.currentUser = User(
                    id: response.user.id,
                    firstName: response.user.firstName,
                    lastName: response.user.lastName,
                    email: response.user.email,
                    createdAt: parseDate(response.user.createdAt) ?? Date(),
                    lastLogin: parseDate(response.user.lastLogin) ?? Date()
                )
                
                // Store token securely
                UserDefaults.standard.set(response.token, forKey: "auth_token")
            }
            
        } catch {
            print("Login failed: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func parseDate(_ dateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString)
    }
    
    func logout() {
        
        authToken = nil
        currentUser = nil
        isAuthenticated = false
        
        UserDefaults.standard.removeObject(forKey: "auth_token")
        
    }
}
