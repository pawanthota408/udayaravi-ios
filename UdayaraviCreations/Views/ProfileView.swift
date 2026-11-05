import SwiftUI

public struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var wishlistManager: WishlistManager

    public let onNavigateToOrders: () -> Void
    public let onNavigateToWishlist: () -> Void
    public let onNavigateToAddresses: () -> Void
    public let onNavigateToSettings: () -> Void
    public let onLogout: () -> Void

    @State private var showEditProfileSheet: Bool = false
    @State private var editName: String = ""
    @State private var editPhone: String = ""
    @State private var editEmail: String = ""

    public init(
        onNavigateToOrders: @escaping () -> Void,
        onNavigateToWishlist: @escaping () -> Void,
        onNavigateToAddresses: @escaping () -> Void,
        onNavigateToSettings: @escaping () -> Void,
        onLogout: @escaping () -> Void
    ) {
        self.onNavigateToOrders = onNavigateToOrders
        self.onNavigateToWishlist = onNavigateToWishlist
        self.onNavigateToAddresses = onNavigateToAddresses
        self.onNavigateToSettings = onNavigateToSettings
        self.onLogout = onLogout
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Top Header Bar
            CustomNavigationBar(
                title: "My Account",
                showBackButton: false,
                onBack: nil,
                showCartButton: false
            )

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // 1. User Header Card
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(AppTheme.gold)
                                .frame(width: 58, height: 58)
                            Text(String(userManager.currentUser?.name.prefix(1) ?? "H").uppercased())
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 3) {
                            Text(userManager.currentUser?.name ?? "Honey Sharma")
                                .font(.system(size: 16.5, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)

                            Text(userManager.currentUser?.phone ?? "+91 98765 43210")
                                .font(.system(size: 13))
                                .foregroundColor(AppTheme.textSecondary)

                            Text(userManager.currentUser?.email ?? "honey@udayaravicreations.com")
                                .font(.system(size: 12))
                                .foregroundColor(AppTheme.textSecondary)
                        }

                        Spacer()

                        Button(action: {
                            editName = userManager.currentUser?.name ?? ""
                            editPhone = userManager.currentUser?.phone ?? ""
                            editEmail = userManager.currentUser?.email ?? ""
                            showEditProfileSheet = true
                        }) {
                            Text("Edit")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(AppTheme.flipkartBlue)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(AppTheme.flipkartBlue, lineWidth: 1)
                                )
                        }
                    }
                    .padding(16)
                    .background(Color.white)

                    Rectangle()
                        .fill(AppTheme.pageBg)
                        .frame(height: 8)

                    // 2. Main Menu Options
                    VStack(spacing: 0) {
                        ProfileMenuRow(icon: "cube.box.fill", title: "My Orders", subtitle: "Track orders, returns, and delivery status") {
                            onNavigateToOrders()
                        }
                        Divider()

                        ProfileMenuRow(icon: "heart.fill", title: "My Wishlist", subtitle: "\(wishlistManager.favorites.count) items saved for later") {
                            onNavigateToWishlist()
                        }
                        Divider()

                        ProfileMenuRow(icon: "mappin.and.ellipse", title: "Saved Addresses", subtitle: "\(userManager.addresses.count) delivery locations") {
                            onNavigateToAddresses()
                        }
                        Divider()

                        ProfileMenuRow(icon: "cart.fill", title: "My Cart", subtitle: "\(cartManager.totalItemCount) items waiting for checkout") {
                            // Can switch to cart
                        }
                    }
                    .background(Color.white)

                    Rectangle()
                        .fill(AppTheme.pageBg)
                        .frame(height: 8)

                    // 3. Loom & Machinery Services
                    VStack(alignment: .leading, spacing: 0) {
                        Text("INDUSTRIAL & WEAVER SERVICES")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(AppTheme.textSecondary)
                            .padding(.horizontal, 16)
                            .padding(.top, 14)
                            .padding(.bottom, 6)

                        ProfileMenuRow(icon: "wrench.and.screwdriver.fill", title: "Loom Service & Calibration", subtitle: "Request technician visit for electronic jacquard") {
                            if let url = URL(string: "tel://919876543210") {
                                UIApplication.shared.open(url)
                            }
                        }
                        Divider()

                        ProfileMenuRow(icon: "doc.text.fill", title: "Jacquard .BMP Downloads", subtitle: "Access your purchased electronic punch patterns") {
                            onNavigateToOrders()
                        }
                    }
                    .background(Color.white)

                    Rectangle()
                        .fill(AppTheme.pageBg)
                        .frame(height: 8)

                    // 4. Settings & Support
                    VStack(spacing: 0) {
                        ProfileMenuRow(icon: "gearshape.fill", title: "Settings & About", subtitle: "App preferences, ISO 9001 certifications") {
                            onNavigateToSettings()
                        }
                        Divider()

                        ProfileMenuRow(icon: "phone.fill", title: "Contact Weavers Helpline", subtitle: "+91 98765 43210 • Salem, Tamil Nadu") {
                            if let url = URL(string: "tel://919876543210") {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                    .background(Color.white)

                    Rectangle()
                        .fill(AppTheme.pageBg)
                        .frame(height: 12)

                    // 5. Logout Button
                    Button(action: onLogout) {
                        HStack {
                            Image(systemName: "power")
                                .font(.system(size: 15, weight: .bold))
                            Text("Logout from UdayaRavi")
                                .font(.system(size: 14.5, weight: .bold))
                        }
                        .foregroundColor(AppTheme.royalRed)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.white)
                    }

                    Spacer().frame(height: 32)
                }
            }
            .background(AppTheme.pageBg)
        }
        .sheet(isPresented: $showEditProfileSheet) {
            NavigationView {
                Form {
                    Section(header: Text("Personal Info")) {
                        TextField("Name", text: $editName)
                        TextField("Phone", text: $editPhone)
                        TextField("Email", text: $editEmail)
                    }

                    Button(action: {
                        if var user = userManager.currentUser {
                            user.name = editName
                            user.phone = editPhone
                            user.email = editEmail
                            userManager.login(user: user)
                        }
                        showEditProfileSheet = false
                    }) {
                        Text("Save Changes")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(AppTheme.flipkartBlue)
                            .cornerRadius(6)
                    }
                }
                .navigationTitle("Edit Profile")
                .navigationBarItems(trailing: Button("Cancel") { showEditProfileSheet = false })
            }
        }
    }
}

// MARK: - Profile Menu Row Component
struct ProfileMenuRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 17))
                    .foregroundColor(AppTheme.flipkartBlue)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    Text(subtitle)
                        .font(.system(size: 11.5))
                        .foregroundColor(AppTheme.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color.gray.opacity(0.6))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

