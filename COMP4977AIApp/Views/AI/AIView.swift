import SwiftUI

struct AIView: View {
    
    @StateObject private var chatViewModel = ChatViewModel()
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        
        NavigationView {
            VStack(spacing: 0) {
                
                // MARK: - Chat Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(chatViewModel.messages) { message in
                                ChatBubbleView(message: message)
                                    .id(message.id)
                            }
                            
                            if chatViewModel.isLoading {
                                HStack(spacing: 8) {
                                    ProgressView()
                                        .tint(.purple)
                                    Text("AI is thinking…")
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.vertical)
                    }
                    .onChange(of: chatViewModel.messages.count) {
                        if let last = chatViewModel.messages.last {
                            withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                        }
                    }
                }
                
                // MARK: - Bottom Input Bar
                inputBar
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .background(backgroundGradient)
            .navigationTitle("AI Assistant")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.black.opacity(0.2), for: .navigationBar)
            .toolbar {
                if !chatViewModel.messages.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Clear") {
                            chatViewModel.clearChat()
                        }
                        .foregroundColor(.purple)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("AI Assistant")
                        .font(.headline)
                        .foregroundColor(.white)   // ← stays white ALWAYS
                }
            }
            
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    
    // MARK: - Input Bar View
    var inputBar: some View {
        HStack(spacing: 10) {
            
            // TEXTFIELD + GLASS STYLE
            ZStack(alignment: .leading) {
                if chatViewModel.currentMessage.isEmpty {
                    Text("Type here…")
                        .foregroundColor(.white.opacity(0.45))
                        .padding(.leading, 14)
                }
                
                TextField("", text: $chatViewModel.currentMessage, axis: .vertical)
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 14)
                    .focused($isTextFieldFocused)
                    .onSubmit(sendMessageSafely)
            }
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white.opacity(0.08))
                    .background(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.10), lineWidth: 1)
            )
            
            // SEND BUTTON
            Button(action: sendMessageSafely) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.purple, Color.blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 42, height: 42)
                        .shadow(color: .purple.opacity(0.5), radius: 12, x: 0, y: 4)
                    
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.white)
                }
            }
            .disabled(chatViewModel.currentMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
    
    
    // MARK: - Background Theme
    var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.08, green: 0.00, blue: 0.20),
                Color(red: 0.02, green: 0.00, blue: 0.08),
                Color.black
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    
    // MARK: - Send function
    func sendMessageSafely() {
        let trimmed = chatViewModel.currentMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        Task {
            await chatViewModel.sendMessage()
            isTextFieldFocused = true
        }
    }
}



// MARK: - Chat Bubble Theme
struct ChatBubbleView: View {
    
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
                userBubble
            } else {
                aiBubble
                Spacer()
            }
        }
        .padding(.horizontal)
    }
    
    // USER BUBBLE
    var userBubble: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(message.content)
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [Color.purple.opacity(0.35),
                                 Color.blue.opacity(0.25)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: .purple.opacity(0.25), radius: 10)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: .trailing)
            
            timestamp
        }
    }
    
    // AI BUBBLE
    var aiBubble: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(markdownToAttributedString(message.content))
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.05))
                        .background(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.10), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: .leading)
            
            timestamp
        }
    }
    
    var timestamp: some View {
        Text(ValidationUtils.formatDateTime(message.timestamp))
            .font(.caption2)
            .foregroundColor(.white.opacity(0.4))
    }
}


// MARK: - Markdown Parser
func markdownToAttributedString(_ text: String) -> AttributedString {
    do {
        var options = AttributedString.MarkdownParsingOptions()
        options.interpretedSyntax = .inlineOnlyPreservingWhitespace
        return try AttributedString(markdown: text, options: options)
    } catch {
        return AttributedString(text)
    }
}

#Preview {
    AIView()
}
