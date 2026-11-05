# UdayaRavi Creations — Native iOS Application Guide

This folder contains the complete, standalone native **iOS Application** for **UdayaRavi Creations**, built in Swift 5 and SwiftUI for iOS 15+.

---

## Architecture & Completed Application Features

### 1. Root Tab Navigation (`RootTabView.swift`)
The app features a 5-tab persistent bottom bar with active badge counters and STRICT 1-step back navigation:
* **Tab 0: Home (`MainHomeView.swift`)**:
  - Auto-sliding hero banners with animated page indicators
  - ISO 9001:2015 Manufacturer Trust Bar & Legacy Metrics (`50+ Years`, `10k+ Looms`, `5k+ Patterns`)
  - Division quick pills: Apparels, Industrial Looms, Jacquard Designs
  - Featured Silk & Wedding Sarees grid
  - Industrial Looms & Machinery grid
  - Production-ready .BMP punch-card patterns
  - 24/7 Salem Weavers Helpline callout with 1-tap phone dialer
* **Tab 1: Catalog & Machinery (`CatalogView.swift`)**:
  - Division switcher: `Apparels` | `Designs` | `Looms & Machinery` | `All`
  - Subcategory filter chips (Silk Sarees, Bridal, Electronic Jacquard, Rapier, BMP Patterns)
  - Real-time search by keyword, title, category, or machine model
  - Sorting (Popular, Price: Low to High, Price: High to Low, Name)
  - Interactive product grid with discount tags and instant "Add to Cart"
* **Tab 2: My Orders (`OrdersView.swift` & `OrderDetailView.swift`)**:
  - Full 4-Stage Lifecycle Flow:
    $$\text{Order Received} \longrightarrow \text{Scheduled Visit} \longrightarrow \text{Installation} \longrightarrow \text{Completed}$$
  - Real-time order filtering (All, Order Received, Scheduled Visit, Installation, Completed, Cancelled)
  - Order Detail View with technical specs, return policy, invoice download, and Jacquard punch `.BMP` file download
* **Tab 3: Cart (`CartView.swift`)**:
  - Itemized cart with quantity steppers (`+` / `-`) and remove actions
  - Delivery address card with instant "Change / Add" modal
  - Comprehensive price breakdown: Subtotal, Free Delivery threshold (₹999), Savings summary
  - "Place Order" button routing to Checkout
* **Tab 4: My Account / Profile (`ProfileView.swift`)**:
  - User profile with Avatar, Name, Email, Phone, Company, GSTIN
  - Quick menu: My Orders, Wishlist, Saved Addresses, Loom Service & Calibration, Settings, Logout
* **Full E-Commerce Flow**:
  - **Product Detail (`ProductDetailView.swift`)**: Image gallery, variant selection (Color, Size), machine technical specs, delivery pincode estimator, "Buy Now" and "Add to Cart".
  - **Checkout (`CheckoutView.swift`)**: 3-step progress bar (Address ➔ Summary ➔ Payment), Payment methods (Cash on Delivery, UPI / Razorpay, Cards, Net Banking), direct integration with `orders.php` API.
  - **Order Confirmation (`OrderSuccessView.swift`)**: Success confirmation with animated checkmark, Order ID, and 1-tap navigation to track orders.
  - **Wishlist (`WishlistView.swift`)**: Saved favorite products with quick move-to-cart.
  - **Addresses (`AddressesView.swift`)**: Multi-address management with default selector.
  - **Settings (`SettingsView.swift`)**: Notifications toggle, corporate office details, support contact.
  - **Authentication (`LoginView.swift`)**: Mobile / Email login with option to continue as guest.

---

## State Management & Services
* **`CartManager.swift`**: Reactive ObservableObject handling cart operations, quantities, subtotals, and persistent local caching in `UserDefaults`.
* **`WishlistManager.swift`**: Manages favorite items and persistence.
* **`UserManager.swift`**: Manages user session, login state, and delivery addresses.
* **`APIService.swift`**: Asynchronous networking client connected to `https://crm.friendssoftwaresolutions.in/api/uday/`:
  - `fetchOrders(userId:)`
  - `placeOrder(request:)`
  - `fetchProducts(division:isMachine:category:search:)`
  - `fetchCategories(division:isMachine:)`
  - `fetchMainHome()`
  - Enriched offline mock dataset for testing in simulators and offline environments.

---

## Folder Structure
```
Udayaravi-creation iOS App/
├── UdayaraviCreations.xcodeproj/
│   └── project.pbxproj            # Xcode Project Configuration
├── UdayaraviCreations/
│   ├── UdayaraviCreationsApp.swift # Root SwiftUI App Entry Point
│   ├── Info.plist                 # iOS App Permissions & Configuration
│   ├── Assets.xcassets/           # App Icons & Color Catalogs
│   ├── Theme/
│   │   └── Theme.swift            # Brand colors, Gradients, ViewModifiers
│   ├── Models/
│   │   ├── OrderModel.swift       # Order & Order Item models
│   │   ├── ProductModel.swift     # SareeProduct, CategoryItem, Banners
│   │   ├── UserModel.swift        # UserProfile, DeliveryAddress
│   │   └── CartItem.swift         # CartItem data structure
│   ├── Services/
│   │   └── APIService.swift       # Networking & API integration
│   ├── Managers/
│   │   ├── CartManager.swift      # Cart state & UserDefaults caching
│   │   ├── WishlistManager.swift  # Wishlist state & persistence
│   │   └── UserManager.swift      # User session & address management
│   ├── Components/
│   │   ├── ProductCard.swift      # Modern e-commerce card
│   │   ├── BannerCarouselView.swift # Animated hero slider
│   │   ├── CategoryChipBar.swift  # Filter pills
│   │   ├── ToastView.swift        # Floating HUD notification
│   │   └── CustomNavigationBar.swift # Top app header
│   └── Views/
│       ├── RootTabView.swift      # 5-Tab controller & nav stack
│       ├── MainHomeView.swift     # Home screen
│       ├── CatalogView.swift      # Catalog & search
│       ├── ProductDetailView.swift# Product detail & specs
│       ├── CartView.swift         # Cart & price breakdown
│       ├── CheckoutView.swift     # Checkout & payment
│       ├── OrderSuccessView.swift # Confirmation celebration
│       ├── OrdersView.swift       # Orders list with lifecycle
│       ├── OrderDetailView.swift  # Order details & BMP download
│       ├── ProfileView.swift      # User profile & quick links
│       ├── WishlistView.swift     # Saved items
│       ├── AddressesView.swift    # Delivery addresses
│       ├── SettingsView.swift     # App settings & corporate info
│       └── LoginView.swift        # Authentication screen
├── build_ipa.sh                   # 1-Click build script for macOS
└── .github/workflows/build-ipa.yml# GitHub Actions CI for automated IPA builds
```

---

## How to Export the .ipa File (On any Mac)

### Method 1: 1-Click Terminal Command
```bash
chmod +x build_ipa.sh
./build_ipa.sh
```
This automatically compiles the project and outputs **`UdayaraviCreations.ipa`** in the project directory.

### Method 2: Xcode GUI
1. Open **`UdayaraviCreations.xcodeproj`** in Xcode.
2. Select target device: **Any iOS Device (arm64)**.
3. Choose **Product ➔ Archive**.
4. In the Organizer window, click **Distribute App ➔ Custom ➔ Development / Ad Hoc ➔ Export**.

### Method 3: GitHub Actions (Automated Cloud Build)
Push to the repository and trigger the `.github/workflows/build-ipa.yml` action to download the built `.ipa` artifact directly from GitHub!
