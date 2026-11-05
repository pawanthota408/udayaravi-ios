import SwiftUI

public struct ProductDetailView: View {
    public let product: SareeProduct
    public let onBack: () -> Void
    public let onProceedToCheckout: () -> Void
    public let onOpenCart: () -> Void

    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var wishlistManager: WishlistManager

    @State private var selectedImageIndex: Int = 0
    @State private var selectedVariant: ProductVariant? = nil
    @State private var quantity: Int = 1
    @State private var pincode: String = "636003"
    @State private var pincodeChecked: Bool = false
    @State private var toastMessage: String? = nil

    public init(
        product: SareeProduct,
        onBack: @escaping () -> Void,
        onProceedToCheckout: @escaping () -> Void,
        onOpenCart: @escaping () -> Void
    ) {
        self.product = product
        self.onBack = onBack
        self.onProceedToCheckout = onProceedToCheckout
        self.onOpenCart = onOpenCart
        self._selectedVariant = State(initialValue: product.variants.first)
    }

    private var displayImages: [String] {
        if !product.imageList.isEmpty {
            return product.imageList
        }
        if let img = product.imageUrl {
            return [img]
        }
        return []
    }

    private var activePrice: String {
        selectedVariant?.price.isEmpty == false ? selectedVariant!.price : product.price
    }

    private var activeOriginalPrice: String? {
        selectedVariant?.originalPrice ?? product.originalPrice
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Top Header Bar
            CustomNavigationBar(
                title: product.isMachine ? "Machinery Details" : "Product Details",
                showBackButton: true,
                onBack: onBack,
                showCartButton: true,
                onCartTap: onOpenCart
            )

            // MARK: - Scrollable Product Content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // 1. Image Carousel Box
                    ZStack(alignment: .bottom) {
                        TabView(selection: $selectedImageIndex) {
                            if displayImages.isEmpty {
                                Rectangle()
                                    .fill(Color(red: 245/255, green: 245/255, blue: 245/255))
                                    .overlay(
                                        Image(systemName: product.isMachine ? "gearshape.2.fill" : "tshirt.fill")
                                            .font(.system(size: 48))
                                            .foregroundColor(.gray.opacity(0.4))
                                    )
                                    .tag(0)
                            } else {
                                ForEach(0..<displayImages.count, id: \.self) { idx in
                                    let urlStr = displayImages[idx]
                                    if let url = URL(string: urlStr) {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            default:
                                                Rectangle()
                                                    .fill(Color(red: 245/255, green: 245/255, blue: 245/255))
                                                    .overlay(ProgressView())
                                            }
                                        }
                                        .tag(idx)
                                    }
                                }
                            }
                        }
                        .frame(height: 320)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                        // Image Indicator Dots
                        if displayImages.count > 1 {
                            HStack(spacing: 6) {
                                ForEach(0..<displayImages.count, id: \.self) { idx in
                                    Circle()
                                        .fill(selectedImageIndex == idx ? AppTheme.flipkartBlue : Color.gray.opacity(0.35))
                                        .frame(width: 7, height: 7)
                                }
                            }
                            .padding(.bottom, 12)
                        }

                        // Floating Wishlist Button
                        HStack {
                            Spacer()
                            Button(action: {
                                wishlistManager.toggle(product: product)
                                showToast(wishlistManager.isFavorite(productId: product.id) ? "Added to Wishlist" : "Removed from Wishlist")
                            }) {
                                Image(systemName: wishlistManager.isFavorite(productId: product.id) ? "heart.fill" : "heart")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(wishlistManager.isFavorite(productId: product.id) ? AppTheme.royalRed : Color.gray)
                                    .padding(10)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                            }
                            .padding(16)
                        }
                    }
                    .background(Color.white)

                    Divider()

                    // 2. Title, Ratings & Price Box
                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.title)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)

                        HStack(spacing: 8) {
                            HStack(spacing: 3) {
                                Text("4.8")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                Image(systemName: "star.fill")
                                    .font(.system(size: 9))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(AppTheme.starGreen)
                            .cornerRadius(3)

                            Text("284 Ratings & 48 Reviews")
                                .font(.system(size: 12))
                                .foregroundColor(AppTheme.textSecondary)

                            Spacer()

                            Text("Seller: UdayaRavi")
                                .font(.system(size: 11.5, weight: .medium))
                                .foregroundColor(AppTheme.textSecondary)
                        }

                        // Price Row
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text("₹\(activePrice.replacingOccurrences(of: "₹", with: ""))")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)

                            if let orig = activeOriginalPrice, !orig.isEmpty {
                                Text("₹\(orig.replacingOccurrences(of: "₹", with: ""))")
                                    .font(.system(size: 14))
                                    .foregroundColor(AppTheme.textSecondary)
                                    .strikethrough()
                            }

                            if let disc = product.discount, !disc.isEmpty {
                                Text(disc)
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(AppTheme.starGreen)
                            }
                        }

                        Text("Free Delivery on orders above ₹999")
                            .font(.system(size: 11.5, weight: .medium))
                            .foregroundColor(AppTheme.starGreen)
                    }
                    .padding(16)
                    .background(Color.white)

                    Rectangle()
                        .fill(AppTheme.pageBg)
                        .frame(height: 8)

                    // 3. Color / Variant Selector (if available)
                    if !product.variants.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Select Option / Color")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(product.variants) { variant in
                                        let isSel = (selectedVariant?.id == variant.id)
                                        Button(action: { selectedVariant = variant }) {
                                            VStack(spacing: 3) {
                                                Text(variant.color.isEmpty ? variant.size : variant.color)
                                                    .font(.system(size: 13, weight: isSel ? .bold : .medium))
                                                    .foregroundColor(isSel ? AppTheme.flipkartBlue : AppTheme.textPrimary)
                                                Text("₹\(variant.price)")
                                                    .font(.system(size: 11))
                                                    .foregroundColor(AppTheme.textSecondary)
                                            }
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 8)
                                            .background(isSel ? Color(red: 232/255, green: 240/255, blue: 254/255) : Color.white)
                                            .cornerRadius(6)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 6)
                                                    .stroke(isSel ? AppTheme.flipkartBlue : AppTheme.border, lineWidth: isSel ? 1.5 : 1)
                                            )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.white)

                        Rectangle()
                            .fill(AppTheme.pageBg)
                            .frame(height: 8)
                    }

                    // 4. Technical Specifications Box
                    VStack(alignment: .leading, spacing: 10) {
                        Text(product.isMachine ? "Machine Specifications" : "Product Details")
                            .font(.system(size: 14.5, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)

                        VStack(spacing: 8) {
                            if product.isMachine {
                                SpecRow(title: "Model", value: product.machineModel ?? "UR-2688 PRO Series")
                                SpecRow(title: "Weaving Speed", value: product.weavingSpeed ?? "300 - 350 RPM")
                                SpecRow(title: "Power Rating", value: product.powerRating ?? "2.2 kW Heavy Duty")
                                SpecRow(title: "Warranty", value: product.warrantyPeriod ?? "2 Years On-Site Free Service")
                                SpecRow(title: "Installation", value: "Free Factory Visit & Engineer Setup Included")
                            } else if product.bmpFileUrl != nil {
                                SpecRow(title: "File Format", value: "Standard Electronic Jacquard .BMP")
                                SpecRow(title: "Resolution", value: "2688 / 1440 Hooks Pattern Matrix")
                                SpecRow(title: "Color Separation", value: "Full Warp/Weft Layers Included")
                                SpecRow(title: "Compatibility", value: "UdayaRavi, Bonas, Staubli, Chinese Looms")
                            } else {
                                SpecRow(title: "Fabric", value: product.sareeType)
                                SpecRow(title: "Zari Quality", value: "High Grade Metallic Gold Zari")
                                SpecRow(title: "Length", value: "6.3 Meters with Attached Blouse Piece")
                                SpecRow(title: "Care", value: "Dry Clean Only")
                                SpecRow(title: "Origin", value: "Handwoven in Salem, Tamil Nadu")
                            }
                        }
                    }
                    .padding(16)
                    .background(Color.white)

                    Rectangle()
                        .fill(AppTheme.pageBg)
                        .frame(height: 8)

                    // 5. Description Box
                    if let desc = product.description, !desc.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.system(size: 14.5, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)

                            Text(desc)
                                .font(.system(size: 13))
                                .foregroundColor(Color(red: 66/255, green: 66/255, blue: 66/255))
                                .lineSpacing(4)
                        }
                        .padding(16)
                        .background(Color.white)

                        Rectangle()
                            .fill(AppTheme.pageBg)
                            .frame(height: 8)
                    }

                    // 6. Jacquard .BMP File Download Row (if available)
                    if product.bmpFileUrl != nil {
                        Button(action: {
                            showToast("Downloading Jacquard Punch Pattern .BMP...")
                        }) {
                            HStack(spacing: 12) {
                                Text("🧵")
                                    .font(.system(size: 20))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Download Jacquard .BMP Pattern File")
                                        .font(.system(size: 13.5, weight: .semibold))
                                        .foregroundColor(AppTheme.textPrimary)
                                    Text("Direct punch-card file for loom USB controller")
                                        .font(.system(size: 11))
                                        .foregroundColor(AppTheme.textSecondary)
                                }
                                Spacer()
                                Image(systemName: "arrow.down.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(AppTheme.flipkartBlue)
                            }
                            .padding(14)
                            .background(Color.white)
                        }

                        Rectangle()
                            .fill(AppTheme.pageBg)
                            .frame(height: 8)
                    }

                    // 7. Delivery Pincode Checker
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Delivery Options")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)

                        HStack(spacing: 8) {
                            TextField("Enter 6-digit Pincode", text: $pincode)
                                .font(.system(size: 13))
                                .keyboardType(.numberPad)
                                .padding(10)
                                .background(Color(red: 248/255, green: 248/255, blue: 248/255))
                                .cornerRadius(6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(AppTheme.border, lineWidth: 1)
                                )

                            Button(action: {
                                pincodeChecked = true
                                hideKeyboard()
                            }) {
                                Text("Check")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(AppTheme.flipkartBlue)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color(red: 232/255, green: 240/255, blue: 254/255))
                                    .cornerRadius(6)
                            }
                        }

                        if pincodeChecked {
                            HStack(spacing: 6) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(AppTheme.starGreen)
                                    .font(.system(size: 12))
                                Text(product.isMachine ? "Factory Installation team available in \(pincode) within 3-5 days" : "Express Delivery available to \(pincode) by Wednesday")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppTheme.starGreen)
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(16)
                    .background(Color.white)

                    Spacer().frame(height: 32)
                }
            }
            .background(AppTheme.pageBg)

            // MARK: - Sticky Bottom Action Bar
            HStack(spacing: 12) {
                // Add to Cart Button
                Button(action: {
                    cartManager.addToCart(product: product, quantity: 1, variant: selectedVariant)
                    showToast("Added to Cart!")
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "cart.badge.plus")
                            .font(.system(size: 15))
                        Text("Add to Cart")
                            .font(.system(size: 15, weight: .bold))
                    }
                    .foregroundColor(AppTheme.textPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.white)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(AppTheme.border, lineWidth: 1)
                    )
                }

                // Buy Now Button
                Button(action: {
                    cartManager.addToCart(product: product, quantity: 1, variant: selectedVariant)
                    onProceedToCheckout()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 15))
                        Text(product.isMachine ? "Book Machine" : "Buy Now")
                            .font(.system(size: 15, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(AppTheme.flipkartBlue)
                    .cornerRadius(6)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.white)
            .overlay(
                Rectangle()
                    .fill(AppTheme.border)
                    .frame(height: 1),
                alignment: .top
            )
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

// MARK: - Spec Row Component
struct SpecRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.system(size: 12.5))
                .foregroundColor(AppTheme.textSecondary)
                .frame(width: 120, alignment: .leading)
            Text(value)
                .font(.system(size: 12.5, weight: .medium))
                .foregroundColor(AppTheme.textPrimary)
            Spacer()
        }
        .padding(.vertical, 2)
    }
}

