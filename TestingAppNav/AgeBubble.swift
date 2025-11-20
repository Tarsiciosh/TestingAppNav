import SwiftUI

struct AgeBubble: View {
    let radii: [CGFloat]
    let baseRadius: CGFloat
    let numberOfPoints: Int

    init(radii: [CGFloat] = [1.0, 0.99, 1.05, 0.92, 1.06, 0.91, 1], baseRadius: CGFloat = 150) {
        self.radii = radii
        self.baseRadius = baseRadius
        self.numberOfPoints = radii.count
    }

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)

            // Draw the smooth blob shape
            let path = createSmoothPath(center: center)
            context.stroke(path, with: .color(.green), lineWidth: 2)
        }
        .frame(width: 400, height: 400)
    }

    private func calculatePoints(center: CGPoint) -> [CGPoint] {
        var points: [CGPoint] = []

        for i in 0..<numberOfPoints {
            let angle = (CGFloat(i) / CGFloat(numberOfPoints)) * 2 * .pi
            let radius = baseRadius * radii[i]
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius
            points.append(CGPoint(x: x, y: y))
        }

        return points
    }

    private func createSmoothPath(center: CGPoint) -> Path {
        let points = calculatePoints(center: center)

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

#Preview {
    AgeBubble()
}
