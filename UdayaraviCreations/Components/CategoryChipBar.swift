import SwiftUI

public struct CategoryChipBar: View {
    public let categories: [String]
    @Binding public var selectedCategory: String

    public init(categories: [String], selectedCategory: Binding<String>) {
        self.categories = categories
        self._selectedCategory = selectedCategory
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    let isSelected = (selectedCategory == category)
                    Button(action: {
                        selectedCategory = category
                    }) {
                        Text(category)
                            .font(.system(size: 12.5, weight: isSelected ? .bold : .medium))
                            .foregroundColor(isSelected ? AppTheme.flipkartBlue : Color(red: 70/255, green: 70/255, blue: 70/255))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(isSelected ? Color(red: 232/255, green: 240/255, blue: 254/255) : Color.white)
                            .cornerRadius(18)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(isSelected ? AppTheme.flipkartBlue : AppTheme.border, lineWidth: 1)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color.white)
    }
}

