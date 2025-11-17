import SwiftUI

struct PresentedView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isSearchFieldFocused: Bool
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("some")
                        .background(.red)
                        .padding(.horizontal, 20)

                    Rectangle()
                        .background(.blue)
                }
            }
            .navigationTitle("Title")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {

            }
            .onAppear {
                configureNavigationBarAppearance()
            }
        }
        //.background(.orange)
        //.presentationDetents([.height(150)])
    }

    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()

        // Customize large title font
        appearance.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 34, weight: .bold),
            .foregroundColor: UIColor.label
        ]

        // Customize inline (collapsed) title font
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            .foregroundColor: UIColor.label
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}

#Preview {
    PresentedView()
}
