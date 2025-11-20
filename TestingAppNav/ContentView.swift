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
        AgeBubble()
        
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//            
//            Button("open", action: { showPresented = true })
//        }
//        .padding()
//        .sheet(isPresented: $showPresented) {
//            PresentedView()
//        }
    }
}

#Preview {
    ContentView()
}
