import SwiftUI

public struct MainHomeView: View {
    @ObservedObject var apiService = APIService.shared
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var wishlistManager: WishlistManager

    public let onNavigateToCatalog: (String) -> Void
    public let onSelectProduct: (SareeProduct) -> Void
    public let onOpenCart: () -> Void

    @State private var toastMessage: String? = nil
    @State private var searchText: String = ""

    public init(
        onNavigateToCatalog: @escaping (String) -> Void,
        onSelectProduct: @escaping (SareeProduct) -> Void,
        onOpenCart: @escaping () -> Void
    ) {
        self.onNavigateToCatalog = onNavigateToCatalog
        self.onSelectProduct = onSelectProduct
        self.onOpenCart = onOpenCart
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Top Header Bar
            ZStack {
                AppTheme.flipkartBlue
                    .edgesIgnoringSafeArea(.top)

                VStack(spacing: 8) {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 1) {
                            Text("UDAYARAVI")
                                .font(.system(size: 16, weight: .black))
                                .foregroundColor(AppTheme.lightGold)
                                .tracking(1.2)
                            Text("CREATIONS")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white.opacity(0.9))
                                .tracking(2.5)
                        }

                        Spacer()

                        // Cart Button with Badge
                        Button(action: onOpenCart) {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "cart.fill")
                                    .font(.system(size: 19))
                                    .foregroundColor(.white)
                                    .frame(width: 32, height: 32)

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

                    // Search Shortcut Field
                    Button(action: {
                        onNavigateToCatalog("All")
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color.gray)
                                .font(.system(size: 14))

                            Text("Search Sarees, Looms, Jacquard Designs...")
                                .font(.system(size: 13))
                                .foregroundColor(Color.gray)

                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 9)
                        .background(Color.white)
                        .cornerRadius(6)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
                .padding(.top, 4)
            }
            .frame(height: 104)

            // MARK: - Scrollable Content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 14) {
                    // 1. Hero Banner Slider
                    BannerCarouselView(banners: apiService.homeData.banners) { banner in
                        if banner.title.contains("Loom") {
                            onNavigateToCatalog("Looms")
                        } else {
                            onNavigateToCatalog("Apparels")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)

                    // 2. ISO 9001:2015 Manufacturer Trust Bar
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(AppTheme.darkGold)
                            .font(.system(size: 22))

                        VStack(alignment: .leading, spacing: 2) {
                            Text("ISO 9001:2015 CERTIFIED MANUFACTURER")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)
                            Text("Leading Jacquard Looms & Pure Silk Sarees Since 1976")
                                .font(.system(size: 10.5))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color(red: 254/255, green: 250/255, blue: 235/255))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppTheme.gold.opacity(0.4), lineWidth: 1)
                    )
                    .padding(.horizontal, 16)

                    // 3. Three Metrics Counters (50+ Legacy | 10k+ Looms | 5k+ Patterns)
                    HStack(spacing: 8) {
                        MetricBox(number: "50+", label: "Years Legacy")
                        MetricBox(number: "10k+", label: "Looms Shipped")
                        MetricBox(number: "5k+", label: "Master Patterns")
                    }
                    .padding(.horizontal, 16)

                    // 4. Quick Category Shortcuts
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Browse by Division")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)
                            .padding(.horizontal, 16)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                CategoryPill(icon: "tshirt.fill", title: "Apparels & Sarees", count: "120+ Items", color: Color(red: 232/255, green: 240/255, blue: 254/255), textColor: AppTheme.flipkartBlue) {
                                    onNavigateToCatalog("Apparels")
                                }
                                CategoryPill(icon: "gearshape.2.fill", title: "Industrial Looms", count: "35+ Machines", color: Color(red: 254/255, green: 238/255, blue: 238/255), textColor: AppTheme.royalRed) {
                                    onNavigateToCatalog("Looms")
                                }
                                CategoryPill(icon: "doc.text.image.fill", title: "Jacquard Designs", count: "250+ .BMP Files", color: Color(red: 254/255, green: 250/255, blue: 235/255), textColor: AppTheme.darkGold) {
                                    onNavigateToCatalog("Designs")
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }

                    // 5. Featured Sarees Section
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Pure Silk & Wedding Sarees", subtitle: "Woven on UdayaRavi Electronic Jacquards") {
                            onNavigateToCatalog("Apparels")
                        }

                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                            ForEach(apiService.homeData.featuredSarees) { product in
                                ProductCard(
                                    product: product,
                                    onSelect: { onSelectProduct(product) },
                                    onAddToCart: {
                                        cartManager.addToCart(product: product)
                                        showToast("Added to Cart!")
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    // 6. Industrial Machinery & Electronic Jacquard Section
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Textile Machinery & Electronic Jacquards", subtitle: "High Speed Weaving & Loom Setup") {
                            onNavigateToCatalog("Looms")
                        }

                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                            ForEach(apiService.homeData.featuredMachines) { machine in
                                ProductCard(
                                    product: machine,
                                    onSelect: { onSelectProduct(machine) },
                                    onAddToCart: {
                                        cartManager.addToCart(product: machine)
                                        showToast("Machine booked in Cart!")
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    // 7. Jacquard .BMP Punch-Card Patterns Section
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Jacquard Punching Designs (.BMP)", subtitle: "Production-ready electronic loom punch cards") {
                            onNavigateToCatalog("Designs")
                        }

                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                            ForEach(apiService.homeData.featuredDesigns) { design in
                                ProductCard(
                                    product: design,
                                    onSelect: { onSelectProduct(design) },
                                    onAddToCart: {
                                        cartManager.addToCart(product: design)
                                        showToast("Design added to Cart!")
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    // 8. 24/7 Weavers & Industrial Helpline Banner
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "phone.bubble.left.fill")
                                .font(.system(size: 26))
                                .foregroundColor(AppTheme.gold)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Need Custom Jacquard Loom Setup?")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                                Text("Call our Master Technicians in Salem, Tamil Nadu")
                                    .font(.system(size: 11.5))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            Spacer()
                        }

                        Button(action: {
                            if let url = URL(string: "tel://919876543210") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Call +91 98765 43210")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(AppTheme.gold)
                                .cornerRadius(6)
                        }
                    }
                    .padding(16)
                    .background(AppTheme.luxuryDarkGradient)
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
            .background(AppTheme.pageBg)
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
        .onAppear {
            apiService.fetchMainHome()
        }
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

// MARK: - Metric Box Component
struct MetricBox: View {
    let number: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(number)
                .font(.system(size: 16, weight: .heavy))
                .foregroundColor(AppTheme.flipkartBlue)
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color.white)
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(AppTheme.border, lineWidth: 0.6)
        )
    }
}

// MARK: - Category Pill Component
struct CategoryPill: View {
    let icon: String
    let title: String
    let count: String
    let color: Color
    let textColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(textColor.opacity(0.12))
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(textColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                    Text(count)
                        .font(.system(size: 11))
                        .foregroundColor(AppTheme.textSecondary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(AppTheme.border, lineWidth: 0.8)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Section Header Component
struct SectionHeader: View {
    let title: String
    let subtitle: String
    let onViewAll: () -> Void

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15.5, weight: .bold))
                    .foregroundColor(AppTheme.textPrimary)
                Text(subtitle)
                    .font(.system(size: 11.5))
                    .foregroundColor(AppTheme.textSecondary)
            }

            Spacer()

            Button(action: onViewAll) {
                Text("View All")
                    .font(.system(size: 12.5, weight: .bold))
                    .foregroundColor(AppTheme.flipkartBlue)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
    }
}

