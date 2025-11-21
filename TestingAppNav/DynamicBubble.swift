import SwiftUI

struct MiniBubbleConfig {
    let baseSize: Double
    let frequencyAlpha: Double
    let phaseAlpha: Double
    let frequencyRho: Double
    let phaseRho: Double
    let sizeFrequency: Double
    let sizePhase: Double
    let color: Color
}

struct DynamicBubble: View {
    var mainColor: Color = Color.green

    @State private var time: Double = 0
    var maxDelta: CGFloat = 0.03
    var animationSpeed: Double = 1.5
    let baseRadius: CGFloat = 100

    // Mini bubble constraints
    var miniBubbleMinRadius: CGFloat { baseRadius * 0.8 }
    var miniBubbleMaxRadius: CGFloat { baseRadius * 0.9 }

    var miniBubbles: [MiniBubbleConfig] { [
        MiniBubbleConfig(baseSize: 2.4, frequencyAlpha: 0.003, phaseAlpha: 0.00, frequencyRho: 0.7, phaseRho: 1.75, sizeFrequency: 1.0, sizePhase: 2.1, color: mainColor),
        MiniBubbleConfig(baseSize: 1.8, frequencyAlpha: 0.002, phaseAlpha: 0.31, frequencyRho: 0.5, phaseRho: 2.36, sizeFrequency: 1.3, sizePhase: 1.0, color: mainColor),
        MiniBubbleConfig(baseSize: 3.1, frequencyAlpha: 0.005, phaseAlpha: 0.62, frequencyRho: 0.6, phaseRho: 2.91, sizeFrequency: 0.9, sizePhase: 2.7, color: mainColor),
        MiniBubbleConfig(baseSize: 2.0, frequencyAlpha: 0.001, phaseAlpha: 0.94, frequencyRho: 0.4, phaseRho: 3.30, sizeFrequency: 1.4, sizePhase: 0.9, color: mainColor),
        MiniBubbleConfig(baseSize: 1.6, frequencyAlpha: 0.004, phaseAlpha: 1.25, frequencyRho: 0.8, phaseRho: 3.49, sizeFrequency: 1.2, sizePhase: 3.0, color: mainColor),
        MiniBubbleConfig(baseSize: 2.8, frequencyAlpha: 0.002, phaseAlpha: 1.57, frequencyRho: 0.3, phaseRho: 3.45, sizeFrequency: 1.5, sizePhase: 2.4, color: mainColor),
        MiniBubbleConfig(baseSize: 1.3, frequencyAlpha: 0.006, phaseAlpha: 1.88, frequencyRho: 0.9, phaseRho: 3.18, sizeFrequency: 1.1, sizePhase: 1.3, color: mainColor),
        MiniBubbleConfig(baseSize: 3.3, frequencyAlpha: 0.003, phaseAlpha: 2.19, frequencyRho: 0.6, phaseRho: 2.70, sizeFrequency: 1.4, sizePhase: 2.8, color: mainColor),
        MiniBubbleConfig(baseSize: 2.1, frequencyAlpha: 0.007, phaseAlpha: 2.51, frequencyRho: 0.5, phaseRho: 2.10, sizeFrequency: 1.0, sizePhase: 0.7, color: mainColor),
        MiniBubbleConfig(baseSize: 2.6, frequencyAlpha: 0.002, phaseAlpha: 2.82, frequencyRho: 0.7, phaseRho: 1.55, sizeFrequency: 1.3, sizePhase: 3.1, color: mainColor),
        MiniBubbleConfig(baseSize: 1.7, frequencyAlpha: 0.005, phaseAlpha: 3.14, frequencyRho: 0.4, phaseRho: 1.16, sizeFrequency: 0.9, sizePhase: 1.8, color: mainColor),
        MiniBubbleConfig(baseSize: 2.9, frequencyAlpha: 0.003, phaseAlpha: 3.45, frequencyRho: 0.8, phaseRho: 0.97, sizeFrequency: 1.2, sizePhase: 2.3, color: mainColor),
        MiniBubbleConfig(baseSize: 3.4, frequencyAlpha: 0.001, phaseAlpha: 3.76, frequencyRho: 0.6, phaseRho: 1.00, sizeFrequency: 1.5, sizePhase: 3.2, color: mainColor),
        MiniBubbleConfig(baseSize: 1.4, frequencyAlpha: 0.006, phaseAlpha: 4.08, frequencyRho: 0.7, phaseRho: 1.28, sizeFrequency: 1.0, sizePhase: 1.2, color: mainColor),
        MiniBubbleConfig(baseSize: 2.2, frequencyAlpha: 0.004, phaseAlpha: 4.39, frequencyRho: 0.9, phaseRho: 1.76, sizeFrequency: 1.4, sizePhase: 2.9, color: mainColor),
        MiniBubbleConfig(baseSize: 1.2, frequencyAlpha: 0.003, phaseAlpha: 4.71, frequencyRho: 0.3, phaseRho: 2.35, sizeFrequency: 1.1, sizePhase: 1.7, color: mainColor),
        MiniBubbleConfig(baseSize: 2.7, frequencyAlpha: 0.005, phaseAlpha: 5.02, frequencyRho: 0.8, phaseRho: 2.94, sizeFrequency: 1.4, sizePhase: 2.1, color: mainColor),
        MiniBubbleConfig(baseSize: 1.9, frequencyAlpha: 0.002, phaseAlpha: 5.34, frequencyRho: 0.5, phaseRho: 3.40, sizeFrequency: 0.7, sizePhase: 3.0, color: mainColor),
        MiniBubbleConfig(baseSize: 3.2, frequencyAlpha: 0.007, phaseAlpha: 5.65, frequencyRho: 0.2, phaseRho: 3.67, sizeFrequency: 1.2, sizePhase: 1.4, color: mainColor),
        MiniBubbleConfig(baseSize: 1.2, frequencyAlpha: 0.005, phaseAlpha: 6.20, frequencyRho: 0.5, phaseRho: 2.67, sizeFrequency: 2.2, sizePhase: 1.2, color: mainColor)
    ]}

    // Random phase offsets for each point to create organic movement
    let phaseOffsets: [Double] = [0, 1.2, 2.5, 0.8, 3.1, 1.7, 2.9]
    let frequencies: [Double] = [1.0, 1.3, 0.9, 1.1, 0.85, 1.15, 0.95]

    var numberOfPoints: Int { phaseOffsets.count }

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)

                let currentRadii = calculateRadii(at: timeline.date.timeIntervalSinceReferenceDate)

                let outerPath = createSmoothPath(center: center, radii: currentRadii)

                let innerScale: CGFloat = 0.6

                // Calculate mean radius
                let meanRadius = currentRadii.reduce(0, +) / CGFloat(currentRadii.count)
                let dynamicStartRadius = baseRadius * meanRadius * innerScale

                // Add smooth random variation using time-based noise
                let time = timeline.date.timeIntervalSinceReferenceDate
                let randomVariation1 = sin(time * 2.5) * 2  // Smooth oscillation for inner radius

                let gradient = Gradient(colors: [
                    mainColor.opacity(0),
                    mainColor.opacity(0.2),
                    mainColor.opacity(0.5),
                    mainColor.opacity(0.8)
                ])

                context.fill(outerPath, with: .radialGradient(
                    gradient,
                    center: center,
                    startRadius: dynamicStartRadius + randomVariation1,
                    endRadius: baseRadius * meanRadius
                ))
                
                context.stroke(outerPath, with: .color(mainColor), lineWidth: 2)

                // Draw all mini bubbles
                let currentTime = timeline.date.timeIntervalSinceReferenceDate
                for config in miniBubbles {
                    let (position, bubbleSize, opacity) = calculateMiniBubbleValues(at: currentTime, config: config, center: center)
                    addMiniBubbleIn(context: context, position: position, size: bubbleSize, color: config.color, opacity: opacity)
                }
            }
        }
    }
}

extension DynamicBubble {
    func addMiniBubbleIn(context: GraphicsContext, position: CGPoint, size: Double, color: Color, opacity: Double) {
        var bubblePath = Path()
        // Center the bubble at position (not offset by size)
        let rect = CGRect(
            x: position.x - size / 2,
            y: position.y - size / 2,
            width: size,
            height: size
        )
        bubblePath.addEllipse(in: rect)
        context.fill(bubblePath, with: .color(color.opacity(opacity)))
    }

    func calculateMiniBubbleValues(at time: Double, config: MiniBubbleConfig, center: CGPoint) -> (CGPoint, Double, Double) {
        // Continuous forward angle movement (always increasing)
        let angle = time * animationSpeed * config.frequencyAlpha + config.phaseAlpha
        
        // Radius varies smoothly between min and max using sin wave
        let radiusRange = miniBubbleMaxRadius - miniBubbleMinRadius
        let radiusNormalized = 0.5 + 0.5 * sin(time * animationSpeed * config.frequencyRho + config.phaseRho)
        let radius = miniBubbleMinRadius + (CGFloat(radiusNormalized) * radiusRange)
        
        // Calculate final position relative to center
        let position = CGPoint(
            x: center.x + CGFloat(cos(angle)) * radius,
            y: center.y + CGFloat(sin(angle)) * radius
        )
        
        // Calculate size with pulsing effect
        let sizeMultiplier = 0.5 + 0.5 * sin(time * animationSpeed * config.sizeFrequency + config.sizePhase)
        let size = config.baseSize * (0.5 + sizeMultiplier)
        
        // Calculate opacity (always visible but varies)
        let opacity = 0.4 + 0.2 * sizeMultiplier
        
        return (position, size, opacity)
    }
}

extension DynamicBubble {
    private func calculateRadii(at time: Double) -> [CGFloat] {
        return (0..<numberOfPoints).map { i in
            let phase = phaseOffsets[i]
            let frequency = frequencies[i]
            let wave = sin(time * animationSpeed * frequency + phase)
            return 1.0 + (wave * maxDelta)
        }
    }
}

extension DynamicBubble {
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

extension DynamicBubble {
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

extension Path {
    func with(scale: Double, center: CGPoint) -> Path {
        let scaleTransform = CGAffineTransform(translationX: center.x, y: center.y)
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: -center.x, y: -center.y)
        return self.applying(scaleTransform)
    }
}

#Preview {
    Group {
        DynamicBubble()
    }
    .background(.black)
}



/*
 struct BioAgeBubble: View {
     var mainColor: Color = Color.green
    
     @State private var time: Double = 0
     var maxDelta: CGFloat = 0.03
     var animationSpeed: Double = 1.5
     let baseRadius: CGFloat = 100

     // Random phase offsets for each point to create organic movement
     let phaseOffsets: [Double] = [0, 1.2, 2.5, 0.8, 3.1, 1.7, 2.9]
     let frequencies: [Double] = [1.0, 1.3, 0.9, 1.1, 0.85, 1.15, 0.95]

     var numberOfPoints: Int { phaseOffsets.count }

     var body: some View {
         TimelineView(.animation) { timeline in
             Canvas { context, size in
                 let center = CGPoint(x: size.width / 2, y: size.height / 2)

                 let currentRadii = calculateRadii(at: timeline.date.timeIntervalSinceReferenceDate)

                 let outerPath = createSmoothPath(center: center, radii: currentRadii)

                 let innerScale: CGFloat = 0.6

                 // Calculate mean radius
                 let meanRadius = currentRadii.reduce(0, +) / CGFloat(currentRadii.count)
                 let dynamicStartRadius = baseRadius * meanRadius * innerScale

                 // Add smooth random variation using time-based noise
                 let time = timeline.date.timeIntervalSinceReferenceDate
                 let randomVariation1 = sin(time * 2.5) * 2  // Smooth oscillation for inner radius

                 let gradient = Gradient(colors: [
                     mainColor.opacity(0),
                     mainColor.opacity(0.2),
                     mainColor.opacity(0.5),
                     mainColor.opacity(0.8)
                 ])

                 context.fill(outerPath, with: .radialGradient(
                     gradient,
                     center: center,
                     startRadius: dynamicStartRadius + randomVariation1,
                     endRadius: baseRadius * meanRadius
                 ))
                 
                 context.stroke(outerPath, with: .color(mainColor), lineWidth: 2)
             }
         }
     }
 }
*/

/* INNER TO OUTER RINGS
 struct DynamicBubble: View {
     @State private var time: Double = 0
     var maxDelta: CGFloat = 0.04
     var animationSpeed: Double = 1.5
     let baseRadius: CGFloat = 80

     // Random phase offsets for each point to create organic movement
     let phaseOffsets: [Double] = [0, 1.2, 2.5, 0.8, 3.1, 1.7, 2.9]//, 0, 3.5, 1.2, 0.3, 1.7, 0.9, 3.1]
     let frequencies: [Double] = [1.0, 1.3, 0.9, 1.1, 0.85, 1.15, 0.95]//, 1.1, 0.8, 0.5, 1.3, 0.65, 1.3, 0.6]

     var numberOfPoints: Int { phaseOffsets.count }
     
     var outerRingColor: Color { Color(red: 0.2, green: 1.0, blue: 0.3) }

     var body: some View {
         TimelineView(.animation) { timeline in
             Canvas { context, size in
                 let center = CGPoint(x: size.width / 2, y: size.height / 2)

                 // Calculate current radii based on time
                 let currentRadii = calculateRadii(at: timeline.date.timeIntervalSinceReferenceDate)

                 // Create base path
                 let basePath = createSmoothPath(center: center, radii: currentRadii)

                 let innerScale: CGFloat = 0.5
                 let lineWidth: CGFloat = 2

                 // Calculate number of layers based on ring width and line width
                 let ringWidth = baseRadius * (1.0 - innerScale)
                 let numberOfLayers = Int(ceil(ringWidth / lineWidth * 1.01))  //multiplier for overlap
                 for i in 0..<numberOfLayers {
                     // Calculate scale for this layer (from 1.0 to innerScale)
                     let t = CGFloat(i) / CGFloat(numberOfLayers)
                     let scale = 1.0 - (t * (1.0 - innerScale))

                     // Calculate opacity (decrease as we go inward)
                     let opacity = 1 - t  // From 1.0 to 0.0

                     // Create scaled path
                     let layerPath = basePath.with(scale: scale, center: center)

                     // Stroke with green at calculated opacity
                     context.stroke(layerPath, with: .color(.green.opacity(opacity)), lineWidth: lineWidth)
                 }
                 
                 let outerPath = basePath.with(scale: 1, center: center)
                 context.stroke(outerPath, with: .color(outerRingColor), lineWidth: lineWidth)
             }
         }
     }
 }
 */

/*
 let miniBubbles = [
     MiniBubbleConfig(phaseX: 0.0, phaseY: 1.5, frequencyX: 0.01, frequencyY: 0.1, sizePhase: 0.0, sizeFrequency: 1.3, baseSize: 3, color: .green),
     MiniBubbleConfig(phaseX: 2.1, phaseY: 0.3, frequencyX: 0.01, frequencyY: 0.7, sizePhase: 1.2, sizeFrequency: 0.9, baseSize: 2.2, color: .green),
     MiniBubbleConfig(phaseX: 1.0, phaseY: 2.8, frequencyX: 0.06, frequencyY: 0.4, sizePhase: 2.5, sizeFrequency: 1.1, baseSize: 3.2, color: .green),
     MiniBubbleConfig(phaseX: 3.5, phaseY: 1.2, frequencyX: 0.02, frequencyY: 0.9, sizePhase: 0.8, sizeFrequency: 1.5, baseSize: 2, color: .green),
     MiniBubbleConfig(phaseX: 0.7, phaseY: 3.2, frequencyX: 0.05, frequencyY: 0.3, sizePhase: 3.1, sizeFrequency: 0.7, baseSize: 1, color: .green),
     MiniBubbleConfig(phaseX: 0.3, phaseY: 1.5, frequencyX: 0.03, frequencyY: 0.1, sizePhase: 0.0, sizeFrequency: 1.3, baseSize: 1.5, color: .green),
     MiniBubbleConfig(phaseX: 1.3, phaseY: 0.3, frequencyX: 0.08, frequencyY: 0.7, sizePhase: 1.2, sizeFrequency: 0.9, baseSize: 3.1, color: .green),
     MiniBubbleConfig(phaseX: 2.4, phaseY: 2.8, frequencyX: 0.03, frequencyY: 0.4, sizePhase: 2.5, sizeFrequency: 1.1, baseSize: 3.5, color: .green),
     MiniBubbleConfig(phaseX: 3.1, phaseY: 1.2, frequencyX: 0.01, frequencyY: 0.9, sizePhase: 0.8, sizeFrequency: 1.5, baseSize: 2, color: .green),
     MiniBubbleConfig(phaseX: 2.7, phaseY: 3.2, frequencyX: 0.04, frequencyY: 0.3, sizePhase: 3.1, sizeFrequency: 0.7, baseSize: 1, color: .green),
 ]
*/
