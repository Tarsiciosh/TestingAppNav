import SwiftUI

public enum DateRangeType: Int {
    case day
    case week
    case month
    case threeMonths
    case sixMonths
    case year
    case yearToDate
    case allTime
    case custom
}

extension DateRangeType {
    var smallVersion: String {
        switch self {
        case .day: "1D"
        case .week: "1W"
        case .month: "1M"
        case .threeMonths: "3M"
        case .sixMonths: "6M"
        case .year: "1Y"
        case .yearToDate: "YTD"
        case .allTime: "All time"
        case .custom: "Custom"
        }
    }
}

struct TrendTopChooserView: View {
    var onRangeChanged: @MainActor (DateRangeType) -> Void = { _ in }
    var onCalendarTapped: @MainActor () -> Void = {}
    
    //internal
    var ranges: [DateRangeType] = [.week, .month, .year, .allTime]
    @State private var selectedRange: DateRangeType = .week
    
    var body: some View {
        HStack(spacing: 8) {
            // Date range selector
            dateRangeSelector
                .padding(.vertical, 4)
                .padding(.horizontal, 4)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                )

            // Calendar button
            Button {
                onCalendarTapped()
            } label: {
                Image(systemName: "calendar")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                    )
            }
        }
        .padding(.vertical, 20)
    }

    private var dateRangeSelector: some View {
        HStack(spacing: 0) {
            ForEach(Array(ranges.enumerated()), id: \.element) { index, range in
                if index > 0 {
                    divider(leftRange: ranges[index - 1], rightRange: range)
                }

                Button {
                    selectedRange = range
                    onRangeChanged(range)
                } label: {
                    Text(range.smallVersion)
                        
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .background(
                            Group {
                                if selectedRange == range {
                                    Capsule()
                                        .fill(Color.white.opacity(0.1))
                                }
                            }
                            .frame(height: 48)
                        )
                }
            }
        }
        .font(.custom("Nunito-SemiBold", size: 16))
        .minimumScaleFactor(0.5)
        .lineLimit(1)
        .frame(height: 50)
    }

    private func divider(leftRange: DateRangeType, rightRange: DateRangeType) -> some View {
        let visible = selectedRange != leftRange && selectedRange != rightRange
        return Rectangle()
            .fill(Color.white.opacity(visible ? 0.3 : 0))
            .frame(width: 1, height: 14)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        TrendTopChooserView()
            .padding(.horizontal)
    }
}

