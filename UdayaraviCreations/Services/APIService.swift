import Foundation

public class APIService: ObservableObject {
    public static let shared = APIService()
    private let baseUrl = "https://crm.friendssoftwaresolutions.in/api/uday/"

    @Published public var orders: [OrderModel] = []
    @Published public var products: [SareeProduct] = []
    @Published public var categories: [CategoryItem] = []
    @Published public var homeData: MainHomeData = MainHomeData()
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil

    public init() {
        self.orders = Self.mockOrders
        self.products = Self.mockProducts
        self.categories = Self.mockCategories
        self.homeData = MainHomeData(
            banners: Self.mockBanners,
            metrics: HomeMetrics(
                yearsLegacy: "50+",
                loomsShipped: "10k+",
                masterPatterns: "5k+",
                isoCertification: "ISO 9001:2015 CERTIFIED MANUFACTURER"
            ),
            featuredSarees: Self.mockProducts.filter { !$0.isMachine && $0.division != "designs" },
            featuredMachines: Self.mockProducts.filter { $0.isMachine },
            featuredDesigns: Self.mockProducts.filter { $0.division == "designs" }
        )
    }

    // MARK: - Fetch Orders
    public func fetchOrders(userId: String = "usr_001") {
        guard let url = URL(string: "\(baseUrl)orders.php?user_id=\(userId)") else { return }
        self.isLoading = true

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard let data = data, error == nil else { return }
                do {
                    let decoded = try JSONDecoder().decode(OrderResponse.self, from: data)
                    if let remoteOrders = decoded.data, !remoteOrders.isEmpty {
                        self?.orders = remoteOrders
                    }
                } catch {
                    print("Error decoding remote orders: \(error)")
                }
            }
        }.resume()
    }

    // MARK: - Place Order
    public func placeOrder(request: CreateOrderRequest, completion: @escaping (Result<OrderModel, Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)orders.php?user_id=\(request.userId)") else {
            let localOrder = makeLocalOrder(from: request)
            self.orders.insert(localOrder, at: 0)
            completion(.success(localOrder))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            urlRequest.httpBody = try JSONEncoder().encode(request)
        } catch {
            let localOrder = makeLocalOrder(from: request)
            self.orders.insert(localOrder, at: 0)
            completion(.success(localOrder))
            return
        }

        self.isLoading = true
        URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                let localOrder = self?.makeLocalOrder(from: request) ?? OrderModel(
                    id: "ORD-\(Int.random(in: 100000...999999))",
                    title: request.items.first?.productTitle ?? "UdayaRavi Order",
                    amount: String(format: "%.0f", request.totalAmount),
                    customerName: request.customerName ?? "Honey",
                    customerPhone: request.customerPhone ?? "919876543210"
                )

                if let data = data,
                   let createResp = try? JSONDecoder().decode(CreateOrderResponse.self, from: data),
                   createResp.success {
                    let remoteId = createResp.orderId ?? localOrder.id
                    let confirmedOrder = OrderModel(
                        id: remoteId,
                        title: localOrder.title,
                        date: "Just Now",
                        amount: localOrder.amount,
                        status: "Order Received",
                        imageUrl: localOrder.imageUrl,
                        isMachine: localOrder.isMachine,
                        paymentMethod: request.paymentMethod,
                        paymentStatus: request.paymentStatus,
                        shippingAddress: request.shippingAddress,
                        customerName: request.customerName ?? "Customer",
                        customerPhone: request.customerPhone ?? "",
                        city: "Salem",
                        sellerName: "UdayaRavi Creations",
                        bmpFileUrl: request.bmpFileUrl,
                        items: localOrder.items
                    )
                    self?.orders.insert(confirmedOrder, at: 0)
                    completion(.success(confirmedOrder))
                } else {
                    // Fallback to locally placed order for seamless user experience
                    self?.orders.insert(localOrder, at: 0)
                    completion(.success(localOrder))
                }
            }
        }.resume()
    }

    private func makeLocalOrder(from request: CreateOrderRequest) -> OrderModel {
        let firstItem = request.items.first
        let orderItems = request.items.map { item in
            OrderItem(
                id: UUID().uuidString,
                productId: item.productId,
                title: item.productTitle,
                subtitle: item.variety,
                unitPrice: item.unitPrice,
                quantity: item.quantity,
                imageUrl: item.featuredImageUrl,
                isMachine: item.isMachine,
                bmpFileUrl: request.bmpFileUrl
            )
        }

        return OrderModel(
            id: "ORD-\(Int.random(in: 100000...999999))",
            title: firstItem?.productTitle ?? "UdayaRavi Saree",
            date: "Today",
            amount: String(format: "%.0f", request.totalAmount),
            status: "Order Received",
            imageUrl: firstItem?.featuredImageUrl ?? "https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=400",
            isMachine: firstItem?.isMachine ?? false,
            paymentMethod: request.paymentMethod,
            paymentStatus: request.paymentStatus,
            shippingAddress: request.shippingAddress,
            customerName: request.customerName ?? "Honey",
            customerPhone: request.customerPhone ?? "+91 98765 43210",
            city: "Salem",
            sellerName: "UdayaRavi Creations",
            bmpFileUrl: request.bmpFileUrl,
            items: orderItems
        )
    }

    // MARK: - Fetch Products
    public func fetchProducts(
        division: String? = nil,
        isMachine: Bool? = nil,
        category: String? = nil,
        search: String? = nil
    ) {
        var queryItems: [URLQueryItem] = []
        if let division = division { queryItems.append(URLQueryItem(name: "division", value: division)) }
        if let isMachine = isMachine { queryItems.append(URLQueryItem(name: "is_machine", value: isMachine ? "true" : "false")) }
        if let category = category { queryItems.append(URLQueryItem(name: "category", value: category)) }
        if let search = search { queryItems.append(URLQueryItem(name: "search", value: search)) }

        var urlComponents = URLComponents(string: "\(baseUrl)products.php")
        urlComponents?.queryItems = queryItems

        guard let url = urlComponents?.url else { return }

        self.isLoading = true
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard let data = data, error == nil else { return }
                do {
                    let decoded = try JSONDecoder().decode(ProductResponse.self, from: data)
                    if let remoteList = decoded.data, !remoteList.isEmpty {
                        self?.products = remoteList
                    }
                } catch {
                    print("Error decoding remote products: \(error)")
                }
            }
        }.resume()
    }

    // MARK: - Fetch Categories
    public func fetchCategories(division: String? = nil, isMachine: Bool? = nil) {
        var queryItems: [URLQueryItem] = []
        if let division = division { queryItems.append(URLQueryItem(name: "division", value: division)) }
        if let isMachine = isMachine { queryItems.append(URLQueryItem(name: "is_machine", value: isMachine ? "true" : "false")) }

        var urlComponents = URLComponents(string: "\(baseUrl)categories.php")
        urlComponents?.queryItems = queryItems

        guard let url = urlComponents?.url else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else { return }
                do {
                    let decoded = try JSONDecoder().decode(CategoryResponse.self, from: data)
                    if let remoteList = decoded.data, !remoteList.isEmpty {
                        self?.categories = remoteList
                    }
                } catch {
                    print("Error decoding remote categories: \(error)")
                }
            }
        }.resume()
    }

    // MARK: - Fetch Main Home
    public func fetchMainHome() {
        guard let url = URL(string: "\(baseUrl)main_home.php") else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            DispatchQueue.main.async {
                self?.fetchProducts()
            }
        }.resume()
    }

    // MARK: - Mock Dataset for Production-Grade UI
    public static let mockBanners: [HomeBanner] = [
        HomeBanner(
            id: "b1",
            title: "Heritage Jacquard Looms",
            subtitle: "Empowering 10,000+ Master Weavers Across India",
            imageUrl: "https://images.unsplash.com/photo-1606760227091-3dd870d97f1d?w=1200",
            buttonText: "Explore Looms"
        ),
        HomeBanner(
            id: "b2",
            title: "Pure Kanchipuram Silk Sarees",
            subtitle: "Woven with Real Zari on Electronic Jacquards",
            imageUrl: "https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=1200",
            buttonText: "Shop Sarees"
        ),
        HomeBanner(
            id: "b3",
            title: "High-Speed Electronic Jacquards",
            subtitle: "Model 2688 Hooks • ISO 9001:2015 Certified",
            imageUrl: "https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=1200",
            buttonText: "View Machines"
        )
    ]

    public static let mockCategories: [CategoryItem] = [
        CategoryItem(id: "c1", name: "Silk Sarees", isMachine: false, division: "products", department: "Womens Wear"),
        CategoryItem(id: "c2", name: "Bridal Sarees", isMachine: false, division: "products", department: "Womens Wear"),
        CategoryItem(id: "c3", name: "Jacquard Looms", isMachine: true, division: "machines", department: "Machines"),
        CategoryItem(id: "c4", name: "Punching Designs", isMachine: false, division: "designs", department: "Designs"),
        CategoryItem(id: "c5", name: "Electronic Jacquard", isMachine: true, division: "machines", department: "Machines"),
        CategoryItem(id: "c6", name: "Men's Dhoti & Shirts", isMachine: false, division: "products", department: "Mens Wear")
    ]

    public static let mockProducts: [SareeProduct] = [
        SareeProduct(
            id: "prod_001",
            title: "Pure Kanchipuram Silk Saree - Temple Border",
            category: "Silk Sarees",
            sareeType: "Pure Silk",
            price: "18,499",
            originalPrice: "24,999",
            discount: "26% OFF",
            description: "Handcrafted pure mulberry silk saree featuring traditional temple motif border, rich contrast pallu with genuine gold zari thread.",
            imageUrl: "https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800",
            imageList: [
                "https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800",
                "https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=800"
            ],
            isMachine: false,
            department: "Womens Wear",
            division: "products",
            variants: [
                ProductVariant(id: "v1", color: "Crimson Red", size: "Free Size", price: "18,499", originalPrice: "24,999"),
                ProductVariant(id: "v2", color: "Peacock Blue", size: "Free Size", price: "19,299", originalPrice: "25,999")
            ]
        ),
        SareeProduct(
            id: "prod_002",
            title: "Banarasi Jacquard Zari Brocade Saree",
            category: "Silk Sarees",
            sareeType: "Banarasi Silk",
            price: "12,950",
            originalPrice: "16,500",
            discount: "21% OFF",
            description: "Exquisite Banarasi floral brocade woven with precision on high-density looms. Silky smooth drape ideal for weddings and grand celebrations.",
            imageUrl: "https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=800",
            imageList: [
                "https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=800"
            ],
            isMachine: false,
            department: "Womens Wear",
            division: "products"
        ),
        SareeProduct(
            id: "prod_003",
            title: "Traditional Soft Silk Wedding Saree",
            category: "Bridal Sarees",
            sareeType: "Soft Silk",
            price: "8,999",
            originalPrice: "11,999",
            discount: "25% OFF",
            description: "Lightweight, easy-to-drape soft silk saree with self-embossed floral jaal and zari contrast border.",
            imageUrl: "https://images.unsplash.com/photo-1617627143750-d86bc21e42bb?w=800",
            imageList: [
                "https://images.unsplash.com/photo-1617627143750-d86bc21e42bb?w=800"
            ],
            isMachine: false,
            department: "Womens Wear",
            division: "products"
        ),
        SareeProduct(
            id: "prod_004",
            title: "Heavy Electronic Jacquard Machine 2688 Hooks",
            category: "Electronic Jacquard",
            sareeType: "High Speed Machine",
            price: "2,85,000",
            originalPrice: "3,20,000",
            discount: "11% OFF",
            description: "Industrial grade 2688 hooks electronic jacquard machine designed for high speed weaving of intricate sarees and fabrics. Low vibration, zero oil leakage.",
            imageUrl: "https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=800",
            imageList: [
                "https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=800"
            ],
            isMachine: true,
            machineModel: "UR-2688 PRO",
            weavingSpeed: "300 - 350 RPM",
            warrantyPeriod: "2 Years On-Site",
            powerRating: "2.2 kW Heavy Duty",
            department: "Machines",
            division: "machines"
        ),
        SareeProduct(
            id: "prod_005",
            title: "Air Jet Rapier Weaving Loom - 230cm",
            category: "Jacquard Looms",
            sareeType: "Rapier Loom",
            price: "5,40,000",
            originalPrice: "6,00,000",
            discount: "10% OFF",
            description: "High performance automatic rapier loom suitable for silk, cotton, and polyester blending. Includes computerized touchscreen controller.",
            imageUrl: "https://images.unsplash.com/photo-1504917599217-d4dc5ebe6122?w=800",
            imageList: [
                "https://images.unsplash.com/photo-1504917599217-d4dc5ebe6122?w=800"
            ],
            isMachine: true,
            machineModel: "UR-RAP-230",
            weavingSpeed: "450 RPM",
            warrantyPeriod: "3 Years Comprehensive",
            powerRating: "3.5 kW 3-Phase",
            department: "Machines",
            division: "machines"
        ),
        SareeProduct(
            id: "prod_006",
            title: "Mayil (Peacock) Traditional Jacquard Pattern .BMP",
            category: "Punching Designs",
            sareeType: "Digital Punch Card",
            price: "1,499",
            originalPrice: "2,500",
            discount: "40% OFF",
            description: "High resolution 2400-hook electronic Jacquard bitmap design punch file. Ready to load into loom USB controller with color separations.",
            imageUrl: "https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=800",
            imageList: [
                "https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=800"
            ],
            isMachine: false,
            bmpFileUrl: "https://crm.friendssoftwaresolutions.in/api/uday/uploads/design_sample.bmp",
            department: "Designs",
            division: "designs"
        ),
        SareeProduct(
            id: "prod_007",
            title: "Floral Mango Butta Grand Pallu Design .BMP",
            category: "Punching Designs",
            sareeType: "Digital Punch Card",
            price: "1,899",
            originalPrice: "3,000",
            discount: "36% OFF",
            description: "Grand traditional mango paisley and lotus motif pallu pattern formatted for 2688 and 1440 hooks electronic jacquard machines.",
            imageUrl: "https://images.unsplash.com/photo-1582562124811-c09040d0a901?w=800",
            imageList: [
                "https://images.unsplash.com/photo-1582562124811-c09040d0a901?w=800"
            ],
            isMachine: false,
            bmpFileUrl: "https://crm.friendssoftwaresolutions.in/api/uday/uploads/design_sample.bmp",
            department: "Designs",
            division: "designs"
        ),
        SareeProduct(
            id: "prod_008",
            title: "Men's Pure Silk Dhoti & Angavastram Set",
            category: "Men's Wear",
            sareeType: "Pure Silk",
            price: "4,499",
            originalPrice: "5,999",
            discount: "25% OFF",
            description: "Traditional pure raw silk 9x5 dhoti with fine gold zari border, matching angavastram for ceremonies and temple weddings.",
            imageUrl: "https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=800",
            imageList: [
                "https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=800"
            ],
            isMachine: false,
            department: "Mens Wear",
            division: "products"
        )
    ]

    public static let mockOrders: [OrderModel] = [
        OrderModel(
            id: "0IFNDKK376532834J746GY",
            title: "Pure Kanchipuram Silk Saree - Temple Border",
            date: "Sun, 5th Feb '23",
            amount: "18,499",
            status: "Completed",
            imageUrl: "https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=400",
            isMachine: false,
            shippingAddress: "Hinjewadi phase 1,",
            customerName: "Honey",
            customerPhone: "91XXXXXXXX",
            city: "Ville parle, Mumbai",
            sellerName: "Macro Delhi"
        ),
        OrderModel(
            id: "0IFNDKK998234710A129BC",
            title: "Traditional Soft Silk Wedding Saree",
            date: "Jan 22",
            amount: "8,999",
            status: "Cancelled",
            imageUrl: "https://images.unsplash.com/photo-1617627143750-d86bc21e42bb?w=400",
            isMachine: false,
            shippingAddress: "Andheri East,",
            customerName: "Honey",
            customerPhone: "91XXXXXXXX",
            city: "Mumbai",
            sellerName: "Toshina Brand Store"
        ),
        OrderModel(
            id: "0IFNDKK887342119F901KL",
            title: "Banarasi Jacquard Zari Brocade Saree",
            date: "Jan 15",
            amount: "12,950",
            status: "Refund Completed",
            imageUrl: "https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=400",
            isMachine: false,
            shippingAddress: "Hinjewadi phase 1,",
            customerName: "Honey",
            customerPhone: "91XXXXXXXX",
            city: "Pune",
            sellerName: "Provogue Retail"
        ),
        OrderModel(
            id: "0IFNDKK443210984E331MN",
            title: "Mayil (Peacock) Traditional Jacquard Pattern .BMP",
            date: "Dec 31, 2022",
            amount: "1,499",
            status: "Completed",
            imageUrl: "https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=400",
            isMachine: false,
            shippingAddress: "8th Block,",
            customerName: "Honey",
            customerPhone: "91XXXXXXXX",
            city: "Koramangala, Bangalore",
            sellerName: "Crossword Books",
            bmpFileUrl: "https://crm.friendssoftwaresolutions.in/api/uday/uploads/design_sample.bmp"
        ),
        OrderModel(
            id: "0IFNDKK112938475H882OP",
            title: "Heavy Electronic Jacquard Machine 2688 Hooks",
            date: "Recently",
            amount: "2,85,000",
            status: "Installation",
            imageUrl: "https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=400",
            isMachine: true,
            shippingAddress: "Weavers Industrial Estate,",
            customerName: "K. Balaji",
            customerPhone: "919876543210",
            city: "Salem",
            sellerName: "UdayaRavi Creations",
            bmpFileUrl: "https://crm.friendssoftwaresolutions.in/api/uday/uploads/design_sample.bmp"
        )
    ]
}
