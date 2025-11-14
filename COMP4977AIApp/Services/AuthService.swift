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
        print("[debug] AuthService: Starting login for \(email)")
        let loginData = UserLogin(email: email, passwordHash: password)
        
        do {
            print("[debug] AuthService: Calling network service...")
            let response = try await networkService.login(credentials: loginData)
            print("[debug] AuthService: Received response, token: \(String(response.token.prefix(20)))...")
            
            await MainActor.run {
                self.isAuthenticated = true
                self.authToken = response.token
                print("[debug] AuthService: Set isAuthenticated = true")
                
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
                print("[debug] AuthService: Login completed successfully")
            }
            
        } catch {
            print("[debug] AuthService login failed: \(error.localizedDescription)")
            if let networkError = error as? NetworkError {
                print("[debug] Network error details: \(networkError)")
            }
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
