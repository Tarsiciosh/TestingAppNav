import SwiftUI

struct TestingView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ShadowedRect {
            Text("")
        }
    }
}

#Preview {
    TestingView()
}


struct ShadowedRect<Content: View>: View {
    let content: Content
    let cornerRadius: CGFloat
    let shadowColor: Color
    let shadowOpacity: Double
    let shadowRadius: CGFloat
    let shadowOffset: CGSize
    let backgroundColor: Color

    init(
        cornerRadius: CGFloat = 8,
        shadowColor: Color = .black,
        shadowOpacity: Double = 0.08,
        shadowRadius: CGFloat = 7,
        shadowOffset: CGSize = CGSize(width: 0, height: 0.7),
        backgroundColor: Color = .gray,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.shadowRadius = shadowRadius
        self.shadowOffset = shadowOffset
        self.backgroundColor = backgroundColor
        self.content = content()
    }

    var body: some View {
        content
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(
                color: shadowColor.opacity(shadowOpacity),
                radius: shadowRadius,
                x: shadowOffset.width,
                y: shadowOffset.height
            )
    }
}
