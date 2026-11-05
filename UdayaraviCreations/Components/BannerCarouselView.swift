import SwiftUI

public struct BannerCarouselView: View {
    public let banners: [HomeBanner]
    public let onSelect: (HomeBanner) -> Void

    @State private var currentIndex: Int = 0
    private let timer = Timer.publish(every: 4.0, on: .main, in: .common).autoconnect()

    public init(banners: [HomeBanner], onSelect: @escaping (HomeBanner) -> Void) {
        self.banners = banners
        self.onSelect = onSelect
    }

    public var body: some View {
        VStack(spacing: 8) {
            if banners.isEmpty {
                EmptyView()
            } else {
                TabView(selection: $currentIndex) {
                    ForEach(0..<banners.count, id: \.self) { index in
                        let banner = banners[index]
                        Button(action: { onSelect(banner) }) {
                            ZStack(alignment: .bottomLeading) {
                                // Background Image
                                if let url = URL(string: banner.imageUrl) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        default:
                                            Rectangle()
                                                .fill(Color(red: 30/255, green: 30/255, blue: 34/255))
                                        }
                                    }
                                } else {
                                    Rectangle()
                                        .fill(Color(red: 30/255, green: 30/255, blue: 34/255))
                                }

                                // Dark Vignette Gradient
                                LinearGradient(
                                    colors: [Color.clear, Color.black.opacity(0.85)],
                                    startPoint: .center,
                                    endPoint: .bottom
                                )

                                // Text Content
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(banner.title)
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundColor(Color.white)
                                        .shadow(color: Color.black.opacity(0.8), radius: 2, x: 0, y: 1)

                                    Text(banner.subtitle)
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.white.opacity(0.9))
                                        .lineLimit(2)

                                    HStack {
                                        Text(banner.buttonText ?? "Explore")
                                            .font(.system(size: 11, weight: .bold))
                                            .foregroundColor(Color.black)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 5)
                                            .background(AppTheme.gold)
                                            .cornerRadius(4)
                                        Spacer()
                                    }
                                    .padding(.top, 4)
                                }
                                .padding(14)
                            }
                            .frame(height: 190)
                            .cornerRadius(10)
                            .clipped()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .tag(index)
                    }
                }
                .frame(height: 190)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onReceive(timer) { _ in
                    guard !banners.isEmpty else { return }
                    withAnimation {
                        currentIndex = (currentIndex + 1) % banners.count
                    }
                }

                // Page Indicator Dots
                HStack(spacing: 5) {
                    ForEach(0..<banners.count, id: \.self) { index in
                        Capsule()
                            .fill(currentIndex == index ? AppTheme.gold : Color.gray.opacity(0.35))
                            .frame(width: currentIndex == index ? 16 : 6, height: 6)
                            .animation(.easeInOut(duration: 0.25), value: currentIndex)
                    }
                }
                .padding(.top, 2)
            }
        }
    }
}

