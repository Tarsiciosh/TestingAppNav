import SwiftUI

struct TestingView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ShadowedRect {
            Text("Hello")
                .frame(width: 200, height: 80)
                .shimmer()
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
        backgroundColor: Color = .white,
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

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -0.5

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color.white.opacity(0), location: 0),
                                    .init(color: Color.white.opacity(0.3), location: 0.3),
                                    .init(color: Color.white.opacity(0.7), location: 0.5),
                                    .init(color: Color.white.opacity(0.3), location: 0.7),
                                    .init(color: Color.white.opacity(0), location: 1.0)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * 0.6)
                        .offset(x: geometry.size.width * phase)
                        .blendMode(.overlay)
                }
            )
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = 1.5
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}
