import Foundation
import SwiftUI

// MARK: - Order Item Model
public struct OrderItem: Identifiable, Codable {
    public let id: String
    public let productId: String?
    public let title: String
    public let subtitle: String
    public let unitPrice: Double
    public let quantity: Int
    public let imageUrl: String?
    public let isMachine: Bool
    public let bmpFileUrl: String?

    enum CodingKeys: String, CodingKey {
        case id = "item_id"
        case productId = "product_id"
        case title = "product_title"
        case subtitle = "variety"
        case unitPrice = "unit_price"
        case quantity
        case imageUrl = "featured_image_url"
        case isMachine = "is_machine"
        case bmpFileUrl = "bmp_file_url"
    }

    public init(
        id: String = UUID().uuidString,
        productId: String? = nil,
        title: String,
        subtitle: String = "Pure Silk Saree",
        unitPrice: Double,
        quantity: Int = 1,
        imageUrl: String? = nil,
        isMachine: Bool = false,
        bmpFileUrl: String? = nil
    ) {
        self.id = id
        self.productId = productId
        self.title = title
        self.subtitle = subtitle
        self.unitPrice = unitPrice
        self.quantity = quantity
        self.imageUrl = imageUrl
        self.isMachine = isMachine
        self.bmpFileUrl = bmpFileUrl
    }
}

// MARK: - Order Model
public struct OrderModel: Identifiable, Codable {
    public let id: String
    public let title: String
    public let date: String
    public let amount: String
    public let status: String
    public let imageUrl: String?
    public let isMachine: Bool
    public let paymentMethod: String
    public let paymentStatus: String
    public let shippingAddress: String
    public let customerName: String
    public let customerPhone: String
    public let city: String
    public let sellerName: String
    public let bmpFileUrl: String?
    public let items: [OrderItem]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case date = "created_at"
        case amount = "total_amount"
        case status = "order_status"
        case imageUrl = "image_url"
        case isMachine = "is_machine"
        case paymentMethod = "payment_method"
        case paymentStatus = "payment_status"
        case shippingAddress = "shipping_address"
        case customerName = "customer_name"
        case customerPhone = "customer_phone"
        case city
        case sellerName = "seller_name"
        case bmpFileUrl = "bmp_file_url"
        case items
    }

    public init(
        id: String,
        title: String,
        date: String = "Sun, 5th Feb '23",
        amount: String,
        status: String = "Completed",
        imageUrl: String? = nil,
        isMachine: Bool = false,
        paymentMethod: String = "Razorpay Online",
        paymentStatus: String = "Paid",
        shippingAddress: String = "Hinjewadi phase 1,",
        customerName: String = "Honey",
        customerPhone: String = "91XXXXXXXX",
        city: String = "Ville parle, Mumbai",
        sellerName: String = "Macro Delhi",
        bmpFileUrl: String? = nil,
        items: [OrderItem] = []
    ) {
        self.id = id
        self.title = title
        self.date = date
        self.amount = amount
        self.status = status
        self.imageUrl = imageUrl
        self.isMachine = isMachine
        self.paymentMethod = paymentMethod
        self.paymentStatus = paymentStatus
        self.shippingAddress = shippingAddress
        self.customerName = customerName
        self.customerPhone = customerPhone
        self.city = city
        self.sellerName = sellerName
        self.bmpFileUrl = bmpFileUrl
        self.items = items
    }

    // MARK: - 4-Stage Lifecycle Flow Properties
    // Order Received -> Scheduled Visit -> Installation -> Completed
    public var isStep1Done: Bool {
        return true // Order Received is complete
    }

    public var isStep2Done: Bool {
        let s = status.lowercased()
        return s.contains("visit") || s.contains("install") || s.contains("complete") || s.contains("deliver")
    }

    public var isStep3Done: Bool {
        let s = status.lowercased()
        return s.contains("install") || s.contains("complete") || s.contains("deliver")
    }

    public var isStep4Done: Bool {
        let s = status.lowercased()
        return s.contains("complete") || s.contains("deliver")
    }

    public var currentStageIndex: Int {
        if isStep4Done { return 4 }
        if isStep3Done { return 3 }
        if isStep2Done { return 2 }
        return 1
    }

    public var statusLocationLine: String {
        let s = status.lowercased()
        if s.contains("refund") { return "Refund Completed" }
        if s.contains("cancel") { return "Cancelled on \(date)" }
        if isStep4Done { return "Delivered to : \(city)" }
        if isStep3Done { return "Installation at : \(city)" }
        if isStep2Done { return "Scheduled to : \(city)" }
        return "Order Received : \(city)"
    }

    public var dateSubtitle: String {
        let s = status.lowercased()
        if s.contains("refund") || s.contains("cancel") { return "" }
        if isStep4Done { return "Delivered on \(date)" }
        if isStep3Done { return "Installation in progress" }
        if isStep2Done { return "Visit scheduled for \(date)" }
        return "Placed on \(date)"
    }
}

// MARK: - API Response Wrapper
public struct OrderResponse: Codable {
    public let success: Bool
    public let data: [OrderModel]?
}

// MARK: - Create Order Request Models (Directly mapped to orders.php)
public struct CreateOrderItemRequest: Codable {
    public let productId: String?
    public let productTitle: String
    public let variety: String
    public let unitPrice: Double
    public let quantity: Int
    public let featuredImageUrl: String?
    public let isMachine: Bool

    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case productTitle = "product_title"
        case variety
        case unitPrice = "unit_price"
        case quantity
        case featuredImageUrl = "featured_image_url"
        case isMachine = "is_machine"
    }

    public init(
        productId: String?,
        productTitle: String,
        variety: String = "Pure Silk Saree",
        unitPrice: Double,
        quantity: Int = 1,
        featuredImageUrl: String? = nil,
        isMachine: Bool = false
    ) {
        self.productId = productId
        self.productTitle = productTitle
        self.variety = variety
        self.unitPrice = unitPrice
        self.quantity = quantity
        self.featuredImageUrl = featuredImageUrl
        self.isMachine = isMachine
    }
}

public struct CreateOrderRequest: Codable {
    public let userId: String
    public let customerName: String?
    public let customerPhone: String?
    public let customerEmail: String?
    public let companyName: String?
    public let gstNumber: String?
    public let shippingAddress: String
    public let totalAmount: Double
    public let shippingFee: Double
    public let orderStatus: String
    public let paymentStatus: String
    public let paymentMethod: String
    public let transactionId: String?
    public let items: [CreateOrderItemRequest]
    public let bmpFileUrl: String?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case customerName = "customer_name"
        case customerPhone = "customer_phone"
        case customerEmail = "customer_email"
        case companyName = "company_name"
        case gstNumber = "gst_number"
        case shippingAddress = "shipping_address"
        case totalAmount = "total_amount"
        case shippingFee = "shipping_fee"
        case orderStatus = "order_status"
        case paymentStatus = "payment_status"
        case paymentMethod = "payment_method"
        case transactionId = "transaction_id"
        case items
        case bmpFileUrl = "bmp_file_url"
    }

    public init(
        userId: String,
        customerName: String?,
        customerPhone: String?,
        customerEmail: String? = nil,
        companyName: String? = nil,
        gstNumber: String? = nil,
        shippingAddress: String,
        totalAmount: Double,
        shippingFee: Double = 0.0,
        orderStatus: String = "Order Received",
        paymentStatus: String = "Paid",
        paymentMethod: String = "Cash On Delivery",
        transactionId: String? = nil,
        items: [CreateOrderItemRequest],
        bmpFileUrl: String? = nil
    ) {
        self.userId = userId
        self.customerName = customerName
        self.customerPhone = customerPhone
        self.customerEmail = customerEmail
        self.companyName = companyName
        self.gstNumber = gstNumber
        self.shippingAddress = shippingAddress
        self.totalAmount = totalAmount
        self.shippingFee = shippingFee
        self.orderStatus = orderStatus
        self.paymentStatus = paymentStatus
        self.paymentMethod = paymentMethod
        self.transactionId = transactionId
        self.items = items
        self.bmpFileUrl = bmpFileUrl
    }
}

public struct CreateOrderResponse: Codable {
    public let success: Bool
    public let message: String?
    public let orderId: String?

    enum CodingKeys: String, CodingKey {
        case success
        case message
        case orderId = "order_id"
    }
}
