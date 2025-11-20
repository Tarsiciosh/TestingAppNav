import SwiftUI

struct AgeBubble: View {
    @State private var isAnimating = false
    @State private var blobOffsets: [CGFloat] = Array(repeating: 0, count: 12)

    var body: some View {
        ZStack {
            // Background if needed
            Color.black.ignoresSafeArea()

            // Main living bubble
            LivingBlobShape(offsets: blobOffsets)
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.green.opacity(0.9),
                            Color.blue.opacity(0.9),
                            Color(red: 0, green: 0.2, blue: 0), // dark green
                            Color.black
                        ]),
                        center: .center,
                        startRadius: 10,
                        endRadius: 180
                    )
                )
                .frame(width: 220, height: 220)

            // Animated edge particles
            ForEach(0..<30, id: \.self) { index in
                EdgeParticle(
                    index: index,
                    total: 30,
                    radius: 110,
                    blobOffsets: blobOffsets,
                    isAnimating: isAnimating
                )
            }
        }
        .onAppear {
            isAnimating = true
            startBlobAnimation()
        }
    }

    private func startBlobAnimation() {
        // Continuously morph the blob shape
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            withAnimation(.easeInOut(duration: Double.random(in: 2...4))) {
                blobOffsets = (0..<12).map { _ in
                    CGFloat.random(in: -15...15)
                }
            }
        }
    }
}

struct AnimatableOffsets: VectorArithmetic {
    var values: [CGFloat]

    static var zero: AnimatableOffsets {
        AnimatableOffsets(values: Array(repeating: 0, count: 12))
    }

    static func + (lhs: AnimatableOffsets, rhs: AnimatableOffsets) -> AnimatableOffsets {
        AnimatableOffsets(values: zip(lhs.values, rhs.values).map(+))
    }

    static func - (lhs: AnimatableOffsets, rhs: AnimatableOffsets) -> AnimatableOffsets {
        AnimatableOffsets(values: zip(lhs.values, rhs.values).map(-))
    }

    mutating func scale(by rhs: Double) {
        values = values.map { $0 * CGFloat(rhs) }
    }

    var magnitudeSquared: Double {
        Double(values.reduce(0) { $0 + $1 * $1 })
    }
}

struct LivingBlobShape: Shape {
    var animatableOffsets: AnimatableOffsets

    var animatableData: AnimatableOffsets {
        get { animatableOffsets }
        set { animatableOffsets = newValue }
    }

    init(offsets: [CGFloat]) {
        self.animatableOffsets = AnimatableOffsets(values: offsets)
    }

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let baseRadius = min(rect.width, rect.height) / 2
        let offsets = animatableOffsets.values

        var path = Path()

        let points = 12
        let angleStep = 360.0 / Double(points)

        for i in 0...points {
            let angle = Double(i) * angleStep
            let radians = angle * .pi / 180
            let offset = offsets[i % points]
            let radius = baseRadius + offset

            let x = center.x + cos(radians) * radius
            let y = center.y + sin(radians) * radius

            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                // Create smooth curves using quadratic curves
                let prevAngle = Double(i - 1) * angleStep
                let prevRadians = prevAngle * .pi / 180
                let prevOffset = offsets[(i - 1) % points]
                let prevRadius = baseRadius + prevOffset
                let prevX = center.x + cos(prevRadians) * prevRadius
                let prevY = center.y + sin(prevRadians) * prevRadius

                // Control point between previous and current point
                let midAngle = (angle + prevAngle) / 2
                let midRadians = midAngle * .pi / 180
                let midOffset = (offset + prevOffset) / 2
                let controlRadius = baseRadius + midOffset
                let controlX = center.x + cos(midRadians) * controlRadius
                let controlY = center.y + sin(midRadians) * controlRadius

                path.addQuadCurve(
                    to: CGPoint(x: x, y: y),
                    control: CGPoint(x: controlX, y: controlY)
                )
            }
        }

        path.closeSubpath()
        return path
    }
}

struct EdgeParticle: View {
    let index: Int
    let total: Int
    let radius: CGFloat
    let blobOffsets: [CGFloat]
    let isAnimating: Bool

    @State private var rotation: Double = 0
    @State private var opacity: Double = 0.8
    @State private var scale: CGFloat = 1.0

    var body: some View {
        let currentAngle = rotation + Double(index) * (360.0 / Double(total))
        let offsetIndex = Int((currentAngle / 360.0) * Double(blobOffsets.count)) % blobOffsets.count
        let blobOffset = blobOffsets[offsetIndex]
        let adjustedRadius = radius + blobOffset

        Circle()
            .fill(Color.white)
            .frame(width: 3, height: 3)
            .blur(radius: 1)
            .opacity(opacity)
            .scaleEffect(scale)
            .offset(y: -adjustedRadius)
            .rotationEffect(.degrees(currentAngle))
            .onAppear {
                // Initial rotation offset for variety
                rotation = Double.random(in: 0...360)

                // Continuous rotation animation
                withAnimation(.linear(duration: Double.random(in: 8...12)).repeatForever(autoreverses: false)) {
                    rotation += 360
                }

                // Twinkling opacity animation
                withAnimation(.easeInOut(duration: Double.random(in: 0.5...1.5)).repeatForever(autoreverses: true)) {
                    opacity = Double.random(in: 0.3...1.0)
                }

                // Pulsing scale animation
                withAnimation(.easeInOut(duration: Double.random(in: 0.8...1.8)).repeatForever(autoreverses: true)) {
                    scale = CGFloat.random(in: 0.5...1.5)
                }
            }
    }
}

#Preview {
    AgeBubble()
}
