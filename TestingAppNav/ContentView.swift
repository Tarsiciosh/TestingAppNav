//
//  ContentView.swift
//  TestingAppNav
//
//  Created by Tarsicio Spraggon Hernández on 30/10/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("hello")
    }
}

#Preview {
    ContentView()
}


/*
 VStack {
     Image(systemName: "globe")
         .imageScale(.large)
         .foregroundStyle(.tint)
     
     Text("Hello, world!")
     
     HStack {
         Text("Test")
         
         Spacer()
         
         Gauge(value: 20, in: 0...100) {
         }
         .gaugeStyle(.accessoryCircularCapacity)
         .tint(Color.green)
         .scaleEffect(0.4)
         .frame(width: 24, height: 24)
         .background(.red)
     }
     
    
     
     Button("open", action: { showPresented = true })
 }
 
 private let sideProportion: CGFloat = 0.5
 private let centerProportion: CGFloat = 1.0
 
 let trackHeight: CGFloat = 14.0
 
 var score: Double? = nil
 
 let greenGradient = LinearGradient(
     colors: [Color.green.opacity(0.4), Color.green],
     startPoint: .leading,
     endPoint: .trailing
 )

 let redGradient = LinearGradient(
     colors: [Color.red.opacity(0.4), Color.red],
     startPoint: .leading,
     endPoint: .trailing
 )


GeometryReader { geo in
    let totalProportions = sideProportion + centerProportion + sideProportion
    let spacing: CGFloat = 8
    let totalSpacing = spacing * 2
    let availableWidth = geo.size.width - totalSpacing
    let unitWidth = availableWidth / totalProportions
    
    let middleOffset = geo.size.width / 2
    let middleMarker = trackHeight / 2
    
    let pill1Low = middleMarker - middleOffset
    let pill1High = (unitWidth * sideProportion) - middleMarker - middleOffset
    let pill2Low = (unitWidth * sideProportion) + spacing + middleMarker - middleOffset
    let pill2High = (unitWidth * sideProportion) + spacing + (unitWidth * centerProportion) - middleMarker - middleOffset
    let pill3Low = (unitWidth * sideProportion) + spacing + (unitWidth * centerProportion) + spacing + middleMarker - middleOffset
    let pill3High = middleOffset - middleMarker

    ZStack {
        // background track
        HStack(spacing: spacing) {
            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(width: unitWidth * sideProportion)
            
            Capsule()
                .fill(greenGradient/*Color.gray.opacity(0.5)*/)
                .frame(width: unitWidth * centerProportion)
            
            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(width: unitWidth * sideProportion)
        }
        .frame(height: trackHeight)
        
        // marker
        ZStack(alignment: .center) {
            Circle()
                .fill(Color.black.opacity(0.05))
                .frame(width: 30, height: 30)
            
            Circle()
                .fill(Color.black.opacity(0.1))
                .frame(width: 22, height: 22)
            
            Circle()
                .fill(Color.white.opacity(1))
                .frame(width: trackHeight, height: 22)
            
            Circle()
                .fill(Color.green.opacity(1))
                .frame(width: trackHeight, height: 8)
        }
        .offset(x: pill3High)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
.frame(height: 30)
 
 
 
 
 
 
 
 
 //STRAIN RANGE
 
 var body: some View {
     ZStack {
         StrainRangeArcSlider(value: 20, targetMin: 10, targetMax: 30)
             .background(.blue)
     }
     .frame(maxWidth: .infinity, maxHeight: .infinity)
     .background(.black)
     .ignoresSafeArea()
 }
 
 struct StrainRangeArcSlider: View {
     let value: Double
     let targetMin: Double
     let targetMax: Double

     private let minValue: Double = 0
     private let maxValue: Double = 100
     private let trackLineWidth: CGFloat = 5
     private let sweepAngle: Double = 120 // total arc sweep in degrees (< 180 for a shorter arc)

     var body: some View {
         let arcPadding: CGFloat = 42
         VStack(spacing: 0) {
             GeometryReader { geometry in
                 let width = geometry.size.width
                 // Calculate radius so the arc endpoints reach the view edges
                 // The endpoint x-offset from center is radius * cos(endAngle)
                 // where endAngle = (90 - sweepAngle/2) degrees
                 let endAngleRad = CGFloat((90.0 - sweepAngle / 2.0) * .pi / 180.0)
                 let cosEnd = cos(endAngleRad)
                 let radius = cosEnd > 0 ? (width / 2 - arcPadding) / cosEnd : (width - arcPadding * 2) / 2
                 
                 let shift = width * 0.136
                 
                 let center = CGPoint(x: width / 2, y: geometry.size.height + shift)

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
                         .foregroundColor(.white)
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
                                 .font(.custom("Nunito-SemiBold", size: 40))
                                 .foregroundColor(.white)
                             Text("%")
                                 .font(.custom("Poppins-Regular", size: 40))
                                 .foregroundColor(.white.opacity(0.7))
                         }
                         Text("TARGET STRAIN")
                             .font(.custom("Poppins-Regular", size: 14))
                             .foregroundColor(.white)
                             .tracking(2)
                     }
                     .position(x: width / 2, y: 90)
                 }
             }
             .frame(height: 150)
         }
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
*/
