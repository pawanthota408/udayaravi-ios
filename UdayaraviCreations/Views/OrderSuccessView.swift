import SwiftUI

public struct OrderSuccessView: View {
    public let order: OrderModel
    public let onViewOrders: () -> Void
    public let onContinueShopping: () -> Void

    public init(
        order: OrderModel,
        onViewOrders: @escaping () -> Void,
        onContinueShopping: @escaping () -> Void
    ) {
        self.order = order
        self.onViewOrders = onViewOrders
        self.onContinueShopping = onContinueShopping
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            ZStack {
                AppTheme.starGreen
                    .edgesIgnoringSafeArea(.top)

                Text("Order Confirmation")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
            }
            .frame(height: 52)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Success Icon & Message
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(AppTheme.starGreen.opacity(0.12))
                                .frame(width: 88, height: 88)

                            Circle()
                                .fill(AppTheme.starGreen)
                                .frame(width: 64, height: 64)

                            Image(systemName: "checkmark")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.top, 24)

                        Text("Order Placed Successfully!")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(AppTheme.textPrimary)

                        Text("Thank you for your order with UdayaRavi Creations")
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.textSecondary)
                    }

                    // Order Details Card
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Order ID")
                                    .font(.system(size: 11))
                                    .foregroundColor(AppTheme.textSecondary)
                                Text(order.id)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(AppTheme.flipkartBlue)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 3) {
                                Text("Amount")
                                    .font(.system(size: 11))
                                    .foregroundColor(AppTheme.textSecondary)
                                Text("₹\(order.amount.replacingOccurrences(of: "₹", with: ""))")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary)
                            }
                        }

                        Divider()

                        HStack(spacing: 12) {
                            Image(systemName: order.isMachine ? "wrench.and.screwdriver.fill" : "shippingbox.fill")
                                .font(.system(size: 20))
                                .foregroundColor(AppTheme.flipkartBlue)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(order.isMachine ? "Technician Visit & Machine Setup" : "Estimated Delivery")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(AppTheme.textPrimary)
                                Text(order.isMachine ? "Our factory engineer will contact you within 24 hours" : "Arriving within 3-5 business days")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                        }

                        Divider()

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Delivery Address:")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(AppTheme.textSecondary)
                            Text(order.customerName)
                                .font(.system(size: 13, weight: .bold))
                            Text(order.shippingAddress)
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 66/255, green: 66/255, blue: 66/255))
                            Text("Phone: \(order.customerPhone)")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 66/255, green: 66/255, blue: 66/255))
                        }

                        if order.bmpFileUrl != nil {
                            Divider()
                            HStack(spacing: 10) {
                                Text("🧵")
                                VStack(alignment: .leading, spacing: 1) {
                                    Text("Jacquard .BMP File Ready")
                                        .font(.system(size: 13, weight: .semibold))
                                    Text("Available for download in Order Details")
                                        .font(.system(size: 11.5))
                                        .foregroundColor(AppTheme.textSecondary)
                                }
                            }
                        }
                    }
                    .padding(18)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppTheme.border, lineWidth: 0.8)
                    )
                    .padding(.horizontal, 16)

                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: onViewOrders) {
                            Text("View in My Orders")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 48)
                                .background(AppTheme.flipkartBlue)
                                .cornerRadius(6)
                        }

                        Button(action: onContinueShopping) {
                            Text("Continue Shopping")
                                .font(.system(size: 14.5, weight: .semibold))
                                .foregroundColor(AppTheme.textPrimary)
                                .frame(maxWidth: .infinity)
                                .frame(height: 46)
                                .background(Color.white)
                                .cornerRadius(6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(AppTheme.border, lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    Spacer().frame(height: 32)
                }
            }
            .background(AppTheme.pageBg)
        }
    }
}

