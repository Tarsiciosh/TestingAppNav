import SwiftUI

struct BioAgeBubble: View {
    @State private var time: Double = 0
    var maxDelta: CGFloat = 0.06
    var animationSpeed: Double = 1.5
    let baseRadius: CGFloat = 80

    // Random phase offsets for each point to create organic movement
    let phaseOffsets: [Double] = [0, 1.2, 2.5, 0.8, 3.1, 1.7, 2.9]//, 0, 3.5, 1.2, 0.3, 1.7, 0.9, 3.1]
    let frequencies: [Double] = [1.0, 1.3, 0.9, 1.1, 0.85, 1.15, 0.95]//, 1.1, 0.8, 0.5, 1.3, 0.65, 1.3, 0.6]

    var numberOfPoints: Int { phaseOffsets.count }

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)

                // Calculate current radii based on time
                let currentRadii = calculateRadii(at: timeline.date.timeIntervalSinceReferenceDate)

                // Create base path
                let basePath = createSmoothPath(center: center, radii: currentRadii)

                // Draw 10 concentric paths with increasing opacity
                let numberOfLayers = 10
                let innerScale: CGFloat = 0.6

                for i in 0..<numberOfLayers {
                    // Calculate scale for this layer (from 1.0 to innerScale)
                    let t = CGFloat(i) / CGFloat(numberOfLayers - 1)
                    let scale = 1.0 - (t * (1.0 - innerScale))

                    // Calculate opacity (decrease as we go inward)
                    let opacity = 1.0 - t  // From 1.0 to 0.0

                    // Create scaled path
                    var layerPath = basePath
                    let scaleTransform = CGAffineTransform(translationX: center.x, y: center.y)
                        .scaledBy(x: scale, y: scale)
                        .translatedBy(x: -center.x, y: -center.y)
                    layerPath = layerPath.applying(scaleTransform)

                    // Stroke with green at calculated opacity
                    context.stroke(layerPath, with: .color(.green.opacity(opacity)), lineWidth: 2)
                }
            }
        }
    }

    private func calculateRadii(at time: Double) -> [CGFloat] {
        return (0..<numberOfPoints).map { i in
            let phase = phaseOffsets[i]
            let frequency = frequencies[i]
            let wave = sin(time * animationSpeed * frequency + phase)
            return 1.0 + (wave * maxDelta)
        }
    }
}

extension BioAgeBubble {
    func createSmoothPath(center: CGPoint, radii: [CGFloat]) -> Path {
        let points = calculatePoints(center: center, radii: radii)

        var path = Path()

        guard points.count > 2 else { return path }

        // Start at the first point
        path.move(to: points[0])

        // Create smooth curves through all points using Catmull-Rom-like approach
        for i in 0..<points.count {
            let p0 = points[(i - 1 + points.count) % points.count]
            let p1 = points[i]
            let p2 = points[(i + 1) % points.count]
            let p3 = points[(i + 2) % points.count]

            // Calculate control points for smooth curve
            let controlPoint1 = CGPoint(
                x: p1.x + (p2.x - p0.x) / 6.0,
                y: p1.y + (p2.y - p0.y) / 6.0
            )

            let controlPoint2 = CGPoint(
                x: p2.x - (p3.x - p1.x) / 6.0,
                y: p2.y - (p3.y - p1.y) / 6.0
            )

            path.addCurve(to: p2, control1: controlPoint1, control2: controlPoint2)
        }

        return path
    }
}

extension BioAgeBubble {
    func calculatePoints(center: CGPoint, radii: [CGFloat]) -> [CGPoint] {
        var points: [CGPoint] = []

        for i in 0..<radii.count {
            let angle = (CGFloat(i) / CGFloat(radii.count)) * 2 * .pi
            let radius = baseRadius * radii[i]
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius
            points.append(CGPoint(x: x, y: y))
        }

        return points
    }
}

#Preview {
    Group {
        BioAgeBubble()
    }
    .background(.black)
}
