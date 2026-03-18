import SwiftUI

struct ProgressCircle<Content: View>: View {
    let percentage: Double?
    var progressColor: Color = .green
    var progressGradient: AngularGradient? = nil
    var trackColor: Color = .gray
    var lineWidth: CGFloat = 8
    var endColor: Color = .green
    @ViewBuilder var content: () -> Content

    private var progress: Double {
        min((percentage ?? 0) / 100, 1.0)
    }

    var body: some View {
        ZStack {
            // Track
            Circle()
                .stroke(trackColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))

            // Progress
            if let percentage = percentage, percentage > 0 {
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        progressGradient ?? AngularGradient(
                            colors: [progressColor],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))

                // When at 100%, cover the start cap with the end color
                // so the gradient appears seamlessly rounded at the junction.
                if progress > 0.985 {
                    Circle()
                        .trim(from: 0, to: 0.001)
                        .stroke(endColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                        .rotationEffect(.degrees(-93))
                }
            }

            // Content
            content()
        }
    }
}

#Preview {
    ProgressCircle(
        percentage: 100,
        progressGradient: AngularGradient(
            stops: [
                .init(color: Color(.blue), location: 0.0),
                .init(color: Color(.green), location: 0.33),
                .init(color: Color(.orange), location: 0.66),
                .init(color: Color(.red), location: 1.0)
            ],
            center: .center,
            startAngle: .degrees(-3),
            endAngle: .degrees(357)
        ),
        endColor: Color(.red)
    ) {
        Text("hello")
    }
    .frame(width: 180)
}
