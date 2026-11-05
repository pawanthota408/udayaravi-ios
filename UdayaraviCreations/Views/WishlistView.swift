import SwiftUI

public struct WishlistView: View {
    @EnvironmentObject var wishlistManager: WishlistManager
    @EnvironmentObject var cartManager: CartManager

    public let onBack: () -> Void
    public let onSelectProduct: (SareeProduct) -> Void
    public let onOpenCart: () -> Void

    @State private var toastMessage: String? = nil

    public init(
        onBack: @escaping () -> Void,
        onSelectProduct: @escaping (SareeProduct) -> Void,
        onOpenCart: @escaping () -> Void
    ) {
        self.onBack = onBack
        self.onSelectProduct = onSelectProduct
        self.onOpenCart = onOpenCart
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Header
            CustomNavigationBar(
                title: "My Wishlist (\(wishlistManager.favorites.count))",
                showBackButton: true,
                onBack: onBack,
                showCartButton: true,
                onCartTap: onOpenCart
            )

            if wishlistManager.favorites.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    Image(systemName: "heart.slash")
                        .font(.system(size: 60))
                        .foregroundColor(Color.gray.opacity(0.35))

                    Text("Your Wishlist is Empty")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)

                    Text("Explore our exquisite Kanchipuram silk sarees, jacquard machines, and punch designs to save your favorites.")
                        .font(.system(size: 13))
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 36)

                    Button(action: onBack) {
                        Text("Explore Now")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 12)
                            .background(AppTheme.flipkartBlue)
                            .cornerRadius(6)
                    }
                    .padding(.top, 8)

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppTheme.pageBg)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("\(wishlistManager.favorites.count) Items Saved")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                            .padding(.horizontal, 16)
                            .padding(.top, 10)

                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                            ForEach(wishlistManager.favorites) { product in
                                ProductCard(
                                    product: product,
                                    onSelect: { onSelectProduct(product) },
                                    onAddToCart: {
                                        cartManager.addToCart(product: product)
                                        showToast("Moved to Cart!")
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    }
                }
                .background(AppTheme.pageBg)
            }
        }
        .overlay(
            VStack {
                Spacer()
                if let msg = toastMessage {
                    ToastView(message: msg)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        )
    }

    private func showToast(_ msg: String) {
        withAnimation {
            toastMessage = msg
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                toastMessage = nil
            }
        }
    }
}

