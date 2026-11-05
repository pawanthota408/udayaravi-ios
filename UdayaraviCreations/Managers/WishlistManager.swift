import Foundation
import SwiftUI

public class WishlistManager: ObservableObject {
    public static let shared = WishlistManager()

    @Published public var favorites: [SareeProduct] = [] {
        didSet {
            saveToStorage()
        }
    }

    private let storageKey = "udayaravi_wishlist_items_v1"

    public init() {
        loadFromStorage()
    }

    public func isFavorite(productId: String) -> Bool {
        return favorites.contains { $0.id == productId }
    }

    public func toggle(product: SareeProduct) {
        if let index = favorites.firstIndex(where: { $0.id == product.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(product)
        }
    }

    public func remove(productId: String) {
        favorites.removeAll { $0.id == productId }
    }

    private func saveToStorage() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    private func loadFromStorage() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([SareeProduct].self, from: data) {
            self.favorites = decoded
        }
    }
}

