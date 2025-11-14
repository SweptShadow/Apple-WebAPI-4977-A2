import SwiftUI

struct AIView: View {
    
    @StateObject private var chatViewModel = ChatViewModel()
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                // Chat Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(chatViewModel.messages) { message in
                                ChatBubbleView(message: message)
                                    .id(message.id)
                            }
                            
                            if chatViewModel.isLoading {
                                HStack {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                    Text("AI is thinking...")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                    .onChange(of: chatViewModel.messages.count) {
                        if let lastMessage = chatViewModel.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Input Area
                HStack {
                    TextField("Ask me anything...", text: $chatViewModel.currentMessage, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(1...4)
                    
                    Button(action: {
                        Task {
                            await chatViewModel.sendMessage()
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.appPrimary)
                            .clipShape(Circle())
                    }
                    .disabled(chatViewModel.currentMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || chatViewModel.isLoading)
                }
                .padding()
            }
            .background(Color.appBackground)
            .navigationTitle("AI Assistant")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") {
                        chatViewModel.clearChat()
                    }
                    .disabled(chatViewModel.messages.isEmpty)
                }
            }
        }
    }
}

struct ChatBubbleView: View {
    
    let message: ChatMessage
    
    var body: some View {
        
        HStack {
            
            if message.isFromUser {
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(AppColors.userMessageBackground)
                        .foregroundColor(AppColors.messageText)
                        .cornerRadius(16)
                        .frame(maxWidth: .infinity * 0.75, alignment: .trailing)
                    
                    Text(ValidationUtils.formatDateTime(message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text(markdownToAttributedString(message.content))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(AppColors.aiMessageBackground)
                        .foregroundColor(AppColors.aiMessageText)
                        .cornerRadius(16)
                        .frame(maxWidth: .infinity * 0.75, alignment: .leading)
                    
                    Text(ValidationUtils.formatDateTime(message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

// Helper function to convert simple markdown to AttributedString
func markdownToAttributedString(_ text: String) -> AttributedString {
    do {
        // SwiftUI supports markdown natively in iOS 15+
        return try AttributedString(markdown: text)
    } catch {
        // Fallback to plain text if markdown parsing fails
        return AttributedString(text)
    }
}

#Preview {
    AIView()
}
