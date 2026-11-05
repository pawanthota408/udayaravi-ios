import Foundation

// MARK: - Delivery Address Model
public struct DeliveryAddress: Identifiable, Codable, Hashable {
    public let id: String
    public var name: String
    public var phone: String
    public var addressLine: String
    public var city: String
    public var state: String
    public var pincode: String
    public var isDefault: Bool

    public init(
        id: String = UUID().uuidString,
        name: String,
        phone: String,
        addressLine: String,
        city: String,
        state: String,
        pincode: String,
        isDefault: Bool = false
    ) {
        self.id = id
        self.name = name
        self.phone = phone
        self.addressLine = addressLine
        self.city = city
        self.state = state
        self.pincode = pincode
        self.isDefault = isDefault
    }

    public var fullAddressString: String {
        return "\(addressLine), \(city), \(state) - \(pincode)"
    }

    public static let sampleAddresses: [DeliveryAddress] = [
        DeliveryAddress(
            id: "addr_1",
            name: "Honey Sharma",
            phone: "+91 98765 43210",
            addressLine: "Flat 402, Sunshine Heights, Hinjewadi Phase 1",
            city: "Pune",
            state: "Maharashtra",
            pincode: "411057",
            isDefault: true
        ),
        DeliveryAddress(
            id: "addr_2",
            name: "K. Balaji (Weaver)",
            phone: "+91 94432 10987",
            addressLine: "Plot 14, Weavers Industrial Estate, Ammapet",
            city: "Salem",
            state: "Tamil Nadu",
            pincode: "636003",
            isDefault: false
        )
    ]
}

// MARK: - User Profile Model
public struct UserProfile: Identifiable, Codable {
    public let id: String
    public var name: String
    public var email: String
    public var phone: String
    public var role: String
    public var companyName: String?
    public var gstNumber: String?
    public var token: String?

    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case name
        case email
        case phone
        case role
        case companyName = "company_name"
        case gstNumber = "gst_number"
        case token
    }

    public init(
        id: String = "usr_001",
        name: String = "Honey Sharma",
        email: String = "honey@udayaravicreations.com",
        phone: String = "919876543210",
        role: String = "Customer",
        companyName: String? = "Macro Weaving Mills",
        gstNumber: String? = "33AAAAA0000A1Z5",
        token: String? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.role = role
        self.companyName = companyName
        self.gstNumber = gstNumber
        self.token = token
    }
}

// MARK: - Auth API Responses
public struct LoginResponseData: Codable {
    public let success: Bool
    public let message: String?
    public let user: UserProfile?
    public let token: String?
}

