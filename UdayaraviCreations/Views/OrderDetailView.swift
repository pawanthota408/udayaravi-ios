import SwiftUI

public struct OrderDetailView: View {
    public let order: OrderModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showToastMessage: String? = nil

    private let flipkartBlue = Color(red: 40/255, green: 116/255, blue: 240/255)
    private let starGreen = Color(red: 56/255, green: 142/255, blue: 60/255)
    private let pageBg = Color(red: 241/255, green: 243/255, blue: 246/255)

    public init(order: OrderModel) {
        self.order = order
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MARK: - 1. Blue Top Header Bar
            ZStack {
                flipkartBlue
                    .edgesIgnoringSafeArea(.top)

                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.trailing, 10)
                    }

                    Text("Orders Details")
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundColor(.white)

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                .padding(.top, 4)
            }
            .frame(height: 52)

            // MARK: - Scrollable Content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // 2. Sub-Header: Order ID Bar
                    HStack {
                        Text("Order ID - \(order.id)")
                            .font(.system(size: 13.5))
                            .foregroundColor(Color(red: 117/255, green: 117/255, blue: 117/255))
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)

                    Divider()

                    // 3. Product Summary Box (Colo Women Black Heels)
                    HStack(alignment: .top, spacing: 14) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(order.title)
                                .font(.system(size: 15.5, weight: .semibold))
                                .foregroundColor(Color(red: 33/255, green: 33/255, blue: 33/255))

                            Text(order.isMachine ? "Heavy Electronic Jacquard Machine" : "4, Black")
                                .font(.system(size: 12.5))
                                .foregroundColor(Color(red: 117/255, green: 117/255, blue: 117/255))

                            Text("Seller: \(order.sellerName)")
                                .font(.system(size: 12.5))
                                .foregroundColor(Color(red: 97/255, green: 97/255, blue: 97/255))

                            Spacer().frame(height: 4)

                            HStack(spacing: 8) {
                                Text("Rs. \(order.amount.replacingOccurrences(of: "₹", with: "").trimmingCharacters(in: .whitespaces))")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(red: 33/255, green: 33/255, blue: 33/255))

                                Text("3 offers")
                                    .font(.system(size: 12.5, weight: .bold))
                                    .foregroundColor(starGreen)
                            }
                        }

                        Spacer()

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
                        .frame(width: 76, height: 76)
                        .cornerRadius(4)
                        .clipped()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.white)

                    // 4. Status Verification Banner (Delivery was made with OTP verification)
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(starGreen)
                                .frame(width: 20, height: 20)
                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        }

                        Text(order.isStep4Done ? "Delivery was made with OTP verification" : "Order verified with OTP verification")
                            .font(.system(size: 12.5, weight: .medium))
                            .foregroundColor(Color(red: 33/255, green: 33/255, blue: 33/255))

                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color(red: 241/255, green: 248/255, blue: 233/255))
                    .cornerRadius(4)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)

                    // 5. 4-Stage Flow Tracker (Order Received -> Scheduled Visit -> Installation -> Completed)
                    VStack(alignment: .leading, spacing: 0) {
                        VerticalTimelineStep(
                            title: "Order Received",
                            subtitle: order.date,
                            isCompleted: order.isStep1Done,
                            hasChevron: order.currentStageIndex == 1,
                            isLast: false
                        )

                        VerticalTimelineStep(
                            title: "Scheduled Visit",
                            subtitle: order.isStep2Done ? "Technician visit confirmed" : "Pending schedule",
                            isCompleted: order.isStep2Done,
                            hasChevron: order.currentStageIndex == 2,
                            isLast: false
                        )

                        VerticalTimelineStep(
                            title: "Installation",
                            subtitle: order.isStep3Done ? "Machine setup & harness calibration" : "Pending installation",
                            isCompleted: order.isStep3Done,
                            hasChevron: order.currentStageIndex == 3,
                            isLast: false
                        )

                        VerticalTimelineStep(
                            title: order.isStep4Done ? "Delivered" : "Completed",
                            subtitle: order.isStep4Done ? "Your item has been delivered" : "Pending completion",
                            isCompleted: order.isStep4Done,
                            hasChevron: order.currentStageIndex == 4,
                            isLast: true
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color.white)

                    // 6. Return Policy Row (Return policy valid till Feb 19  Know more)
                    HStack {
                        Text("Return policy valid till Feb 19 ")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(red: 33/255, green: 33/255, blue: 33/255))

                        Button(action: {
                            showToastMessage = "10 Days Return & Free Replacement policy active"
                        }) {
                            Text("Know more")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(flipkartBlue)
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)

                    Divider()

                    // 7. Shipping Details Box (Red-box highlighted by user in reference screen!)
                    HStack(alignment: .top, spacing: 14) {
                        Text("Shipping Details:")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(red: 117/255, green: 117/255, blue: 117/255))
                            .frame(width: 115, alignment: .leading)

                        VStack(alignment: .leading, spacing: 3) {
                            Text(order.customerName)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(red: 33/255, green: 33/255, blue: 33/255))

                            Text(order.shippingAddress.isEmpty ? "Hinjewadi phase 1," : order.shippingAddress)
                                .font(.system(size: 12.5))
                                .foregroundColor(Color(red: 66/255, green: 66/255, blue: 66/255))

                            Text("\(order.city), Maharashtra - 411057")
                                .font(.system(size: 12.5))
                                .foregroundColor(Color(red: 66/255, green: 66/255, blue: 66/255))

                            Text("Phone Number : \(order.customerPhone)")
                                .font(.system(size: 12.5, weight: .medium))
                                .foregroundColor(Color(red: 33/255, green: 33/255, blue: 33/255))
                        }

                        Spacer()
                    }
                    .padding(14)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(red: 220/255, green: 220/255, blue: 220/255), lineWidth: 1)
                    )
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)

                    Divider()

                    // 8. 5 Stars + Write a Review Row
                    HStack {
                        HStack(spacing: 4) {
                            ForEach(0..<5) { _ in
                                Text("★")
                                    .font(.system(size: 22))
                                    .foregroundColor(starGreen)
                            }
                        }

                        Spacer()

                        Button(action: {
                            showToastMessage = "Review submitted for Order #\(order.id)"
                        }) {
                            Text("Write a Review")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(flipkartBlue)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.white)

                    Divider()

                    // 9. Two Action Buttons: Return | Need help?
                    HStack(spacing: 0) {
                        Button(action: {
                            showToastMessage = "Return request initiated for #\(order.id)"
                        }) {
                            Text("Return")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(red: 33/255, green: 33/255, blue: 33/255))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }

                        Rectangle()
                            .fill(Color(red: 224/255, green: 224/255, blue: 224/255))
                            .frame(width: 1, height: 48)

                        Button(action: {
                            showToastMessage = "Connecting with executive for #\(order.id)"
                        }) {
                            Text("Need help?")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(red: 33/255, green: 33/255, blue: 33/255))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .frame(height: 48)
                    .background(Color.white)

                    // 10. Grey Card Separator
                    Rectangle()
                        .fill(pageBg)
                        .frame(height: 8)

                    // 11. Rate Experience Header
                    HStack {
                        Text("Rate your experience")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 117/255, green: 117/255, blue: 117/255))
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.white)

                    Divider()

                    // 12. Feedback Row (Did you find this page helpful?)
                    Button(action: {
                        showToastMessage = "Thank you for your feedback!"
                    }) {
                        HStack(spacing: 12) {
                            Text("👍")
                                .font(.system(size: 16))
                            Text("Did you find this page helpful?")
                                .font(.system(size: 13.5))
                                .foregroundColor(Color(red: 33/255, green: 33/255, blue: 33/255))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 117/255, green: 117/255, blue: 117/255))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color.white)
                    }

                    Divider()

                    // 13. Invoice Download Row
                    Button(action: {
                        showToastMessage = "GST Invoice downloaded for #\(order.id)"
                    }) {
                        HStack(spacing: 12) {
                            Text("🧾")
                                .font(.system(size: 16))
                            Text("Invoice Download")
                                .font(.system(size: 13.5))
                                .foregroundColor(Color(red: 33/255, green: 33/255, blue: 33/255))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 117/255, green: 117/255, blue: 117/255))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color.white)
                    }

                    Divider()

                    // 14. Jacquard Production File (.BMP) Download Row
                    Button(action: {
                        showToastMessage = "Downloading Jacquard .BMP Punch File for #\(order.id)..."
                    }) {
                        HStack(spacing: 12) {
                            Text("🧵")
                                .font(.system(size: 16))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Jacquard Production File (.BMP) Download")
                                    .font(.system(size: 13.5, weight: .medium))
                                    .foregroundColor(Color(red: 33/255, green: 33/255, blue: 33/255))
                                Text("Punch-card pattern for electronic looms & weavers")
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(red: 117/255, green: 117/255, blue: 117/255))
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12))
                                .foregroundColor(Color(red: 117/255, green: 117/255, blue: 117/255))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(Color.white)
                    }

                    Divider()
                    Spacer().frame(height: 24)
                }
            }
        }
        .navigationBarHidden(true)
        .overlay(
            VStack {
                if let msg = showToastMessage {
                    Text(msg)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.black.opacity(0.85))
                        .cornerRadius(20)
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation { showToastMessage = nil }
                            }
                        }
                        .padding(.bottom, 24)
                }
            },
            alignment: .bottom
        )
    }
}

// MARK: - Vertical Timeline Step Helper
struct VerticalTimelineStep: View {
    let title: String
    let subtitle: String
    let isCompleted: Bool
    let hasChevron: Bool
    let isLast: Bool

    private let greenColor = Color(red: 46/255, green: 125/255, blue: 50/255)
    private let greyColor = Color(red: 189/255, green: 189/255, blue: 189/255)
    private let lineGrey = Color(red: 224/255, green: 224/255, blue: 224/255)

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // Indicator and connecting line
            VStack(spacing: 0) {
                Circle()
                    .fill(isCompleted ? greenColor : greyColor)
                    .frame(width: 12, height: 12)

                if !isLast {
                    Rectangle()
                        .fill(isCompleted ? greenColor : lineGrey)
                        .frame(width: 2.5, height: 32)
                }
            }
            .frame(width: 20)

            // Step Content
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(red: 33/255, green: 33/255, blue: 33/255))

                    if hasChevron {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(red: 33/255, green: 33/255, blue: 33/255))
                    }
                }

                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 117/255, green: 117/255, blue: 117/255))
                }
            }
            .padding(.bottom, isLast ? 0 : 12)

            Spacer()
        }
    }
}
