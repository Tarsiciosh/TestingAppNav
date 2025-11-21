import SwiftUI

struct MiniBubbleConfig {
    let phaseX: Double
    let phaseY: Double
    let frequencyX: Double
    let frequencyY: Double
    let sizePhase: Double
    let sizeFrequency: Double
    let baseSize: Double
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

    let miniBubbles: [MiniBubbleConfig] = [
        MiniBubbleConfig(phaseX: 3.50, phaseY: 1.75, frequencyX: 0.03, frequencyY: 0.7, sizePhase: 2.1, sizeFrequency: 1.0, baseSize: 2.4, color: .green),
        MiniBubbleConfig(phaseX: 3.29, phaseY: 2.36, frequencyX: 0.02, frequencyY: 0.5, sizePhase: 1.0, sizeFrequency: 1.3, baseSize: 1.8, color: .green),
        MiniBubbleConfig(phaseX: 2.87, phaseY: 2.91, frequencyX: 0.05, frequencyY: 0.6, sizePhase: 2.7, sizeFrequency: 0.9, baseSize: 3.1, color: .green),
        MiniBubbleConfig(phaseX: 2.27, phaseY: 3.30, frequencyX: 0.01, frequencyY: 0.4, sizePhase: 0.9, sizeFrequency: 1.4, baseSize: 2.0, color: .green),
        MiniBubbleConfig(phaseX: 1.55, phaseY: 3.49, frequencyX: 0.04, frequencyY: 0.8, sizePhase: 3.0, sizeFrequency: 1.2, baseSize: 1.6, color: .green),
        MiniBubbleConfig(phaseX: 0.82, phaseY: 3.45, frequencyX: 0.02, frequencyY: 0.3, sizePhase: 2.4, sizeFrequency: 1.5, baseSize: 2.8, color: .green),
        MiniBubbleConfig(phaseX: 0.19, phaseY: 3.18, frequencyX: 0.06, frequencyY: 0.9, sizePhase: 1.3, sizeFrequency: 1.1, baseSize: 1.3, color: .green),
        MiniBubbleConfig(phaseX: 0.00, phaseY: 2.70, frequencyX: 0.03, frequencyY: 0.6, sizePhase: 2.8, sizeFrequency: 1.4, baseSize: 3.3, color: .green),
        MiniBubbleConfig(phaseX: 0.12, phaseY: 2.10, frequencyX: 0.07, frequencyY: 0.5, sizePhase: 0.7, sizeFrequency: 1.0, baseSize: 2.1, color: .green),
        MiniBubbleConfig(phaseX: 0.53, phaseY: 1.55, frequencyX: 0.02, frequencyY: 0.7, sizePhase: 3.1, sizeFrequency: 1.3, baseSize: 2.6, color: .green),

        MiniBubbleConfig(phaseX: 1.11, phaseY: 1.16, frequencyX: 0.05, frequencyY: 0.4, sizePhase: 1.8, sizeFrequency: 0.9, baseSize: 1.7, color: .green),
        MiniBubbleConfig(phaseX: 1.80, phaseY: 0.97, frequencyX: 0.03, frequencyY: 0.8, sizePhase: 2.3, sizeFrequency: 1.2, baseSize: 2.9, color: .green),
        MiniBubbleConfig(phaseX: 2.50, phaseY: 1.00, frequencyX: 0.01, frequencyY: 0.6, sizePhase: 3.2, sizeFrequency: 1.5, baseSize: 3.4, color: .green),
        MiniBubbleConfig(phaseX: 3.10, phaseY: 1.28, frequencyX: 0.06, frequencyY: 0.7, sizePhase: 1.2, sizeFrequency: 1.0, baseSize: 1.4, color: .green),
        MiniBubbleConfig(phaseX: 3.47, phaseY: 1.76, frequencyX: 0.04, frequencyY: 0.9, sizePhase: 2.9, sizeFrequency: 1.4, baseSize: 2.2, color: .green),
        MiniBubbleConfig(phaseX: 3.58, phaseY: 2.35, frequencyX: 0.03, frequencyY: 0.3, sizePhase: 1.7, sizeFrequency: 1.1, baseSize: 1.2, color: .green),
        MiniBubbleConfig(phaseX: 3.41, phaseY: 2.94, frequencyX: 0.05, frequencyY: 0.8, sizePhase: 2.1, sizeFrequency: 1.4, baseSize: 2.7, color: .green),
        MiniBubbleConfig(phaseX: 3.00, phaseY: 3.40, frequencyX: 0.02, frequencyY: 0.5, sizePhase: 3.0, sizeFrequency: 0.7, baseSize: 1.9, color: .green),
        MiniBubbleConfig(phaseX: 2.39, phaseY: 3.67, frequencyX: 0.07, frequencyY: 0.2, sizePhase: 1.4, sizeFrequency: 1.2, baseSize: 3.2, color: .green)
    ]

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
                    let (position, bubbleSize, opacity) = calculateMiniBubbleValues(
                        at: currentTime,
                        config: config,
                        center: center
                    )
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
        let angle = time * animationSpeed * config.frequencyX + config.phaseX
        
        // Radius varies smoothly between min and max using sin wave
        let radiusRange = miniBubbleMaxRadius - miniBubbleMinRadius
        let radiusNormalized = 0.5 + 0.5 * sin(time * animationSpeed * config.frequencyY + config.phaseY)
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
