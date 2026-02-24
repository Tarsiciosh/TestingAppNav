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

    var body: some View {
        GeometryReader { geo in
            let totalProportions = sideProportion + centerProportion + sideProportion
            let spacing: CGFloat = 8
            let totalSpacing = spacing * 2
            let availableWidth = geo.size.width - totalSpacing
            let unitWidth = availableWidth / totalProportions

            HStack(spacing: spacing) {
                Capsule()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: unitWidth * sideProportion)

                Capsule()
                    .fill(Color.green.opacity(0.6))
                    .overlay(alignment: .trailing) {
                        Circle()
                            .fill(Color.white)
                            .padding(4)
                            .overlay {
                                Circle()
                                    .strokeBorder(Color.gray, lineWidth: 3)
                                    .padding(7)
                            }
                    }
                    .frame(width: unitWidth * centerProportion)

                Capsule()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: unitWidth * sideProportion)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 44)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(white: 0.15))
        )
        .padding()
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
