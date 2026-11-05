import SwiftUI

public struct OrdersView: View {
    @StateObject private var apiService = APIService.shared
    @State private var searchQuery: String = ""
    @State private var selectedFilter: String = "All"
    @State private var selectedOrder: OrderModel? = nil
    @State private var navigateToDetail: Bool = false

    private let flipkartBlue = Color(red: 40/255, green: 116/255, blue: 240/255)
    private let starGreen = Color(red: 56/255, green: 142/255, blue: 60/255)
    private let pageBg = Color(red: 241/255, green: 243/255, blue: 246/255)

    private let filterTabs = [
        "All",
        "Order Received",
        "Scheduled Visit",
        "Installation",
        "Completed",
        "Cancelled"
    ]

    public var onBack: (() -> Void)? = nil
    public var onTabChange: ((Int) -> Void)? = nil

    public init(onBack: (() -> Void)? = nil, onTabChange: ((Int) -> Void)? = nil) {
        self.onBack = onBack
        self.onTabChange = onTabChange
    }

    private var filteredOrders: [OrderModel] {
        apiService.orders.filter { order in
            let matchesFilter: Bool
            switch selectedFilter {
            case "All":
                matchesFilter = true
            case "Order Received":
                matchesFilter = order.status.lowercased().contains("order") || order.status.lowercased().contains("processing")
            case "Scheduled Visit":
                matchesFilter = order.status.lowercased().contains("visit")
            case "Installation":
                matchesFilter = order.status.lowercased().contains("install") || order.status.lowercased().contains("transit")
            case "Completed":
                matchesFilter = order.status.lowercased().contains("complete") || order.status.lowercased().contains("deliver")
            case "Cancelled":
                matchesFilter = order.status.lowercased().contains("cancel") || order.status.lowercased().contains("refund")
            default:
                matchesFilter = order.status.caseInsensitiveCompare(selectedFilter) == .orderedSame
            }

            let matchesSearch = searchQuery.isEmpty ||
                order.title.localizedCaseInsensitiveContains(searchQuery) ||
                order.city.localizedCaseInsensitiveContains(searchQuery) ||
                order.id.localizedCaseInsensitiveContains(searchQuery)

            return matchesFilter && matchesSearch
        }
    }

    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // MARK: - 1. Blue Top Header Bar
                ZStack {
                    flipkartBlue
                        .edgesIgnoringSafeArea(.top)

                    HStack(spacing: 12) {
                        Button(action: {
                            if let back = onBack {
                                back()
                            } else {
                                onTabChange?(0)
                            }
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }

                        Text("My Orders")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)

                        Spacer()

                        Button(action: {
                            apiService.fetchOrders()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                    .padding(.top, 4)
                }
                .frame(height: 52)

                // MARK: - 2. Search & Filters Bar
                VStack(spacing: 0) {
                    HStack(spacing: 12) {
                        // Search Box
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 15))
                                .foregroundColor(Color(red: 117/255, green: 117/255, blue: 117/255))

                            TextField("Search your order here", text: $searchQuery)
                                .font(.system(size: 13.5))

                            if !searchQuery.isEmpty {
                                Button(action: { searchQuery = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color(red: 220/255, green: 220/255, blue: 220/255), lineWidth: 1)
                        )

                        // Filters Button
                        Button(action: {
                            selectedFilter = (selectedFilter == "All") ? "Scheduled Visit" : "All"
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "line.3.horizontal.decrease")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color(red: 66/255, green: 66/255, blue: 66/255))

                                Text("Filters")
                                    .font(.system(size: 13.5, weight: .medium))
                                    .foregroundColor(Color(red: 66/255, green: 66/255, blue: 66/255))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.white)

                    // Filter Chips Bar (Order Received -> Scheduled Visit -> Installation -> Completed)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(filterTabs, id: \.self) { tab in
                                let isSelected = (selectedFilter == tab)
                                Button(action: { selectedFilter = tab }) {
                                    Text(tab)
                                        .font(.system(size: 12, weight: isSelected ? .bold : .regular))
                                        .foregroundColor(isSelected ? flipkartBlue : Color(red: 85/255, green: 85/255, blue: 85/255))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(isSelected ? Color(red: 232/255, green: 240/255, blue: 254/255) : Color.white)
                                        .cornerRadius(16)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(isSelected ? flipkartBlue : Color(red: 224/255, green: 224/255, blue: 224/255), lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                    }
                    .background(Color.white)
                }

                // MARK: - 3. Orders List
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 6) {
                        ForEach(filteredOrders) { order in
                            Button(action: {
                                selectedOrder = order
                                navigateToDetail = true
                            }) {
                                OrderCardItem(order: order, flipkartBlue: flipkartBlue, starGreen: starGreen)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top, 4)
                }
                .background(pageBg)

                // Hidden NavigationLink to OrderDetailView
                NavigationLink(
                    destination: Group {
                        if let order = selectedOrder {
                            OrderDetailView(order: order)
                        }
                    },
                    isActive: $navigateToDetail
                ) {
                    EmptyView()
                }

                // MARK: - 4. Bottom Navigation Bar
                HStack {
                    Button(action: { onTabChange?(0) }) {
                        BottomNavTab(title: "Home", systemImage: "house", isSelected: false)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Spacer()

                    Button(action: { onTabChange?(1) }) {
                        BottomNavTab(title: "Categories", systemImage: "square.grid.2x2", isSelected: false)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Spacer()

                    Button(action: { onTabChange?(2) }) {
                        BottomNavTab(title: "My Orders", systemImage: "cube.box.fill", isSelected: true, activeColor: flipkartBlue)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Spacer()

                    Button(action: { onTabChange?(3) }) {
                        BottomNavTab(title: "Cart", systemImage: "cart", isSelected: false)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Spacer()

                    Button(action: { onTabChange?(4) }) {
                        BottomNavTab(title: "Profile", systemImage: "person", isSelected: false)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(Color.white)
                .overlay(
                    Rectangle()
                        .fill(Color(red: 232/255, green: 232/255, blue: 232/255))
                        .frame(height: 1),
                    alignment: .top
                )
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Order Card Item Component (Screen 1 Design)
struct OrderCardItem: View {
    let order: OrderModel
    let flipkartBlue: Color
    let starGreen: Color

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 14) {
                // Product Thumbnail
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(red: 224/255, green: 224/255, blue: 224/255), lineWidth: 0.5)
                        .background(Color(red: 249/255, green: 249/255, blue: 249/255))

                    if let urlStr = order.imageUrl, let url = URL(string: urlStr) {
                        AsyncImage(url: url) { phase in
                            if let img = phase.image {
                                img.resizable().aspectRatio(contentMode: .fill)
                            } else {
                                Text(String(order.title.prefix(1)).uppercased())
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(flipkartBlue)
                            }
                        }
                    } else {
                        Text(String(order.title.prefix(1)).uppercased())
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(flipkartBlue)
                    }
                }
                .frame(width: 74, height: 74)
                .cornerRadius(4)
                .clipped()

                // Status Location line, date, and product title
                VStack(alignment: .leading, spacing: 3) {
                    Text(order.statusLocationLine)
                        .font(.system(size: 13.5, weight: .bold))
                        .foregroundColor(
                            order.status.lowercased().contains("cancel") ? Color.red :
                            order.isStep4Done ? Color(red: 33/255, green: 33/255, blue: 33/255) : flipkartBlue
                        )
                        .lineLimit(1)

                    if !order.dateSubtitle.isEmpty {
                        Text(order.dateSubtitle)
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 117/255, green: 117/255, blue: 117/255))
                    }

                    Text(order.title)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(red: 97/255, green: 97/255, blue: 97/255))
                        .lineLimit(1)
                }

                Spacer()

                // Right Chevron (>)
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 158/255, green: 158/255, blue: 158/255))
                    .padding(.top, 4)
            }
            .padding(.horizontal, 14)
            .padding(.top, 14)

            Spacer().frame(height: 12)

            // Star Rating & Review Link Row (Matching bottom of Screen 1)
            HStack {
                HStack(spacing: 2) {
                    ForEach(0..<5) { _ in
                        Text("★")
                            .font(.system(size: 18))
                            .foregroundColor(order.isStep4Done ? starGreen : Color(red: 189/255, green: 189/255, blue: 189/255))
                    }
                }

                Spacer().frame(width: 12)

                if order.isStep4Done {
                    Text("Write a Review")
                        .font(.system(size: 12.5, weight: .semibold))
                        .foregroundColor(flipkartBlue)
                } else {
                    Text("Rate this product now")
                        .font(.system(size: 12.5))
                        .foregroundColor(Color(red: 117/255, green: 117/255, blue: 117/255))
                }

                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 14)
        }
        .background(Color.white)
    }
}

// MARK: - Bottom Nav Tab Item
struct BottomNavTab: View {
    let title: String
    let systemImage: String
    let isSelected: Bool
    var activeColor: Color = Color(red: 40/255, green: 116/255, blue: 240/255)

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: systemImage)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? activeColor : Color(red: 117/255, green: 117/255, blue: 117/255))
            Text(title)
                .font(.system(size: 10, weight: isSelected ? .bold : .regular))
                .foregroundColor(isSelected ? activeColor : Color(red: 117/255, green: 117/255, blue: 117/255))
        }
    }
}
