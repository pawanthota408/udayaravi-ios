import SwiftUI

@main
struct UdayaraviCreationsApp: App {
    @StateObject private var cartManager = CartManager.shared
    @StateObject private var wishlistManager = WishlistManager.shared
    @StateObject private var userManager = UserManager.shared

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(cartManager)
                .environmentObject(wishlistManager)
                .environmentObject(userManager)
        }
    }
}
