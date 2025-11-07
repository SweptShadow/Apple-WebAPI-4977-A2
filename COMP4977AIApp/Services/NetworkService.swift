import Foundation
import Combine

class NetworkService: ObservableObject {
    
    static let shared = NetworkService()
    
    // TODO: Update with your actual WebAPI base URL
    private let baseURL = "https://your-webapi-url.azurewebsites.net/api"
    
    private init() {}
    
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
        }
    }
}
