import SwiftUI

public struct ToastView: View {
    public let message: String

    public init(message: String) {
        self.message = message
    }

    public var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(AppTheme.starGreen)
                .font(.system(size: 15))

            Text(message)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.black.opacity(0.88))
        .cornerRadius(22)
        .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 3)
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }
}

