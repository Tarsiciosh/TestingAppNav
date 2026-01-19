//
//  ContentView.swift
//  TestingAppNav
//
//  Created by Tarsicio Spraggon Hernández on 30/10/2025.
//

import SwiftUI

struct ContentView: View {
    @State var showPresented: Bool = false
    
    var body: some View {
        //DynamicBubble()
        
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
//        .padding()
//        .sheet(isPresented: $showPresented) {
//            PresentedView()
//        }
    }
}

#Preview {
    ContentView()
}


