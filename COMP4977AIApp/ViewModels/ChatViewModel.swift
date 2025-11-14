import Foundation
import Combine

class ChatViewModel: ObservableObject {
    
    @Published var messages: [ChatMessage] = []
    @Published var currentMessage = ""
    @Published var isLoading = false
    
    private let aiService = AIService()
    
    func sendMessage() async {
        guard !currentMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        // Get auth token from UserDefaults
        guard let authToken = UserDefaults.standard.string(forKey: "auth_token") else {
            await showErrorMessage("Please login to use AI chat")
            return
        }
        
        let userMessage = ChatMessage(content: currentMessage, isFromUser: true)
        
        await MainActor.run {
            messages.append(userMessage)
            print("[DEBUG] ChatViewModel: Clearing currentMessage text field")
            currentMessage = ""
            isLoading = true
        }
        
        do {
            let response = try await aiService.sendMessage(userMessage.content, token: authToken)
            let aiMessage = ChatMessage(content: response, isFromUser: false)
            
            await MainActor.run {
                messages.append(aiMessage)
                isLoading = false
            }
        } catch {
            await showErrorMessage("Sorry, I couldn't process your request. Please try again.")
        }
    }
    
    private func showErrorMessage(_ message: String) async {
        let errorMessage = ChatMessage(content: message, isFromUser: false)
        await MainActor.run {
            messages.append(errorMessage)
            isLoading = false
        }
    }
    
    func clearChat() {
        
        messages.removeAll()
    }
}
