import SwiftUI

struct AppColors {
    
    // TODO: Customize these w/ whatever for color scheme
    static let primary = Color.blue
    static let secondary = Color.indigo
    static let accent = Color.orange
    static let background = Color(.systemBackground)
    static let surface = Color(.secondarySystemBackground)
    static let onSurface = Color(.label)
    static let onSurfaceSecondary = Color(.secondaryLabel)
    static let success = Color.green
    static let error = Color.red
    static let warning = Color.yellow
    
    // Chat specific colors
    static let userMessageBackground = Color.blue
    static let aiMessageBackground = Color(.systemGray5)
    static let messageText = Color.white
    static let aiMessageText = Color(.label)
}

extension Color {
    
    static let appPrimary = AppColors.primary
    static let appSecondary = AppColors.secondary
    static let appAccent = AppColors.accent
    static let appBackground = AppColors.background
    static let appSurface = AppColors.surface
    static let appOnSurface = AppColors.onSurface
}
