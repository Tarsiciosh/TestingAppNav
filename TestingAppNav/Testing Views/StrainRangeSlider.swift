import SwiftUI

struct StrainRangeArcSlider: View {
    let value: Double
    let targetMin: Double
    let targetMax: Double

    private let minValue: Double = 0
    private let maxValue: Double = 100
    private let trackLineWidth: CGFloat = 5
    private let sweepAngle: Double = 120 // total arc sweep in degrees (< 180 for a shorter arc)

    // The frame height ratio relative to width.
    // Derived from: topMargin + arcVisibleHeight + bottomTextSpace
    // where topMargin = 0.068w, arcVisibleHeight ≈ 0.231w, bottomTextSpace = 0.20w
    // Total ≈ 0.499w. We use 0.50 for a clean value.
    private let heightRatio: CGFloat = 0.50

    var body: some View {
        let arcPadding: CGFloat = 44
        let screenWidth = UIScreen.main.bounds.width
        
        VStack(spacing: 0) {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                // Calculate radius so the arc endpoints reach the view edges
                let endAngleRad = CGFloat((90.0 - sweepAngle / 2.0) * .pi / 180.0)
                let cosEnd = cos(endAngleRad)
                let sinEnd = sin(endAngleRad)
                let radius = cosEnd > 0 ? (width / 2 - arcPadding) / cosEnd : (width - arcPadding * 2) / 2

                // Space above the arc top for the value label + thumb
                let topMargin: CGFloat = width * 0.068
                // Arc center is placed so the arc top sits at topMargin
                // arc top = centerY - radius, so centerY = topMargin + radius
                let centerY = topMargin + radius
                let center = CGPoint(x: width / 2, y: centerY)

                // The arc endpoint level (bottom of visible arc)
                let arcBottomY = centerY - radius * sinEnd
                // Position text just below the arc endpoints
                let textCenterY = arcBottomY - width * 0.02

                ZStack {
                    // Background arc track
                    SemiArc(
                        center: center, radius: radius,
                        startDegrees: angleDegreesFor(value: minValue),
                        endDegrees: angleDegreesFor(value: maxValue)
                    )
                    .stroke(Color.white.opacity(0.3), style: StrokeStyle(lineWidth: trackLineWidth, lineCap: .round))

                    // Target range highlighted arc
                    SemiArc(
                        center: center, radius: radius,
                        startDegrees: angleDegreesFor(value: targetMin),
                        endDegrees: angleDegreesFor(value: targetMax)
                    )
                    .stroke(Color.white, style: StrokeStyle(lineWidth: trackLineWidth, lineCap: .round))

                    // Label: targetMin
                    let minPos = pointOnArc(center: center, radius: radius - 22, degrees: angleDegreesFor(value: targetMin))
                    Text("\(Int(targetMin))")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.white.opacity(0.5))
                        .position(minPos)

                    // Label: targetMax
                    let maxPos = pointOnArc(center: center, radius: radius - 22, degrees: angleDegreesFor(value: targetMax))
                    Text("\(Int(targetMax))")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.white.opacity(0.5))
                        .position(maxPos)

                    // Value label (outside the arc)
                    let valueDeg = angleDegreesFor(value: value)
                    let valueLabelPos = pointOnArc(center: center, radius: radius + 20, degrees: valueDeg)
                    Text("\(Int(value))")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.white)
                        .position(valueLabelPos)

                    // Thumb glow
                    let thumbPos = pointOnArc(center: center, radius: radius, degrees: valueDeg)
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 34, height: 34)
                        .position(thumbPos)

                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 24, height: 24)
                        .position(thumbPos)

                    // Thumb
                    Circle()
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.5), radius: 4)
                        .frame(width: 12, height: 12)
                        .position(thumbPos)

                    // Center text underneath the arc
                    VStack(spacing: 4) {
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text("\(Int(targetMin))-\(Int(targetMax))")
                                .font(.custom("Nunito-SemiBold", size: width * 0.0909)) //40
                                .foregroundColor(.white)
                            Text("%")
                                .font(.custom("Poppins-Regular", size: width * 0.0909)) //40
                                .foregroundColor(.white.opacity(0.7))
                        }
                        Text("TARGET STRAIN")
                            .font(.custom("Poppins-Regular", size: width * 0.0318)) //14
                            .foregroundColor(.white)
                            .tracking(2)
                    }
                    .position(x: width / 2, y: textCenterY)
                }
            }
            .frame(height: screenWidth * heightRatio)
        }
        .background(.red)
    }

    /// Maps a value (0–100) to an angle in degrees.
    /// The arc is centered at 90° (top) and spans `sweepAngle` degrees.
    private func angleDegreesFor(value: Double) -> Double {
        let clamped = min(max(value, minValue), maxValue)
        let ratio = (clamped - minValue) / (maxValue - minValue)
        let arcStart = 90.0 + sweepAngle / 2.0 // left end
        return arcStart - ratio * sweepAngle
    }

    private func pointOnArc(center: CGPoint, radius: CGFloat, degrees: Double) -> CGPoint {
        let rad = CGFloat(degrees * .pi / 180.0)
        return CGPoint(
            x: center.x + radius * cos(rad),
            y: center.y - radius * sin(rad)
        )
    }
}

/// A semicircular arc shape. Angles are in the "math" convention:
/// 0° = right, 90° = top, 180° = left.
struct SemiArc: Shape {
    let center: CGPoint
    let radius: CGFloat
    let startDegrees: Double
    let endDegrees: Double

    func path(in rect: CGRect) -> Path {
        // Convert from math convention (CCW, 0°=right, 90°=up)
        // to SwiftUI convention (CW, 0°=right, 90°=down)
        let swStart = Angle.degrees(-startDegrees)
        let swEnd = Angle.degrees(-endDegrees)
        var path = Path()
        path.addArc(
            center: center,
            radius: radius,
            startAngle: swStart,
            endAngle: swEnd,
            clockwise: false
        )
        return path
    }
}


#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        StrainRangeArcSlider(value: 50, targetMin: 10, targetMax: 60)
    }
}
