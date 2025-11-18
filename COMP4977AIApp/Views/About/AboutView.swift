import SwiftUI

struct AboutView: View {
    
    @State private var showToolbar = false
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                VStack(spacing: 32) {
                    
                    // MARK: - App Icon + Info
                    VStack(spacing: 16) {
                        
                        // Glowing brain icon
                        ZStack {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color.purple.opacity(0.5),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 80
                                    )
                                )
                                .blur(radius: 12)
                            
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.purple, Color.pink, Color.blue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .shadow(color: .purple.opacity(0.6), radius: 12)
                                .overlay(
                                    Image(systemName: "brain.head.profile")
                                        .font(.system(size: 40, weight: .medium))
                                        .foregroundColor(.white)
                                )
                        }
                        .padding(.top, 30)
                        
                        Text("AI Assistant App")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("COMP 4977 - Assignment 2")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text("An iOS application that connects to an AI service through a secure WebAPI backend.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.85))
                            .padding(.horizontal, 40)
                    }
                    
                    Divider()
                        .overlay(Color.white.opacity(0.2))
                        .padding(.horizontal)
                    
                    // MARK: - Team Information
                    VStack(spacing: 18) {
                        Text("Development Team")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        LazyVStack(spacing: 14) {
                            ForEach(TeamMember.teamMembers) { member in
                                TeamMemberCard(member: member)
                            }
                        }
                    }
                    
                    Spacer(minLength: 40)
                    
                    // MARK: - Footer
                    VStack(spacing: 4) {
                        Text("© 2025 BCIT COMP 4977")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                        
                        Text("Built with Lack of Sleep")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.bottom, 40)
                }
            }
            .background(neonBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if showToolbar {
                    ToolbarItem(placement: .principal) {
                        Text("About")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.async {
                    showToolbar = true
                }
            }
        }
    }
}



// MARK: - Team Card Styled to Match Neon Theme
struct TeamMemberCard: View {
    
    let member: TeamMember
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(member.name)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text("Student ID: \(member.bcitId)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))
            }
            
            Spacer()
            
            // glowing user icon
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Color.blue.opacity(0.3),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 30
                        )
                    )
                    .blur(radius: 6)
                
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.08))
                .background(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.25), radius: 6, y: 3)
        .padding(.horizontal, 20)
    }
}


#Preview {
    AboutView()
}
