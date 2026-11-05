import Foundation
import SwiftUI

public class UserManager: ObservableObject {
    public static let shared = UserManager()

    @Published public var currentUser: UserProfile? = nil {
        didSet { saveUser() }
    }

    @Published public var isLoggedIn: Bool = true {
        didSet { UserDefaults.standard.set(isLoggedIn, forKey: "is_logged_in") }
    }

    @Published public var addresses: [DeliveryAddress] = [] {
        didSet { saveAddresses() }
    }

    @Published public var selectedAddress: DeliveryAddress? = nil

    private let userKey = "udayaravi_user_profile"
    private let addressesKey = "udayaravi_user_addresses"

    public init() {
        loadData()
    }

    public func login(user: UserProfile) {
        self.currentUser = user
        self.isLoggedIn = true
    }

    public func logout() {
        self.currentUser = nil
        self.isLoggedIn = false
    }

    public func addAddress(_ address: DeliveryAddress) {
        var newAddr = address
        if addresses.isEmpty {
            newAddr.isDefault = true
        }
        if newAddr.isDefault {
            for i in 0..<addresses.count {
                addresses[i].isDefault = false
            }
        }
        addresses.append(newAddr)
        if selectedAddress == nil || newAddr.isDefault {
            selectedAddress = newAddr
        }
    }

    public func removeAddress(id: String) {
        addresses.removeAll { $0.id == id }
        if selectedAddress?.id == id {
            selectedAddress = addresses.first(where: { $0.isDefault }) ?? addresses.first
        }
    }

    public func setDefaultAddress(id: String) {
        for i in 0..<addresses.count {
            addresses[i].isDefault = (addresses[i].id == id)
        }
        selectedAddress = addresses.first { $0.id == id }
    }

    private func saveUser() {
        if let user = currentUser, let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userKey)
        } else {
            UserDefaults.standard.removeObject(forKey: userKey)
        }
    }

    private func saveAddresses() {
        if let data = try? JSONEncoder().encode(addresses) {
            UserDefaults.standard.set(data, forKey: addressesKey)
        }
    }

    private func loadData() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "is_logged_in")
        
        if let userData = UserDefaults.standard.data(forKey: userKey),
           let user = try? JSONDecoder().decode(UserProfile.self, data: userData) {
            self.currentUser = user
        } else {
            // Default demo account
            self.currentUser = UserProfile(
                id: "usr_001",
                name: "Honey Sharma",
                email: "honey@udayaravicreations.com",
                phone: "919876543210",
                role: "Customer",
                companyName: "Macro Weaving Mills",
                gstNumber: "33AAAAA0000A1Z5"
            )
            self.isLoggedIn = true
        }

        if let addrData = UserDefaults.standard.data(forKey: addressesKey),
           let list = try? JSONDecoder().decode([DeliveryAddress].self, data: addrData),
           !list.isEmpty {
            self.addresses = list
        } else {
            self.addresses = DeliveryAddress.sampleAddresses
        }

        self.selectedAddress = self.addresses.first(where: { $0.isDefault }) ?? self.addresses.first
    }
}

