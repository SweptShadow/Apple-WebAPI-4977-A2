import Foundation

struct TeamMember: Identifiable {
    
    let id: UUID
    let name: String
    let bcitId: String
    
    init(id: UUID = UUID(), name: String, bcitId: String) {
        
        self.id = id
        self.name = name
        self.bcitId = bcitId
    }
}

// MARK: - Team Members Data
extension TeamMember {
    
    static let teamMembers = [
        TeamMember(name: "Dalraj Bains", bcitId: "A01384780"),
        TeamMember(name: "Evan Vink", bcitId: "A01381720"),
        TeamMember(name: "Shayan Nikpour", bcitId: "A0")
    ]
}
