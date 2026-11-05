import Foundation

// MARK: - Cart Item Model
public struct CartItem: Identifiable, Codable, Hashable {
    public let id: String
    public let productId: String
    public let title: String
    public let subtitle: String
    public let price: String
    public let originalPrice: String?
    public var quantity: Int
    public let imageUrl: String?
    public let isMachine: Bool
    public let bmpFileUrl: String?
    public let variantId: String?
    public let variantColor: String?
    public let variantSize: String?

    public init(
        id: String = UUID().uuidString,
        productId: String,
        title: String,
        subtitle: String = "Pure Silk Saree",
        price: String,
        originalPrice: String? = nil,
        quantity: Int = 1,
        imageUrl: String? = nil,
        isMachine: Bool = false,
        bmpFileUrl: String? = nil,
        variantId: String? = nil,
        variantColor: String? = nil,
        variantSize: String? = nil
    ) {
        self.id = id
        self.productId = productId
        self.title = title
        self.subtitle = subtitle
        self.price = price
        self.originalPrice = originalPrice
        self.quantity = quantity
        self.imageUrl = imageUrl
        self.isMachine = isMachine
        self.bmpFileUrl = bmpFileUrl
        self.variantId = variantId
        self.variantColor = variantColor
        self.variantSize = variantSize
    }

    public var unitPriceValue: Double {
        let clean = price.replacingOccurrences(of: "₹", with: "")
                         .replacingOccurrences(of: ",", with: "")
                         .trimmingCharacters(in: .whitespacesAndNewlines)
        return Double(clean) ?? 0.0
    }

    public var totalPriceValue: Double {
        return unitPriceValue * Double(quantity)
    }

    public var formattedTotalPrice: String {
        let val = totalPriceValue
        if val.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "₹%.0f", val)
        } else {
            return String(format: "₹%.2f", val)
        }
    }
}

