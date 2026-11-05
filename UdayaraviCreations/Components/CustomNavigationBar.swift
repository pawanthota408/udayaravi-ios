import SwiftUI

public struct CustomNavigationBar: View {
    public let title: String
    public var showBackButton: Bool = false
    public var onBack: (() -> Void)? = nil
    public var showCartButton: Bool = true
    public var onCartTap: (() -> Void)? = nil

    @EnvironmentObject var cartManager: CartManager

    public init(
        title: String,
        showBackButton: Bool = false,
        onBack: (() -> Void)? = nil,
        showCartButton: Bool = true,
        onCartTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.showBackButton = showBackButton
        self.onBack = onBack
        self.showCartButton = showCartButton
        self.onCartTap = onCartTap
    }

    public var body: some View {
        ZStack {
            AppTheme.flipkartBlue
                .edgesIgnoringSafeArea(.top)

            HStack(spacing: 12) {
                if showBackButton {
                    Button(action: {
                        onBack?()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                    }
                }

                Text(title)
                    .font(.system(size: 19, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)

                Spacer()

                if showCartButton {
                    Button(action: {
                        onCartTap?()
                    }) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "cart.fill")
                                .font(.system(size: 19))
                                .foregroundColor(.white)
                                .frame(width: 34, height: 34)

                            if cartManager.totalItemCount > 0 {
                                Text("\(cartManager.totalItemCount)")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(AppTheme.royalRed)
                                    .clipShape(Circle())
                                    .offset(x: 4, y: -2)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
            .padding(.top, 4)
        }
        .frame(height: 52)
    }
}

