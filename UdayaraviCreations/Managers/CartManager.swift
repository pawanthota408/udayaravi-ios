import Foundation
import SwiftUI

public class CartManager: ObservableObject {
    public static let shared = CartManager()

    @Published public var items: [CartItem] = [] {
        didSet {
            saveToStorage()
        }
    }

    private let storageKey = "udayaravi_cart_items_v1"

    public init() {
        loadFromStorage()
    }

    // MARK: - Core Operations
    public func addToCart(product: SareeProduct, quantity: Int = 1, variant: ProductVariant? = nil) {
        let cartKey = variant != nil ? "\(product.id)_\(variant!.id)" : product.id

        if let index = items.firstIndex(where: { $0.id == cartKey }) {
            items[index].quantity += quantity
        } else {
            let subtitle: String
            if product.isMachine {
                subtitle = "Weaving Machine • \(product.machineModel ?? product.sareeType)"
            } else if let v = variant, !v.color.isEmpty {
                subtitle = "\(v.color) • \(v.size.isEmpty ? product.sareeType : v.size)"
            } else {
                subtitle = "\(product.category) • \(product.sareeType)"
            }

            let priceToUse = variant?.price.isEmpty == false ? variant!.price : product.price
            let originalPriceToUse = variant?.originalPrice ?? product.originalPrice

            let newItem = CartItem(
                id: cartKey,
                productId: product.id,
                title: product.title,
                subtitle: subtitle,
                price: priceToUse,
                originalPrice: originalPriceToUse,
                quantity: quantity,
                imageUrl: variant?.imageUrl ?? product.imageUrl,
                isMachine: product.isMachine,
                bmpFileUrl: product.bmpFileUrl,
                variantId: variant?.id,
                variantColor: variant?.color,
                variantSize: variant?.size
            )
            items.append(newItem)
        }
    }

    public func updateQuantity(itemId: String, quantity: Int) {
        if let index = items.firstIndex(where: { $0.id == itemId }) {
            if quantity <= 0 {
                items.remove(at: index)
            } else {
                items[index].quantity = quantity
            }
        }
    }

    public func removeFromCart(itemId: String) {
        items.removeAll { $0.id == itemId }
    }

    public func clearCart() {
        items.removeAll()
    }

    // MARK: - Calculations
    public var totalItemCount: Int {
        return items.reduce(0) { $0 + $1.quantity }
    }

    public var subtotal: Double {
        return items.reduce(0.0) { $0 + $1.totalPriceValue }
    }

    public var deliveryFee: Double {
        if items.isEmpty || subtotal >= 999.0 {
            return 0.0
        }
        return 99.0
    }

    public var totalAmount: Double {
        return subtotal + deliveryFee
    }

    public var formattedSubtotal: String {
        return formatCurrency(subtotal)
    }

    public var formattedDeliveryFee: String {
        return deliveryFee == 0.0 ? "FREE" : formatCurrency(deliveryFee)
    }

    public var formattedTotalAmount: String {
        return formatCurrency(totalAmount)
    }

    private func formatCurrency(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "₹%.0f", value)
        } else {
            return String(format: "₹%.2f", value)
        }
    }

    // MARK: - Persistence
    private func saveToStorage() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    private func loadFromStorage() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([CartItem].self, from: data) {
            self.items = decoded
        } else {
            // Default sample items to showcase luxury cart functionality
            self.items = [
                CartItem(
                    id: "cart_01",
                    productId: "prod_001",
                    title: "Colo Women Black Heels",
                    subtitle: "Size: 4 • Color: Black",
                    price: "488",
                    originalPrice: "1,299",
                    quantity: 1,
                    imageUrl: "https://crm.friendssoftwaresolutions.in/api/uday/uploads/heels.jpg",
                    isMachine: false
                ),
                CartItem(
                    id: "cart_02",
                    productId: "prod_005",
                    title: "Heavy Electronic Jacquard Machine 2688",
                    subtitle: "Weaving Machine • Model 2026",
                    price: "2,85,000",
                    originalPrice: "3,20,000",
                    quantity: 1,
                    imageUrl: "https://crm.friendssoftwaresolutions.in/api/uday/uploads/machine.jpg",
                    isMachine: true,
                    bmpFileUrl: "https://crm.friendssoftwaresolutions.in/api/uday/uploads/design_sample.bmp"
                )
            ]
        }
    }
}

