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

// TODO: Update with id
extension TeamMember {
    
    static let teamMembers = [
        
        TeamMember(name: "Dalraj Bains", bcitId: "A01384780"),
        TeamMember(name: "Evan Vink", bcitId: "A0"),
        TeamMember(name: "Shayan Nikpour", bcitId: "A0")
    ]
}
