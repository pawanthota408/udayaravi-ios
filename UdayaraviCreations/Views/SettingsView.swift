import SwiftUI

public struct SettingsView: View {
    public let onBack: () -> Void
    @State private var pushNotificationsEnabled: Bool = true
    @State private var orderUpdatesSms: Bool = true

    public init(onBack: @escaping () -> Void) {
        self.onBack = onBack
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Header
            CustomNavigationBar(
                title: "Settings & Support",
                showBackButton: true,
                onBack: onBack,
                showCartButton: false
            )

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    // Notifications
                    VStack(alignment: .leading, spacing: 0) {
                        Text("NOTIFICATIONS")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(AppTheme.textSecondary)
                            .padding(.horizontal, 16)
                            .padding(.top, 14)
                            .padding(.bottom, 6)

                        Toggle(isOn: $pushNotificationsEnabled) {
                            Text("Push Notifications")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)

                        Divider()

                        Toggle(isOn: $orderUpdatesSms) {
                            Text("SMS Order & Installation Alerts")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                    // Corporate Information
                    VStack(alignment: .leading, spacing: 0) {
                        Text("CORPORATE HEADQUARTERS")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(AppTheme.textSecondary)
                            .padding(.horizontal, 16)
                            .padding(.top, 14)
                            .padding(.bottom, 6)

                        VStack(alignment: .leading, spacing: 6) {
                            Text("UdayaRavi Creations")
                                .font(.system(size: 14.5, weight: .bold))
                                .foregroundColor(AppTheme.textPrimary)

                            Text("ISO 9001:2015 Certified Textile Machinery & Handloom Manufacturer")
                                .font(.system(size: 12))
                                .foregroundColor(AppTheme.textSecondary)

                            Text("Plot 14-B, Weavers Industrial Complex, Ammapet, Salem, Tamil Nadu - 636003, India")
                                .font(.system(size: 12.5))
                                .foregroundColor(Color(red: 66/255, green: 66/255, blue: 66/255))
                        }
                        .padding(16)

                        Divider()

                        Button(action: {
                            if let url = URL(string: "tel://919876543210") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(AppTheme.flipkartBlue)
                                Text("Customer Support: +91 98765 43210")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(AppTheme.flipkartBlue)
                                Spacer()
                            }
                            .padding(16)
                        }

                        Divider()

                        Button(action: {
                            if let url = URL(string: "mailto:support@udayaravicreations.com") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(AppTheme.flipkartBlue)
                                Text("Email: support@udayaravicreations.com")
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(AppTheme.flipkartBlue)
                                Spacer()
                            }
                            .padding(16)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 16)

                    // App Version Footer
                    VStack(spacing: 4) {
                        Text("UdayaRavi Creations iOS v1.0 (Build 1)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppTheme.textSecondary)
                        Text("© 2026 UdayaRavi Creations. All rights reserved.")
                            .font(.system(size: 11))
                            .foregroundColor(AppTheme.textSecondary.opacity(0.8))
                    }
                    .padding(.vertical, 16)

                    Spacer().frame(height: 24)
                }
            }
            .background(AppTheme.pageBg)
        }
    }
}

