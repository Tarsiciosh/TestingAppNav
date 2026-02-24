//
//  ContentView.swift
//  TestingAppNav
//
//  Created by Tarsicio Spraggon Hernández on 30/10/2025.
//

import SwiftUI

struct ContentView: View {
    @State var showPresented: Bool = false
    
    private let sideProportion: CGFloat = 0.5
    private let centerProportion: CGFloat = 1.0
    
    let trackHeight: CGFloat = 14.0
    
    var score: Double? = nil

    var body: some View {
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
                        .fill(Color.gray.opacity(0.5))
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
 */
