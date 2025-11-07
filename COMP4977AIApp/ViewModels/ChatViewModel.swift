import Foundation
import Combine

class ChatViewModel: ObservableObject {
    
    @Published var messages: [ChatMessage] = []
    @Published var currentMessage = ""
    @Published var isLoading = false
    
    private let aiService = AIService()
    
    func sendMessage() async {
        
        guard !currentMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(content: currentMessage, isFromUser: true)
        
        await MainActor.run {
            
            messages.append(userMessage)
            currentMessage = ""
            isLoading = true
        }
        
        do {
            
            // TODO: Get actual auth token from AuthService
            let response = try await aiService.sendMessage(userMessage.content, token: "mock_token")
            let aiMessage = ChatMessage(content: response, isFromUser: false)
            
            await MainActor.run {
                
                messages.append(aiMessage)
                isLoading = false
            }
        } catch {
            
            let errorMessage = ChatMessage(content: "Sorry, I couldn't process your request. Please try again.", isFromUser: false)
            
            await MainActor.run {
                
                messages.append(errorMessage)
                isLoading = false
            }
        }
    }
    
    func clearChat() {
        
        messages.removeAll()
    }
}
