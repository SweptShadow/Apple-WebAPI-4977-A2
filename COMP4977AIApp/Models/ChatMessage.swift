import Foundation

struct ChatMessage: Identifiable, Codable {
    
    let id: UUID
    let content: String
    let isFromUser: Bool
    let timestamp: Date
    
    init(id: UUID = UUID(), content: String, isFromUser: Bool, timestamp: Date = Date()) {
        
        self.id = id
        self.content = content
        self.isFromUser = isFromUser
        self.timestamp = timestamp
    }
}

struct AIRequest: Codable {
    
    let prompt: String
    let userId: String
}
