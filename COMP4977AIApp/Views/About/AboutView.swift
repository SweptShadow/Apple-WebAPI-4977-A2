import SwiftUI

struct AboutView: View {
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                VStack(spacing: 24) {
                    
                    // App Info
                    VStack(spacing: 16) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 60))
                            .foregroundColor(.appPrimary)
                        
                        Text("AI Assistant App")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("COMP 4977 - Assignment 2")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("An iOS application that connects to an AI service through a secure WebAPI backend.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // Team Information
                    VStack(spacing: 16) {
                        Text("Development Team")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(TeamMember.teamMembers) { member in
                                TeamMemberCard(member: member)
                            }
                        }
                    }
                    
                    Spacer(minLength: 40)
                    
                    // Additional Info
                    VStack(spacing: 8) {
                        Text("© 2025 BCIT COMP 4977")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Built with Lack of Sleep")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 20)
                }
                
            }
            .background(Color.appBackground)
            .navigationTitle("About")
        }
    }
}

struct TeamMemberCard: View {
    
    let member: TeamMember
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(member.name)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text("Student ID: \(member.bcitId)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "person.circle")
                .font(.title2)
                .foregroundColor(.appPrimary)
        }
        .padding()
        .background(Color.appSurface)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
        .padding(.horizontal, 20)
    }
    
}

#Preview {
    AboutView()
}
