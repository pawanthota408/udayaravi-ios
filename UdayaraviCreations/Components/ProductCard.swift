import SwiftUI

public struct ProductCard: View {
    public let product: SareeProduct
    public let onSelect: () -> Void
    public let onAddToCart: () -> Void

    @EnvironmentObject var wishlistManager: WishlistManager

    public init(
        product: SareeProduct,
        onSelect: @escaping () -> Void,
        onAddToCart: @escaping () -> Void
    ) {
        self.product = product
        self.onSelect = onSelect
        self.onAddToCart = onAddToCart
    }

    public var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 8) {
                // Image Box with Badges
                ZStack(alignment: .topTrailing) {
                    ZStack(alignment: .topLeading) {
                        // Product Image
                        if let urlStr = product.imageUrl, let url = URL(string: urlStr) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    Rectangle()
                                        .fill(Color(red: 245/255, green: 245/255, blue: 245/255))
                                        .overlay(ProgressView())
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                case .failure:
                                    fallbackImage
                                @unknown default:
                                    fallbackImage
                                }
                            }
                        } else {
                            fallbackImage
                        }

                        // Machine / Design Badge
                        if product.isMachine {
                            Text("INDUSTRIAL LOOM")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(AppTheme.royalRed)
                                .cornerRadius(3)
                                .padding(8)
                        } else if product.bmpFileUrl != nil {
                            Text("BMP PATTERN")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(AppTheme.flipkartBlue)
                                .cornerRadius(3)
                                .padding(8)
                        }
                    }
                    .frame(height: 160)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 248/255, green: 248/255, blue: 248/255))
                    .clipped()

                    // Wishlist Heart Button
                    Button(action: {
                        wishlistManager.toggle(product: product)
                    }) {
                        Image(systemName: wishlistManager.isFavorite(productId: product.id) ? "heart.fill" : "heart")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(wishlistManager.isFavorite(productId: product.id) ? AppTheme.royalRed : Color.gray)
                            .padding(7)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.12), radius: 2, x: 0, y: 1)
                    }
                    .padding(8)
                }
                .cornerRadius(6)

                // Info Section
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(height: 34, alignment: .topLeading)

                    Text(product.isMachine ? (product.machineModel ?? "Loom") : product.sareeType)
                        .font(.system(size: 11))
                        .foregroundColor(AppTheme.textSecondary)
                        .lineLimit(1)

                    // Price and Discount Row
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(product.formattedPrice)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)

                        if let orig = product.originalPrice, !orig.isEmpty {
                            Text("₹\(orig.replacingOccurrences(of: "₹", with: ""))")
                                .font(.system(size: 11))
                                .foregroundColor(AppTheme.textSecondary)
                                .strikethrough()
                        }

                        if let disc = product.discount, !disc.isEmpty {
                            Text(disc)
                                .font(.system(size: 10.5, weight: .bold))
                                .foregroundColor(AppTheme.starGreen)
                        }

                        Spacer()
                    }

                    // Add to Cart Button
                    Button(action: onAddToCart) {
                        HStack(spacing: 4) {
                            Image(systemName: "cart.badge.plus")
                                .font(.system(size: 11))
                            Text("Add to Cart")
                                .font(.system(size: 11, weight: .semibold))
                        }
                        .foregroundColor(AppTheme.flipkartBlue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(Color(red: 238/255, green: 244/255, blue: 255/255))
                        .cornerRadius(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(AppTheme.flipkartBlue.opacity(0.4), lineWidth: 0.8)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.top, 4)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(AppTheme.border, lineWidth: 0.6)
            )
            .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var fallbackImage: some View {
        Rectangle()
            .fill(Color(red: 245/255, green: 245/255, blue: 245/255))
            .overlay(
                Image(systemName: product.isMachine ? "gearshape.2.fill" : "tshirt.fill")
                    .font(.system(size: 32))
                    .foregroundColor(Color.gray.opacity(0.4))
            )
    }
}

