import SwiftUI

enum TrendDateRange: String, CaseIterable, Identifiable {
    case oneWeek = "1W"
    case oneMonth = "1M"
    case oneYear = "1Y"
    case allTime = "All time"

    var id: String { rawValue }
}

struct TrendTopChooser: View {
    @State var selectedRange: TrendDateRange = .oneWeek

    var onRangeChanged: @MainActor (TrendDateRange) -> Void = { _ in }
    var onCalendarTapped: @MainActor () -> Void = {}

    var body: some View {
        HStack(spacing: 8) {
            // Date range selector
            dateRangeSelector
                .padding(.vertical, 4)
                .padding(.horizontal, 4)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                )

            // Calendar button
            Button {
                onCalendarTapped()
            } label: {
                Image(systemName: "calendar")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.1))
                    )
            }
        }
    }

    private var dateRangeSelector: some View {
        HStack(spacing: 0) {
            ForEach(Array(TrendDateRange.allCases.enumerated()), id: \.element.id) { index, range in
                if index > 0 {
                    divider(leftRange: TrendDateRange.allCases[index - 1], rightRange: range)
                }

                Button {
                    selectedRange = range
                    onRangeChanged(range)
                } label: {
                    Text(range.rawValue)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                        .background(
                            Group {
                                if selectedRange == range {
                                    Capsule()
                                        .fill(Color.white.opacity(0.2))
                                }
                            }
                        )
                }
            }
        }
        .font(.system(size: 15, weight: .medium))
        .minimumScaleFactor(0.5)
        .lineLimit(1)
    }

    @ViewBuilder
    private func divider(leftRange: TrendDateRange, rightRange: TrendDateRange) -> some View {
        if selectedRange != leftRange && selectedRange != rightRange {
            Rectangle()
                .fill(Color.white.opacity(0.3))
                .frame(width: 1, height: 14)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        TrendTopChooser()
            .padding(.horizontal)
    }
}

