import Foundation

// MARK: - Product Variant
public struct ProductVariant: Identifiable, Codable, Hashable {
    public let id: String
    public let color: String
    public let size: String
    public let price: String
    public let originalPrice: String?
    public let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case color
        case size
        case price
        case originalPrice = "original_price"
        case imageUrl = "image_url"
    }

    public init(
        id: String = UUID().uuidString,
        color: String = "",
        size: String = "",
        price: String = "",
        originalPrice: String? = nil,
        imageUrl: String? = nil
    ) {
        self.id = id
        self.color = color
        self.size = size
        self.price = price
        self.originalPrice = originalPrice
        self.imageUrl = imageUrl
    }
}

// MARK: - Category Item
public struct CategoryItem: Identifiable, Codable, Hashable {
    public let id: String
    public let name: String
    public let isMachine: Bool
    public let imageUrl: String?
    public let division: String?
    public let department: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isMachine = "is_machine"
        case imageUrl = "image_url"
        case division
        case department
    }

    public init(
        id: String,
        name: String,
        isMachine: Bool = false,
        imageUrl: String? = nil,
        division: String? = nil,
        department: String? = nil
    ) {
        self.id = id
        self.name = name
        self.isMachine = isMachine
        self.imageUrl = imageUrl
        self.division = division
        self.department = department
    }
}

// MARK: - Saree / Loom / Design Product
public struct SareeProduct: Identifiable, Codable, Hashable {
    public let id: String
    public let title: String
    public let category: String
    public let sareeType: String
    public let price: String
    public let originalPrice: String?
    public let discount: String?
    public let description: String?
    public let imageUrl: String?
    public let imageList: [String]
    public let isMachine: Bool
    public let bmpFileUrl: String?
    public let machineModel: String?
    public let weavingSpeed: String?
    public let warrantyPeriod: String?
    public let powerRating: String?
    public let sareeOrDesign: String?
    public let department: String?
    public let division: String?
    public let variants: [ProductVariant]
    public let variantId: String?
    public let variantColor: String?
    public let variantSize: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case category = "category_name"
        case sareeType = "variety"
        case price
        case originalPrice = "original_price"
        case discount = "discount_percentage"
        case description
        case imageUrl = "featured_image_url"
        case imageList = "image_list"
        case isMachine = "is_machine"
        case bmpFileUrl = "bmp_file_url"
        case machineModel = "machine_model"
        case weavingSpeed = "weaving_speed"
        case warrantyPeriod = "warranty_period"
        case powerRating = "power_rating"
        case sareeOrDesign = "saree_or_design"
        case department
        case division
        case variants
        case variantId = "variant_id"
        case variantColor = "variant_color"
        case variantSize = "variant_size"
    }

    public init(
        id: String,
        title: String,
        category: String = "Sarees",
        sareeType: String = "Pure Silk",
        price: String,
        originalPrice: String? = nil,
        discount: String? = nil,
        description: String? = nil,
        imageUrl: String? = nil,
        imageList: [String] = [],
        isMachine: Bool = false,
        bmpFileUrl: String? = nil,
        machineModel: String? = nil,
        weavingSpeed: String? = nil,
        warrantyPeriod: String? = nil,
        powerRating: String? = nil,
        sareeOrDesign: String? = nil,
        department: String? = nil,
        division: String? = nil,
        variants: [ProductVariant] = [],
        variantId: String? = nil,
        variantColor: String? = nil,
        variantSize: String? = nil
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.sareeType = sareeType
        self.price = price
        self.originalPrice = originalPrice
        self.discount = discount
        self.description = description
        self.imageUrl = imageUrl
        self.imageList = imageList
        self.isMachine = isMachine
        self.bmpFileUrl = bmpFileUrl
        self.machineModel = machineModel
        self.weavingSpeed = weavingSpeed
        self.warrantyPeriod = warrantyPeriod
        self.powerRating = powerRating
        self.sareeOrDesign = sareeOrDesign
        self.department = department
        self.division = division
        self.variants = variants
        self.variantId = variantId
        self.variantColor = variantColor
        self.variantSize = variantSize
    }

    public var numericPrice: Double {
        let clean = price.replacingOccurrences(of: "₹", with: "")
                         .replacingOccurrences(of: ",", with: "")
                         .trimmingCharacters(in: .whitespacesAndNewlines)
        return Double(clean) ?? 0.0
    }

    public var formattedPrice: String {
        return "₹\(price.replacingOccurrences(of: "₹", with: "").trimmingCharacters(in: .whitespacesAndNewlines))"
    }
}

// MARK: - Home Banner
public struct HomeBanner: Identifiable, Codable, Hashable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let imageUrl: String
    public let targetUrl: String?
    public let buttonText: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case imageUrl = "image_url"
        case targetUrl = "target_url"
        case buttonText = "button_text"
    }

    public init(
        id: String,
        title: String,
        subtitle: String,
        imageUrl: String,
        targetUrl: String? = nil,
        buttonText: String? = "Explore"
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
        self.targetUrl = targetUrl
        self.buttonText = buttonText
    }
}

// MARK: - Home Metrics
public struct HomeMetrics: Codable {
    public let yearsLegacy: String
    public let loomsShipped: String
    public let masterPatterns: String
    public let isoCertification: String

    public init(
        yearsLegacy: String = "50+",
        loomsShipped: String = "10k+",
        masterPatterns: String = "5k+",
        isoCertification: String = "ISO 9001:2015 CERTIFIED MANUFACTURER"
    ) {
        self.yearsLegacy = yearsLegacy
        self.loomsShipped = loomsShipped
        self.masterPatterns = masterPatterns
        self.isoCertification = isoCertification
    }
}

// MARK: - Main Home Screen Aggregate Data
public struct MainHomeData {
    public var banners: [HomeBanner]
    public var metrics: HomeMetrics
    public var featuredSarees: [SareeProduct]
    public var featuredMachines: [SareeProduct]
    public var featuredDesigns: [SareeProduct]

    public init(
        banners: [HomeBanner] = [],
        metrics: HomeMetrics = HomeMetrics(),
        featuredSarees: [SareeProduct] = [],
        featuredMachines: [SareeProduct] = [],
        featuredDesigns: [SareeProduct] = []
    ) {
        self.banners = banners
        self.metrics = metrics
        self.featuredSarees = featuredSarees
        self.featuredMachines = featuredMachines
        self.featuredDesigns = featuredDesigns
    }
}

// MARK: - API Response Wrappers
public struct ProductResponse: Codable {
    public let success: Bool
    public let message: String?
    public let data: [SareeProduct]?
}

public struct CategoryResponse: Codable {
    public let success: Bool
    public let message: String?
    public let data: [CategoryItem]?
}

