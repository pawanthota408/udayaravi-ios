import SwiftUI

public struct AddressesView: View {
    @EnvironmentObject var userManager: UserManager
    public let onBack: () -> Void

    @State private var showAddAddressSheet: Bool = false
    @State private var newName: String = ""
    @State private var newPhone: String = ""
    @State private var newAddressLine: String = ""
    @State private var newCity: String = ""
    @State private var newState: String = ""
    @State private var newPincode: String = ""

    public init(onBack: @escaping () -> Void) {
        self.onBack = onBack
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Header
            CustomNavigationBar(
                title: "My Addresses",
                showBackButton: true,
                onBack: onBack,
                showCartButton: false
            )

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    // Add Address Button
                    Button(action: { showAddAddressSheet = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 18))
                                .foregroundColor(AppTheme.flipkartBlue)
                            Text("Add a new delivery address")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(AppTheme.flipkartBlue)
                            Spacer()
                        }
                        .padding(14)
                        .background(Color.white)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(AppTheme.border, lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                    // Address Cards
                    ForEach(userManager.addresses) { addr in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(addr.name)
                                    .font(.system(size: 14.5, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary)

                                if addr.isDefault {
                                    Text("DEFAULT")
                                        .font(.system(size: 9.5, weight: .bold))
                                        .foregroundColor(AppTheme.flipkartBlue)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color(red: 232/255, green: 240/255, blue: 254/255))
                                        .cornerRadius(3)
                                }

                                Spacer()

                                Button(action: {
                                    userManager.removeAddress(id: addr.id)
                                }) {
                                    Image(systemName: "trash")
                                        .font(.system(size: 14))
                                        .foregroundColor(Color.gray)
                                }
                            }

                            Text(addr.fullAddressString)
                                .font(.system(size: 13))
                                .foregroundColor(Color(red: 66/255, green: 66/255, blue: 66/255))

                            Text("Phone: \(addr.phone)")
                                .font(.system(size: 12.5, weight: .medium))
                                .foregroundColor(AppTheme.textPrimary)

                            if !addr.isDefault {
                                Button(action: {
                                    userManager.setDefaultAddress(id: addr.id)
                                }) {
                                    Text("Set as Default Delivery Address")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(AppTheme.flipkartBlue)
                                        .padding(.top, 4)
                                }
                            }
                        }
                        .padding(14)
                        .background(Color.white)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(addr.isDefault ? AppTheme.flipkartBlue : AppTheme.border, lineWidth: addr.isDefault ? 1.5 : 0.8)
                        )
                        .padding(.horizontal, 16)
                    }

                    Spacer().frame(height: 24)
                }
            }
            .background(AppTheme.pageBg)
        }
        .sheet(isPresented: $showAddAddressSheet) {
            NavigationView {
                Form {
                    Section(header: Text("Recipient Details")) {
                        TextField("Full Name", text: $newName)
                        TextField("10-Digit Mobile Number", text: $newPhone)
                            .keyboardType(.phonePad)
                    }

                    Section(header: Text("Address Details")) {
                        TextField("House / Flat / Street / Area", text: $newAddressLine)
                        TextField("City / Town", text: $newCity)
                        TextField("State", text: $newState)
                        TextField("6-Digit Pincode", text: $newPincode)
                            .keyboardType(.numberPad)
                    }

                    Button(action: {
                        guard !newName.isEmpty, !newAddressLine.isEmpty else { return }
                        let newAddr = DeliveryAddress(
                            name: newName,
                            phone: newPhone,
                            addressLine: newAddressLine,
                            city: newCity,
                            state: newState,
                            pincode: newPincode,
                            isDefault: userManager.addresses.isEmpty
                        )
                        userManager.addAddress(newAddr)
                        newName = ""
                        newPhone = ""
                        newAddressLine = ""
                        newCity = ""
                        newState = ""
                        newPincode = ""
                        showAddAddressSheet = false
                    }) {
                        Text("Save Delivery Address")
                            .font(.system(size: 14.5, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(AppTheme.flipkartBlue)
                            .cornerRadius(6)
                    }
                }
                .navigationTitle("Add New Address")
                .navigationBarItems(trailing: Button("Cancel") { showAddAddressSheet = false })
            }
        }
    }
}

