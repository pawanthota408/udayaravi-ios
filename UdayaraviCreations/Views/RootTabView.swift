import SwiftUI

public enum NavigationDestination: Identifiable {
    case productDetail(SareeProduct)
    case checkout
    case orderSuccess(OrderModel)
    case wishlist
    case addresses
    case settings

    public var id: String {
        switch self {
        case .productDetail(let prod):
            return "product_\(prod.id)"
        case .checkout:
            return "checkout"
        case .orderSuccess(let order):
            return "order_success_\(order.id)"
        case .wishlist:
            return "wishlist"
        case .addresses:
            return "addresses"
        case .settings:
            return "settings"
        }
    }
}

public struct RootTabView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var wishlistManager: WishlistManager
    @EnvironmentObject var userManager: UserManager

    @State private var selectedTab: Int = 0
    @State private var initialCatalogDivision: String = "Apparels"
    @State private var navigationStack: [NavigationDestination] = []
    @State private var showLoginView: Bool = false

    public init() {}

    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Active Screen Content
                ZStack {
                    switch selectedTab {
                    case 0:
                        MainHomeView(
                            onNavigateToCatalog: { division in
                                initialCatalogDivision = division
                                selectedTab = 1
                            },
                            onSelectProduct: { product in
                                navigationStack.append(.productDetail(product))
                            },
                            onOpenCart: {
                                selectedTab = 3
                            }
                        )

                    case 1:
                        CatalogView(
                            initialDivision: initialCatalogDivision,
                            onSelectProduct: { product in
                                navigationStack.append(.productDetail(product))
                            },
                            onOpenCart: {
                                selectedTab = 3
                            }
                        )

                    case 2:
                        OrdersView(
                            onBack: {
                                selectedTab = 0
                            },
                            onTabChange: { tab in
                                selectedTab = tab
                            }
                        )

                    case 3:
                        CartView(
                            onProceedToCheckout: {
                                navigationStack.append(.checkout)
                            },
                            onContinueShopping: {
                                selectedTab = 0
                            }
                        )

                    case 4:
                        ProfileView(
                            onNavigateToOrders: {
                                selectedTab = 2
                            },
                            onNavigateToWishlist: {
                                navigationStack.append(.wishlist)
                            },
                            onNavigateToAddresses: {
                                navigationStack.append(.addresses)
                            },
                            onNavigateToSettings: {
                                navigationStack.append(.settings)
                            },
                            onLogout: {
                                userManager.logout()
                                showLoginView = true
                            }
                        )

                    default:
                        MainHomeView(
                            onNavigateToCatalog: { div in
                                initialCatalogDivision = div
                                selectedTab = 1
                            },
                            onSelectProduct: { prod in
                                navigationStack.append(.productDetail(prod))
                            },
                            onOpenCart: {
                                selectedTab = 3
                            }
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Bottom Tab Bar (hidden when on OrdersView which has its internal matching bar)
                if selectedTab != 2 {
                    HStack {
                        BottomBarButton(title: "Home", systemImage: "house.fill", isSelected: selectedTab == 0) {
                            selectedTab = 0
                        }
                        Spacer()
                        BottomBarButton(title: "Categories", systemImage: "square.grid.2x2.fill", isSelected: selectedTab == 1) {
                            selectedTab = 1
                        }
                        Spacer()
                        BottomBarButton(title: "My Orders", systemImage: "cube.box.fill", isSelected: selectedTab == 2) {
                            selectedTab = 2
                        }
                        Spacer()
                        BottomBarButton(
                            title: "Cart",
                            systemImage: "cart.fill",
                            isSelected: selectedTab == 3,
                            badgeCount: cartManager.totalItemCount
                        ) {
                            selectedTab = 3
                        }
                        Spacer()
                        BottomBarButton(title: "Profile", systemImage: "person.fill", isSelected: selectedTab == 4) {
                            selectedTab = 4
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .overlay(
                        Rectangle()
                            .fill(AppTheme.border)
                            .frame(height: 1),
                        alignment: .top
                    )
                }
            }

            // Global Overlay Screens pushed onto navigationStack
            if let activeDestination = navigationStack.last {
                ZStack {
                    Color.white.edgesIgnoringSafeArea(.all)

                    switch activeDestination {
                    case .productDetail(let product):
                        ProductDetailView(
                            product: product,
                            onBack: {
                                _ = navigationStack.popLast()
                            },
                            onProceedToCheckout: {
                                navigationStack.append(.checkout)
                            },
                            onOpenCart: {
                                _ = navigationStack.popLast()
                                selectedTab = 3
                            }
                        )

                    case .checkout:
                        CheckoutView(
                            onBack: {
                                _ = navigationStack.popLast()
                            },
                            onOrderPlaced: { newOrder in
                                navigationStack.removeAll()
                                navigationStack.append(.orderSuccess(newOrder))
                            }
                        )

                    case .orderSuccess(let order):
                        OrderSuccessView(
                            order: order,
                            onViewOrders: {
                                navigationStack.removeAll()
                                selectedTab = 2
                            },
                            onContinueShopping: {
                                navigationStack.removeAll()
                                selectedTab = 0
                            }
                        )

                    case .wishlist:
                        WishlistView(
                            onBack: {
                                _ = navigationStack.popLast()
                            },
                            onSelectProduct: { product in
                                navigationStack.append(.productDetail(product))
                            },
                            onOpenCart: {
                                _ = navigationStack.popLast()
                                selectedTab = 3
                            }
                        )

                    case .addresses:
                        AddressesView(
                            onBack: {
                                _ = navigationStack.popLast()
                            }
                        )

                    case .settings:
                        SettingsView(
                            onBack: {
                                _ = navigationStack.popLast()
                            }
                        )
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .trailing)
                ))
            }
        }
        .fullScreenCover(isPresented: $showLoginView) {
            LoginView(
                onLoginSuccess: {
                    showLoginView = false
                },
                onSkip: {
                    showLoginView = false
                }
            )
        }
    }
}

// MARK: - Bottom Bar Button Component
struct BottomBarButton: View {
    let title: String
    let systemImage: String
    let isSelected: Bool
    var badgeCount: Int = 0
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 3) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: systemImage)
                        .font(.system(size: 20))
                        .foregroundColor(isSelected ? AppTheme.flipkartBlue : Color(red: 117/255, green: 117/255, blue: 117/255))
                        .frame(width: 28, height: 24)

                    if badgeCount > 0 {
                        Text("\(badgeCount)")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.white)
                            .padding(3)
                            .background(AppTheme.royalRed)
                            .clipShape(Circle())
                            .offset(x: 8, y: -4)
                    }
                }

                Text(title)
                    .font(.system(size: 10, weight: isSelected ? .bold : .regular))
                    .foregroundColor(isSelected ? AppTheme.flipkartBlue : Color(red: 117/255, green: 117/255, blue: 117/255))
            }
            .frame(minWidth: 48)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

