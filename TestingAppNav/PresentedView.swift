import SwiftUI

struct PresentedView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isSearchFieldFocused: Bool
    
    @State private var searchText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("title")
                .ignoresSafeArea(.all)
                .padding(.top, 40)
                .padding(.horizontal, 20)
            
            Text("some")
                .background(.red)
                .padding(.horizontal, 20)
            
            Rectangle()
                .background(.blue)
        }
        .background(.orange)
        .presentationDetents([.height(150)])
    }
}

#Preview {
    PresentedView()
}
