import Foundation

struct User: Codable, Identifiable {
    
    let id: String // Backend uses String ID
    let firstName: String
    let lastName: String
    let email: String
    let createdAt: Date // Match backend property name
    let lastLogin: Date // Match backend property name
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    init(id: String = UUID().uuidString, firstName: String, lastName: String, email: String, createdAt: Date = Date(), lastLogin: Date = Date()) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.createdAt = createdAt
        self.lastLogin = lastLogin
    }
    
    // Custom date decoding to handle backend date format
    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, email, createdAt, lastLogin
    }
}

struct UserRegistration: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let passwordHash: String // Backend expects passwordHash
    
    enum CodingKeys: String, CodingKey {
        case firstName, lastName, email, passwordHash
    }
}

struct UserLogin: Codable {
    let email: String
    let passwordHash: String // Backend expects passwordHash
    
    enum CodingKeys: String, CodingKey {
        case email, passwordHash
    }
}

struct AuthResponse: Codable {
    let token: String
    let user: UserInfo
    
    struct UserInfo: Codable {
        let id: String
        let firstName: String
        let lastName: String
        let email: String
        let createdAt: String // Backend sends as string
        let lastLogin: String // Backend sends as string
    }
}
