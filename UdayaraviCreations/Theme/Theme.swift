import SwiftUI

public struct AppTheme {
    // MARK: - Brand Palette
    public static let flipkartBlue = Color(red: 40/255, green: 116/255, blue: 240/255)
    public static let navyBlue = Color(red: 16/255, green: 44/255, blue: 87/255)
    public static let gold = Color(red: 212/255, green: 175/255, blue: 55/255)
    public static let lightGold = Color(red: 255/255, green: 223/255, blue: 115/255)
    public static let darkGold = Color(red: 184/255, green: 134/255, blue: 11/255)
    public static let royalRed = Color(red: 200/255, green: 16/255, blue: 46/255)
    public static let starGreen = Color(red: 56/255, green: 142/255, blue: 60/255)
    public static let lightGreenBg = Color(red: 241/255, green: 248/255, blue: 233/255)
    
    // Backgrounds & Neutrals
    public static let pageBg = Color(red: 241/255, green: 243/255, blue: 246/255)
    public static let cardBg = Color.white
    public static let textPrimary = Color(red: 33/255, green: 33/255, blue: 33/255)
    public static let textSecondary = Color(red: 117/255, green: 117/255, blue: 117/255)
    public static let border = Color(red: 224/255, green: 224/255, blue: 224/255)
    public static let separator = Color(red: 238/255, green: 238/255, blue: 238/255)
    public static let darkBg = Color(red: 20/255, green: 20/255, blue: 22/255)

    // MARK: - Gradients
    public static let blueGradient = LinearGradient(
        colors: [flipkartBlue, Color(red: 25/255, green: 85/255, blue: 195/255)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let goldGradient = LinearGradient(
        colors: [Color(red: 255/255, green: 223/255, blue: 115/255), Color(red: 212/255, green: 175/255, blue: 55/255)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    public static let luxuryDarkGradient = LinearGradient(
        colors: [Color(red: 28/255, green: 28/255, blue: 30/255), Color(red: 14/255, green: 14/255, blue: 15/255)],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Global Helper to Dismiss Keyboard
public func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

// MARK: - View Extension for Dismiss Keyboard & Common Modifiers
extension View {
    public func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    public func cardStyle(cornerRadius: CGFloat = 8, padding: CGFloat = 12) -> some View {
        self
            .padding(padding)
            .background(AppTheme.cardBg)
            .cornerRadius(cornerRadius)
            .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 1)
    }
}

