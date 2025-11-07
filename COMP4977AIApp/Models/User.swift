import Foundation

struct User: Codable, Identifiable {
    
    let id: UUID
    let firstName: String
    let lastName: String
    let email: String
    let accountCreationDate: Date
    let lastLoginDate: Date
    
    var fullName: String {
        
        "\(firstName) \(lastName)"
    }
    
    init(id: UUID = UUID(), firstName: String, lastName: String, email: String, accountCreationDate: Date = Date(), lastLoginDate: Date = Date()) {
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.accountCreationDate = accountCreationDate
        self.lastLoginDate = lastLoginDate
        
    }
}

struct UserRegistration: Codable {
    
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    
}

struct UserLogin: Codable {
    
    let email: String
    let password: String
    
}

struct AuthResponse: Codable {
    
    let token: String
    let user: User
    
}
