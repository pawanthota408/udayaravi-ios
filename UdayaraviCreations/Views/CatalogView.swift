import SwiftUI

public struct CatalogView: View {
    @ObservedObject var apiService = APIService.shared
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var wishlistManager: WishlistManager

    public let initialDivision: String
    public let onSelectProduct: (SareeProduct) -> Void
    public let onOpenCart: () -> Void

    @State private var selectedDivision: String = "Apparels"
    @State private var searchQuery: String = ""
    @State private var selectedSubcategory: String = "All"
    @State private var sortBy: String = "Popular"
    @State private var showSortMenu: Bool = false
    @State private var toastMessage: String? = nil

    private let divisions = ["Apparels", "Designs", "Looms", "All"]

    private let subcategoriesByDivision: [String: [String]] = [
        "Apparels": ["All", "Silk Sarees", "Bridal Sarees", "Soft Silk", "Men's Wear"],
        "Designs": ["All", "Punching Designs", "Floral Motif", "Peacock Border", "Zari Jaal"],
        "Looms": ["All", "Electronic Jacquard", "Jacquard Looms", "High Speed", "Rapier Loom"],
        "All": ["All", "Silk Sarees", "Bridal Sarees", "Electronic Jacquard", "Jacquard Looms", "Punching Designs"]
    ]

    public init(
        initialDivision: String = "Apparels",
        onSelectProduct: @escaping (SareeProduct) -> Void,
        onOpenCart: @escaping () -> Void
    ) {
        self.initialDivision = initialDivision
        self.onSelectProduct = onSelectProduct
        self.onOpenCart = onOpenCart
        self._selectedDivision = State(initialValue: initialDivision)
    }

    private var currentSubcategories: [String] {
        return subcategoriesByDivision[selectedDivision] ?? ["All"]
    }

    private var filteredProducts: [SareeProduct] {
        var list = apiService.products

        // Filter by Division
        switch selectedDivision {
        case "Apparels":
            list = list.filter { !$0.isMachine && $0.division != "designs" }
        case "Designs":
            list = list.filter { $0.division == "designs" || $0.bmpFileUrl != nil }
        case "Looms":
            list = list.filter { $0.isMachine }
        default:
            break
        }

        // Filter by Subcategory
        if selectedSubcategory != "All" {
            list = list.filter {
                $0.category.localizedCaseInsensitiveContains(selectedSubcategory) ||
                $0.sareeType.localizedCaseInsensitiveContains(selectedSubcategory)
            }
        }

        // Filter by Search Query
        if !searchQuery.isEmpty {
            list = list.filter {
                $0.title.localizedCaseInsensitiveContains(searchQuery) ||
                $0.category.localizedCaseInsensitiveContains(searchQuery) ||
                $0.sareeType.localizedCaseInsensitiveContains(searchQuery) ||
                ($0.machineModel?.localizedCaseInsensitiveContains(searchQuery) ?? false)
            }
        }

        // Sort
        switch sortBy {
        case "Price: Low to High":
            list.sort { $0.numericPrice < $1.numericPrice }
        case "Price: High to Low":
            list.sort { $0.numericPrice > $1.numericPrice }
        case "Name":
            list.sort { $0.title < $1.title }
        default:
            break
        }

        return list
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Top App Bar
            CustomNavigationBar(
                title: "Catalog & Machinery",
                showBackButton: false,
                onBack: nil,
                showCartButton: true,
                onCartTap: onOpenCart
            )

            // MARK: - Search & Filter Row
            VStack(spacing: 8) {
                HStack(spacing: 10) {
                    // Search Field
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 14))
                            .foregroundColor(Color.gray)

                        TextField("Search Sarees, Looms, or .BMP files...", text: $searchQuery)
                            .font(.system(size: 13))

                        if !searchQuery.isEmpty {
                            Button(action: { searchQuery = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(AppTheme.border, lineWidth: 1)
                    )

                    // Sort Button
                    Menu {
                        Button("Popular") { sortBy = "Popular" }
                        Button("Price: Low to High") { sortBy = "Price: Low to High" }
                        Button("Price: High to Low") { sortBy = "Price: High to Low" }
                        Button("Name: A to Z") { sortBy = "Name" }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.system(size: 12))
                            Text(sortBy == "Popular" ? "Sort" : sortBy)
                                .font(.system(size: 12, weight: .semibold))
                                .lineLimit(1)
                        }
                        .foregroundColor(AppTheme.textPrimary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 9)
                        .background(Color.white)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(AppTheme.border, lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)

                // Segmented Division Tabs (Apparels | Designs | Looms | All)
                HStack(spacing: 0) {
                    ForEach(divisions, id: \.self) { div in
                        let isSelected = (selectedDivision == div)
                        Button(action: {
                            selectedDivision = div
                            selectedSubcategory = "All"
                        }) {
                            VStack(spacing: 6) {
                                Text(div == "Looms" ? "Looms & Machinery" : div)
                                    .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                    .foregroundColor(isSelected ? AppTheme.flipkartBlue : AppTheme.textSecondary)
                                    .padding(.top, 6)

                                Rectangle()
                                    .fill(isSelected ? AppTheme.flipkartBlue : Color.clear)
                                    .frame(height: 2.5)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .background(Color.white)
                .overlay(
                    Rectangle()
                        .fill(AppTheme.border)
                        .frame(height: 1),
                    alignment: .bottom
                )

                // Subcategory Pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(currentSubcategories, id: \.self) { subcat in
                            let isSelected = (selectedSubcategory == subcat)
                            Button(action: { selectedSubcategory = subcat }) {
                                Text(subcat)
                                    .font(.system(size: 12, weight: isSelected ? .bold : .regular))
                                    .foregroundColor(isSelected ? AppTheme.flipkartBlue : AppTheme.textSecondary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 5)
                                    .background(isSelected ? Color(red: 232/255, green: 240/255, blue: 254/255) : Color.white)
                                    .cornerRadius(14)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(isSelected ? AppTheme.flipkartBlue : AppTheme.border, lineWidth: 0.8)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                }
                .background(Color.white)
            }
            .background(Color.white)

            // MARK: - Product Grid / Empty State
            if filteredProducts.isEmpty {
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "tray")
                        .font(.system(size: 44))
                        .foregroundColor(Color.gray.opacity(0.4))
                    Text("No products found")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(AppTheme.textPrimary)
                    Text("Try adjusting your filters or search terms.")
                        .font(.system(size: 13))
                        .foregroundColor(AppTheme.textSecondary)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppTheme.pageBg)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Showing \(filteredProducts.count) results")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                            .padding(.horizontal, 16)
                            .padding(.top, 8)

                        LazyVGrid(
                            columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                            spacing: 12
                        ) {
                            ForEach(filteredProducts) { product in
                                ProductCard(
                                    product: product,
                                    onSelect: { onSelectProduct(product) },
                                    onAddToCart: {
                                        cartManager.addToCart(product: product)
                                        showToast("Added to Cart!")
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    }
                }
                .background(AppTheme.pageBg)
            }
        }
        .overlay(
            VStack {
                Spacer()
                if let msg = toastMessage {
                    ToastView(message: msg)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        )
    }

    private func showToast(_ msg: String) {
        withAnimation {
            toastMessage = msg
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                toastMessage = nil
            }
        }
    }
}

