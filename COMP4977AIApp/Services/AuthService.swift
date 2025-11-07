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
        
        // TODO: Implement registration API call
        // placeholder for registration logic
        let registration = UserRegistration(firstName: firstName, lastName: lastName, email: email, password: password)
        
        // TODO: Make actual API call to register endpoint?
        // let response = try await networkService.performRequest(request, responseType: AuthResponse.self)
        
        // For now, simulate success
        print("Registration attempted for: \(email)")
    }
    
    func login(email: String, password: String) async throws {
        
        // TODO: Implement login API call
        let loginData = UserLogin(email: email, password: password)
        
        // TODO: Make actual API call to login endpoint
        // let response = try await networkService.performRequest(request, responseType: AuthResponse.self)
        
        // For now, simulate success
        await MainActor.run {
            
            self.isAuthenticated = true
            
            // TODO: Set actual user data from API response
            self.currentUser = User(firstName: "Test", lastName: "User", email: email)
            self.authToken = "mock_token"
            
            UserDefaults.standard.set("mock_token", forKey: "auth_token")
        }
    }
    
    func logout() {
        
        authToken = nil
        currentUser = nil
        isAuthenticated = false
        
        UserDefaults.standard.removeObject(forKey: "auth_token")
        
    }
}
