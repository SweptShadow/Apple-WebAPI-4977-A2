import Foundation
import Combine

class AIService: ObservableObject {
    
    private let networkService = NetworkService.shared
    
    func sendMessage(_ message: String, token: String) async throws -> String {
        guard !token.isEmpty else {
            throw NetworkError.authenticationFailed
        }
        
        do {
            let response = try await networkService.sendAIPrompt(prompt: message, token: token)
            return response.response
        } catch {
            print("AI Service error: \(error.localizedDescription)")
            throw error
        }
    }
}
