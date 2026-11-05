import SwiftUI

public struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var userManager: UserManager

    public let onProceedToCheckout: () -> Void
    public let onContinueShopping: () -> Void

    @State private var showAddressSheet: Bool = false

    public init(
        onProceedToCheckout: @escaping () -> Void,
        onContinueShopping: @escaping () -> Void
    ) {
        self.onProceedToCheckout = onProceedToCheckout
        self.onContinueShopping = onContinueShopping
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Top App Bar
            CustomNavigationBar(
                title: "My Cart (\(cartManager.totalItemCount))",
                showBackButton: false,
                onBack: nil,
                showCartButton: false
            )

            if cartManager.items.isEmpty {
                // Empty Cart State
                VStack(spacing: 16) {
                    Spacer()
                    Image(systemName: "cart.badge.minus")
                        .font(.system(size: 64))
                        .foregroundColor(Color.gray.opacity(0.35))

                    Text("Your Cart is empty!")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)

                    Text("Explore our traditional Silk Sarees, Electronic Jacquards, and weaving machinery.")
                        .font(.system(size: 13))
                        .foregroundColor(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Button(action: onContinueShopping) {
                        Text("Start Shopping")
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
                    VStack(spacing: 0) {
                        // 1. Delivery Address Bar
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 18))
                                .foregroundColor(AppTheme.flipkartBlue)

                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Text("Deliver to: ")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(AppTheme.textSecondary)
                                    Text(userManager.selectedAddress?.name ?? userManager.currentUser?.name ?? "Honey")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(AppTheme.textPrimary)
                                    Text(userManager.selectedAddress?.pincode ?? "411057")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(AppTheme.textPrimary)
                                }

                                Text(userManager.selectedAddress?.fullAddressString ?? "Hinjewadi Phase 1, Pune, Maharashtra - 411057")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppTheme.textSecondary)
                                    .lineLimit(1)
                            }

                            Spacer()

                            Button(action: { showAddressSheet = true }) {
                                Text("Change")
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
                        .padding(14)
                        .background(Color.white)

                        Rectangle()
                            .fill(AppTheme.pageBg)
                            .frame(height: 8)

                        // 2. Cart Items List
                        ForEach(cartManager.items) { item in
                            CartItemRow(item: item)
                            Divider()
                        }

                        Rectangle()
                            .fill(AppTheme.pageBg)
                            .frame(height: 8)

                        // 3. Price Breakdown Card
                        VStack(alignment: .leading, spacing: 12) {
                            Text("PRICE DETAILS")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(AppTheme.textSecondary)

                            Divider()

                            HStack {
                                Text("Price (\(cartManager.totalItemCount) items)")
                                    .font(.system(size: 13.5))
                                    .foregroundColor(AppTheme.textPrimary)
                                Spacer()
                                Text(cartManager.formattedSubtotal)
                                    .font(.system(size: 13.5))
                                    .foregroundColor(AppTheme.textPrimary)
                            }

                            HStack {
                                Text("Delivery Charges")
                                    .font(.system(size: 13.5))
                                    .foregroundColor(AppTheme.textPrimary)
                                Spacer()
                                if cartManager.deliveryFee == 0.0 {
                                    HStack(spacing: 4) {
                                        Text("₹99")
                                            .font(.system(size: 12))
                                            .foregroundColor(AppTheme.textSecondary)
                                            .strikethrough()
                                        Text("FREE")
                                            .font(.system(size: 13.5, weight: .bold))
                                            .foregroundColor(AppTheme.starGreen)
                                    }
                                } else {
                                    Text(cartManager.formattedDeliveryFee)
                                        .font(.system(size: 13.5))
                                        .foregroundColor(AppTheme.textPrimary)
                                }
                            }

                            HStack {
                                Text("Packaging & Inspection")
                                    .font(.system(size: 13.5))
                                    .foregroundColor(AppTheme.textPrimary)
                                Spacer()
                                Text("FREE")
                                    .font(.system(size: 13.5, weight: .bold))
                                    .foregroundColor(AppTheme.starGreen)
                            }

                            Divider()

                            HStack {
                                Text("Total Amount")
                                    .font(.system(size: 15.5, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary)
                                Spacer()
                                Text(cartManager.formattedTotalAmount)
                                    .font(.system(size: 16.5, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary)
                            }

                            HStack(spacing: 4) {
                                Image(systemName: "tag.fill")
                                    .font(.system(size: 11))
                                    .foregroundColor(AppTheme.starGreen)
                                Text("You will save extra ₹1,500 on this order with manufacturer direct pricing")
                                    .font(.system(size: 11.5, weight: .medium))
                                    .foregroundColor(AppTheme.starGreen)
                            }
                            .padding(.top, 2)
                        }
                        .padding(16)
                        .background(Color.white)

                        // 4. Safe & Secure Guarantee Row
                        HStack(spacing: 8) {
                            Image(systemName: "shield.checkerboard")
                                .font(.system(size: 18))
                                .foregroundColor(Color.gray)
                            Text("Safe and Secure Payments. 100% Authentic Handloom Guarantee.")
                                .font(.system(size: 11.5))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                        .padding(16)

                        Spacer().frame(height: 24)
                    }
                }
                .background(AppTheme.pageBg)

                // Sticky Bottom Bar
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(cartManager.formattedTotalAmount)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)
                        Text("View price details")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(AppTheme.flipkartBlue)
                    }

                    Spacer()

                    Button(action: onProceedToCheckout) {
                        Text("Place Order")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 14)
                            .background(AppTheme.flipkartBlue)
                            .cornerRadius(4)
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
        }
        .sheet(isPresented: $showAddressSheet) {
            AddressSelectionSheet(isPresented: $showAddressSheet)
        }
    }
}

// MARK: - Cart Item Row Component
struct CartItemRow: View {
    let item: CartItem
    @EnvironmentObject var cartManager: CartManager

    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top, spacing: 14) {
                // Thumbnail
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(AppTheme.border, lineWidth: 0.8)
                        .background(Color(red: 249/255, green: 249/255, blue: 249/255))

                    if let urlStr = item.imageUrl, let url = URL(string: urlStr) {
                        AsyncImage(url: url) { phase in
                            if let img = phase.image {
                                img.resizable().aspectRatio(contentMode: .fill)
                            } else {
                                Text(String(item.title.prefix(1)).uppercased())
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(AppTheme.flipkartBlue)
                            }
                        }
                    } else {
                        Text(String(item.title.prefix(1)).uppercased())
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppTheme.flipkartBlue)
                    }
                }
                .frame(width: 80, height: 80)
                .cornerRadius(4)
                .clipped()

                // Title & Details
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                        .lineLimit(2)

                    Text(item.subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textSecondary)

                    HStack(spacing: 6) {
                        Text(item.price.contains("₹") ? item.price : "₹\(item.price)")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)

                        if let orig = item.originalPrice {
                            Text("₹\(orig.replacingOccurrences(of: "₹", with: ""))")
                                .font(.system(size: 12))
                                .foregroundColor(AppTheme.textSecondary)
                                .strikethrough()
                        }
                    }
                }

                Spacer()
            }

            // Quantity Stepper and Remove
            HStack {
                // Quantity Steppers
                HStack(spacing: 12) {
                    Button(action: {
                        cartManager.updateQuantity(itemId: item.id, quantity: item.quantity - 1)
                    }) {
                        Image(systemName: item.quantity > 1 ? "minus" : "trash")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)
                            .frame(width: 28, height: 28)
                            .background(Color(red: 245/255, green: 245/255, blue: 245/255))
                            .clipShape(Circle())
                    }

                    Text("\(item.quantity)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)

                    Button(action: {
                        cartManager.updateQuantity(itemId: item.id, quantity: item.quantity + 1)
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)
                            .frame(width: 28, height: 28)
                            .background(Color(red: 245/255, green: 245/255, blue: 245/255))
                            .clipShape(Circle())
                    }
                }

                Spacer()

                Button(action: {
                    cartManager.removeFromCart(itemId: item.id)
                }) {
                    Text("Remove")
                        .font(.system(size: 12.5, weight: .bold))
                        .foregroundColor(Color.gray)
                }
            }
        }
        .padding(14)
        .background(Color.white)
    }
}

// MARK: - Address Selection Sheet Component
struct AddressSelectionSheet: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var userManager: UserManager

    @State private var showNewAddressForm: Bool = false
    @State private var newName: String = ""
    @State private var newPhone: String = ""
    @State private var newAddress: String = ""
    @State private var newCity: String = ""
    @State private var newState: String = ""
    @State private var newPincode: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if showNewAddressForm {
                    Form {
                        Section(header: Text("Contact Details")) {
                            TextField("Full Name", text: $newName)
                            TextField("Phone Number", text: $newPhone)
                        }

                        Section(header: Text("Address")) {
                            TextField("House / Building / Street", text: $newAddress)
                            TextField("City", text: $newCity)
                            TextField("State", text: $newState)
                            TextField("Pincode", text: $newPincode)
                        }

                        Button(action: {
                            guard !newName.isEmpty, !newAddress.isEmpty else { return }
                            let addr = DeliveryAddress(
                                name: newName,
                                phone: newPhone,
                                addressLine: newAddress,
                                city: newCity,
                                state: newState,
                                pincode: newPincode,
                                isDefault: true
                            )
                            userManager.addAddress(addr)
                            showNewAddressForm = false
                        }) {
                            Text("Save Address")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(AppTheme.flipkartBlue)
                                .cornerRadius(6)
                        }
                    }
                } else {
                    List {
                        ForEach(userManager.addresses) { addr in
                            HStack {
                                Image(systemName: userManager.selectedAddress?.id == addr.id ? "largecircle.fill.circle" : "circle")
                                    .foregroundColor(AppTheme.flipkartBlue)

                                VStack(alignment: .leading, spacing: 3) {
                                    HStack {
                                        Text(addr.name)
                                            .font(.system(size: 14, weight: .bold))
                                        if addr.isDefault {
                                            Text("DEFAULT")
                                                .font(.system(size: 9, weight: .bold))
                                                .padding(.horizontal, 4)
                                                .padding(.vertical, 2)
                                                .background(Color(red: 232/255, green: 240/255, blue: 254/255))
                                                .cornerRadius(3)
                                        }
                                    }
                                    Text(addr.fullAddressString)
                                        .font(.system(size: 12))
                                        .foregroundColor(AppTheme.textSecondary)
                                    Text("Phone: \(addr.phone)")
                                        .font(.system(size: 12))
                                }
                                .padding(.leading, 8)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                userManager.selectedAddress = addr
                                isPresented = false
                            }
                        }

                        Button(action: { showNewAddressForm = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(AppTheme.flipkartBlue)
                                Text("Add New Delivery Address")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(AppTheme.flipkartBlue)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
            }
            .navigationTitle("Select Address")
            .navigationBarItems(trailing: Button("Done") { isPresented = false })
        }
    }
}

