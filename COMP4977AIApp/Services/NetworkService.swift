import Foundation
import Combine

class NetworkService: ObservableObject {
    
    static let shared = NetworkService()
    
    // MARK: - Configuration
    private var baseURL: String {
        // For local development
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return "https://comp4977-assignment2-api.azurewebsites.net/api" // Use Azure for previews
        }
        
        // Use Azure backend for both DEBUG and RELEASE since backend is on different machine
        return "https://comp4977-assignment2-api.azurewebsites.net/api"
    }
    
    private init() {}
    
    // MARK: - Authentication Methods
    
    func register(user: UserRegistration) async throws -> String {
        guard let request = createRequest(for: "auth/register", method: "POST", body: try JSONEncoder().encode(user)) else {
            throw NetworkError.invalidURL
        }
        
        let response: RegistrationResponse = try await performRequest(request, responseType: RegistrationResponse.self)
        return response.message
    }
    
    func login(credentials: UserLogin) async throws -> AuthResponse {
        guard let request = createRequest(for: "auth/login", method: "POST", body: try JSONEncoder().encode(credentials)) else {
            throw NetworkError.invalidURL
        }
        
        return try await performRequest(request, responseType: AuthResponse.self)
    }
    
    func sendAIPrompt(prompt: String, token: String) async throws -> AIResponse {
        // Backend expects a raw JSON string, not an object with "prompt" key
        guard let body = try? JSONEncoder().encode(prompt),
              let request = createRequest(for: "ai/prompt", method: "POST", body: body, token: token) else {
            throw NetworkError.invalidURL
        }
        
        return try await performRequest(request, responseType: AIResponse.self)
    }
    
    // MARK: - Private Methods
    
    private func createRequest(for endpoint: String, method: String = "GET", body: Data? = nil, token: String? = nil) -> URLRequest? {
        
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else { return nil }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = token {
            
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
    
    func performRequest<T: Codable>(_ request: URLRequest, responseType: T.Type) async throws -> T {
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            
            return decodedResponse
        } catch {
            
            throw NetworkError.decodingError(error)
        }
    }
}

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case decodingError(Error)
    case authenticationFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .authenticationFailed:
            return "Authentication failed"
        }
    }
}

// MARK: - Response Models

struct RegistrationResponse: Codable {
    let message: String
}

struct AIResponse: Codable {
    let response: String
    let model: String?
    let domain: String?
    
    // Backend sends lowercase property names
    enum CodingKeys: String, CodingKey {
        case response
        case model
        case domain
    }
}
