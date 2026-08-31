//
//  FinanceStatisticsView.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 21/09/2026.
//

import SwiftUI
import SwiftData
import Charts
import Foundation

private enum StatisticsEntity: String, CaseIterable, Identifiable {
    case places = "Места"
    case visits = "Посещения"
    
    var id: Self { self }
}

private enum PlacesChartStyle: String, CaseIterable, Identifiable {
    case bar = "Столбцы"
    case donut = "Круг"
    
    var id: Self { self }
}

private enum VisitsChartStyle: String, CaseIterable, Identifiable {
    case bar = "Столбцы"
    case graph = "График"
    
    var id: Self { self }
}

private struct PlaceSpendingItem: Identifiable, Equatable {
    var id: String
    let name: String
    let totalAmount: Decimal
    let visitsCount: Int
    
    var chartAmount: Double {
        abs(NSDecimalNumber(decimal: totalAmount).doubleValue)
    }
}

private struct TimeSpendingItem: Identifiable, Equatable {
    let date: Date
    let totalAmount: Decimal
    
    var id: Date { date }
    
    var chartAmount: Double {
        abs(NSDecimalNumber(decimal: totalAmount).doubleValue)
    }
}

struct FinanceStatisticsView: View {
    @Query(sort: \ExpenseRecord.createdAt, order: .forward) private var records: [ExpenseRecord]
    
    @State private var selectedPeriod: FilterPeriod = .all
    @State private var selectedEntity: StatisticsEntity = .places
    @State private var placesChartStyle: PlacesChartStyle = .bar
    @State private var visitsChartStyle: VisitsChartStyle = .bar
    
    @State private var selectedBarPlaceName: String?
    @State private var selectedAngleValue: Double?
    
    // Computed property
    
    // records due to selected period
    private var filteredRecords: [ExpenseRecord] {
        records.filter {selectedPeriod.contains($0.createdAt)}
    }
    
    // total sum of expenses for selected period
    private var totalSpent: Decimal {
        filteredRecords.reduce(.zero) { $0 + $1.totalSpent }
    }
    
    // currency code from the last record
    private var currencyCode: String {
        filteredRecords.last?.currencyCode ?? "BYN"
    }
    
    // агрегированные траты по местам за выбранный период
    private var placeSpendings: [PlaceSpendingItem] {
        let grouped = Dictionary(grouping: filteredRecords) { record in
            record.place.map {
                String(describing: $0.persistentModelID)
            } ?? "Место не добавлено"
        }
        
        return grouped.compactMap { id, groupRecords in
            guard let firstRecord = groupRecords.first else { return nil }
            
            let name = firstRecord.place?.name ?? "Место не добавлено"
            
            let totalAmount = groupRecords.reduce(.zero) {
                $0 + $1.totalSpent
            }
            
            return PlaceSpendingItem(
                id: id,
                name: name,
                totalAmount: totalAmount,
                visitsCount: groupRecords.count
            )
        }
        .sorted { $0.chartAmount > $1.chartAmount}
    }
    
    private var totalChartAmount: Double {
        placeSpendings.reduce(.zero) {
            $0 + $1.chartAmount
        }
    }
    
    private var timeSpendings: [TimeSpendingItem] {
        let grouped = Dictionary(grouping: filteredRecords) { record in
            normalizedDate(for: record.createdAt)
        }
        
        return grouped.map { date, records in
            TimeSpendingItem(
                date: date,
                totalAmount: records.reduce(.zero) {
                    $0 + $1.totalSpent
                }
            )
        }
        .sorted {
            $0.date < $1.date
        }
    }
    
    private var selectedDonutItem: PlaceSpendingItem? {
        guard let selectedAngleValue, totalChartAmount > 0 else { return nil }
        
        var cumulativeValue: Double = 0
        
        for item in placeSpendings {
            cumulativeValue += item.chartAmount
            
            if selectedAngleValue <= cumulativeValue {
                return item
            }
        }
        
        return placeSpendings.last
    }
    
    private var visitsXDomain: ClosedRange<Date> {
        let calendar = Calendar.autoupdatingCurrent
        let now = Date()
        
        func lastMoment(of interval: DateInterval) -> Date {
            interval.end.addingTimeInterval(-1)
        }
        
        switch selectedPeriod {
        case .today:
            let start = calendar.startOfDay(for: now)
            let end = calendar.date(
                byAdding: .day,
                value: 1,
                to: start
            ) ?? now
            
            return start...end.addingTimeInterval(-1)
            
        case .week:
            guard let interval = calendar.dateInterval(
                of: .weekOfYear,
                for: now
            ) else {
                return now...now
            }
            
            return interval.start...lastMoment(of: interval)
            
        case .month:
            guard let interval = calendar.dateInterval(
                of: .month,
                for: now
            ) else {
                return now...now
            }
            
            return interval.start...lastMoment(of: interval)
            
        case .all:
            guard
                let firstDate = timeSpendings.first?.date,
                let lastDate = timeSpendings.first?.date,
                let firstMonth = calendar.dateInterval(of: .month, for: firstDate),
                let lastMonth = calendar.dateInterval(of: .month, for: lastDate)
                    else { return now...now }
            
            return firstMonth.start...lastMoment(of: lastMonth)
        }
    }
    
    private var visitsAxisValues: AxisMarkValues {
        let calendar = Calendar.autoupdatingCurrent
        
        switch selectedPeriod {
        case .today:
            return .stride(
                by: .hour,
                count: 2,
                roundLowerBound: true,
                roundUpperBound: true,
                calendar: calendar
            )
        case .week, .month:
            return .stride(
                by: .day,
                count: 1,
                roundLowerBound: true,
                roundUpperBound: true,
                calendar: calendar
            )
        case .all:
            return .stride(
                by: .month,
                count: 1,
                roundLowerBound: true,
                roundUpperBound: true,
                calendar: calendar
            )
        }
    }
    
    private var isVisitsChartScrollable: Bool {
        switch selectedPeriod {
        case .today, .month, .all:
            true
        case .week:
            false
        }
    }
    
    private var visibleVisitsDomainLength: TimeInterval {
        switch selectedPeriod {
        case .today:
            6 * 60 * 60
        case .week:
            7 * 24 * 60 * 60
        case .month:
            7 * 24 * 60 * 60
        case .all:
            31 * 24 * 60 * 60
        }
    }
    
    private var visitsScrollAlignment: DateComponents {
        switch selectedPeriod {
        case .today:
            DateComponents(minute: 0)
        case .week:
            DateComponents()
        case .month:
            DateComponents(hour: 0)
        case .all:
            DateComponents(day: 1)
        }
    }
    
    private var visitsBinUnit: Calendar.Component {
        switch selectedPeriod {
        case .today:
            .hour
        case .week, .month:
            .day
        case .all:
            .month
        }
    }
    
    private var visitsBarWidth: MarkDimension {
        switch selectedPeriod {
        case .today:
            .ratio(0.58)
        case .week, .month:
            .ratio(0.64)
        case .all:
            .ratio(0.72)
        }
    }
    
    private var shouldRotateVisitsAxisLabels: Bool {
        selectedPeriod == .month || selectedPeriod == .all
    }
    
    private var maxVisitsAmount: Double {
        let max = timeSpendings.map { $0.chartAmount }.max() ?? 100
        return max
    }

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                totalSpentHeader
                
                Picker("Тип отображения", selection: $selectedEntity) {
                    ForEach(StatisticsEntity.allCases) { entity in
                        Text(entity.rawValue).tag(entity)
                    }
                }
                .pickerStyle(.segmented)
                
                chartContainer
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
            .navigationTitle("Статистика")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Период", selection: $selectedPeriod) {
                            ForEach(FilterPeriod.allCases) { period in
                                Text(period.filterValue).tag(period)
                            }
                        }
                    } label: {
                        Image(systemName: "calendar")
                            .font(.title2)
                            .foregroundStyle(Color("AccentColor"))
                    }
                    .accessibilityLabel("Выбрать период")
                }
            }
            .onChange(of: selectedPeriod) {
                clearChartSelection()
            }
            .onChange(of: selectedEntity) {
                clearChartSelection()
            }
            .onChange(of: placesChartStyle) {
                clearChartSelection()
            }
            .animation(.smooth(duration: 0.25), value: selectedPeriod)
            .animation(.smooth(duration: 0.25), value: selectedEntity)
            .animation(.smooth(duration: 0.25), value: placesChartStyle)
        }
    }
    
    // общая сумма view
    private var totalSpentHeader: some View {
        VStack(spacing: 6) {
            Text("Всего потрачено")
                .font(.subheadline.weight(.medium))
            
            Text(formattedCurrency(totalSpent))
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(Color("AccentColor"))
                .monospacedDigit()
                .contentTransition(.numericText())
                .animation(.snappy(duration: 0.2), value: totalSpent)
            
            Text(selectedPeriod.filterValue)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color("AccentColor").opacity(0.12), in: Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 4)
    }
    
    private var chartContainer: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(selectedEntity == .places
                     ? "Расходы по местам"
                     : "Динамика расходов")
                .font(.headline.weight(.bold))
                
                Spacer()
                
                if selectedEntity == .places && !placeSpendings.isEmpty {
                    Picker("Стиль", selection: $placesChartStyle) {
                        ForEach(PlacesChartStyle.allCases) { style in
                            Text(style.rawValue).tag(style)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 150)
                } else if selectedEntity == .visits && !timeSpendings.isEmpty {
                    Picker("Стиль", selection: $visitsChartStyle) {
                        ForEach(VisitsChartStyle.allCases) { style in
                            Text(style.rawValue).tag(style)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 150)
                }
            }
            
            if filteredRecords.isEmpty {
                ContentUnavailableView(
                    "Нет данных",
                    systemImage: "chart.bar.xaxis",
                    description: Text("За выбранный период расходы не найдены")
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else{
                Group {
                    switch selectedEntity {
                    case .places:
                        switch placesChartStyle {
                        case .bar:
                            placesBarChart
                        case .donut:
                            placesDonutChart
                        }
                    case .visits:
                        switch visitsChartStyle {
                        case .bar:
                            visitsBarChart
                        case .graph:
                            visitsGraphChart
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
            }
        }
        .padding(20)
        .background{
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
        }
    }
    
    private var placesBarChart: some View {
        Group {
            if placeSpendings.count > 4 {
                placesBarChartContent
                    .chartScrollableAxes(.vertical)
                    .chartYVisibleDomain(length: 4)
            } else {
                placesBarChartContent
            }
        }
    }
    
    private var placesBarChartContent: some View {
        Chart(placeSpendings) { spending in
            let isSelected = selectedBarPlaceName == spending.name
            
            BarMark(
                x: .value("Сумма", spending.chartAmount),
                y: .value("Место", spending.name)
            )
            .foregroundStyle(by: .value("Место", spending.name))
            .opacity(selectedBarPlaceName == nil || isSelected ? 1 : 0.35)
            .cornerRadius(5)
            .annotation(position: .trailing, alignment: .leading) {
                Text(formattedCurrency(spending.totalAmount))
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(isSelected ? .primary : .secondary)
            }
        }
        .chartLegend(.hidden)
        .chartYSelection(value: $selectedBarPlaceName.animation())
        .chartXAxis(.hidden)
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisValueLabel()
            }
        }
        .chartPlotStyle { plotArea in
            plotArea.padding(.trailing, 62)
        }
    }
    
    private var placesDonutChart: some View {
        ZStack {
            Chart(placeSpendings) { spending in
                let isSelected = selectedDonutItem?.id == spending.id
                
                SectorMark(
                    angle: .value("Сумма", spending.chartAmount),
                    innerRadius: .ratio(0.618),
                    angularInset: 2
                )
                .cornerRadius(4)
                .foregroundStyle(by: .value("Место", spending.name))
                .opacity(selectedDonutItem == nil || isSelected ? 1 : 0.35)
            }
            .chartLegend(
                position: .bottom,
                alignment: .center,
                spacing: 10
            )
            .chartAngleSelection(value: $selectedAngleValue.animation())
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    if let plotFrame = chartProxy.plotFrame {
                        let frame = geometry[plotFrame]
                        if let selectedDonutItem {
                            let percent = Decimal(selectedDonutItem.chartAmount / totalChartAmount).formatted(.percent.precision(.fractionLength(1)))
                            VStack(spacing: 4) {
                                Text(selectedDonutItem.name)
                                    .font(.caption.weight(.semibold))
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                
                                Text(formattedCurrency(selectedDonutItem.totalAmount))
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .monospacedDigit()
                                
                                Text(percent)
                                    .font(.caption.weight(.bold))
                                    .monospacedDigit()
                            }
                            .position(x: frame.midX, y: frame.midY)
                            .transition(.opacity)
                        } else {
                            if let maxPriceSpending = placeSpendings.max(by: {$0.chartAmount < $1.chartAmount}) {
                                let biggestPercent = Decimal(maxPriceSpending.chartAmount / totalChartAmount)
                                    .formatted(.percent.precision(.fractionLength(1)))
                                VStack(spacing: 4) {
                                    Text("Максимальная трата:\n\(maxPriceSpending.name)")
                                        .font(.caption.weight(.semibold))
                                        .lineLimit(3)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(formattedCurrency(Decimal(maxPriceSpending.chartAmount)))
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                        .monospacedDigit()
                                    
                                    Text(biggestPercent)
                                        .font(.caption.weight(.bold))
                                        .monospacedDigit()
                                }
                                .position(x: frame.midX, y: frame.midY)
                                .transition(.opacity)
                            }
                        }
                    }
                }
            }
        }
    }

    
    private var visitsBarChart: some View {
        Chart(timeSpendings) { spending in
            BarMark(
                x: .value("Дата", spending.date, unit: visitsBinUnit),
                y: .value("Сумма", spending.chartAmount),
                width: visitsBarWidth
            )
            .foregroundStyle(Color("AccentColor").gradient)
            .cornerRadius(5)
        }
        .chartLegend(.hidden)
        .chartXScale(domain: visitsXDomain, range: .plotDimension(startPadding: 14, endPadding: 14))
        .visitsHorizontalScrolling(enabled: isVisitsChartScrollable, visibleDomainLength: visibleVisitsDomainLength, initialPosition: visitsXDomain.lowerBound, alignment: visitsScrollAlignment)
        .chartScrollableAxes(.vertical)
        .chartXAxis {
            AxisMarks(values: visitsAxisValues) { value in
                AxisGridLine()
                
                if let date = value.as(Date.self) {
                    AxisValueLabel(
                        centered: true,
                        anchor: .top,
                        collisionResolution: .disabled
                    ) {
                        Text(formatVisitsAxisDate(date))
                            .font(.caption2)
                            .fixedSize()
                            .padding(.top, 10)
                            .padding(.trailing, 16)
                            .rotationEffect(
                                shouldRotateVisitsAxisLabels ? .degrees(-45) : .zero,
                                anchor: .top
                            )
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(
                position: .leading,
                values: .automatic(desiredCount: 4)
            ) { _ in
                AxisGridLine()
                AxisValueLabel()
            }
        }
    }
    
    private var visitsGraphChart: some View {
        Chart(timeSpendings) { spending in
            LineMark(
                x: .value("Дата", spending.date, unit: visitsBinUnit),
                y: .value("Сумма", spending.chartAmount)
            )
            .foregroundStyle(Color("AccentColor"))
            .interpolationMethod(.catmullRom)

            PointMark(
                x: .value("Дата", spending.date, unit: visitsBinUnit),
                y: .value("Сумма", spending.chartAmount)
            )
            .foregroundStyle(Color("AccentColor"))
        }
        .chartLegend(.hidden)
        .chartXScale(domain: visitsXDomain, range: .plotDimension(startPadding: 14, endPadding: 14))
        .visitsHorizontalScrolling(enabled: isVisitsChartScrollable, visibleDomainLength: visibleVisitsDomainLength, initialPosition: visitsXDomain.lowerBound, alignment: visitsScrollAlignment)
        .chartScrollableAxes(.vertical)
        .chartXAxis {
            AxisMarks(values: visitsAxisValues) { value in
                AxisGridLine()

                if let date = value.as(Date.self) {
                    AxisValueLabel(
                        centered: true,
                        anchor: .top,
                        collisionResolution: .disabled
                    ) {
                        Text(formatVisitsAxisDate(date))
                            .font(.caption2)
                            .fixedSize()
                            .padding(.top, 10)
                            .padding(.trailing, 16)
                            .rotationEffect(
                                shouldRotateVisitsAxisLabels ? .degrees(-45) : .zero,
                                anchor: .top
                            )
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(
                position: .leading,
                values: .automatic(desiredCount: 4)
            ) { _ in
                AxisGridLine()
                AxisValueLabel()
            }
        }
    }
    
    private func clearChartSelection() {
        selectedBarPlaceName = nil
        selectedAngleValue = nil
    }
    
    private func normalizedDate(for date: Date) -> Date {
        let calendar = Calendar.autoupdatingCurrent
        
        switch selectedPeriod {
        case .today:
            let components = calendar.dateComponents(
                [.year, .month, .day, .hour],
                from: date
            )
            return calendar.date(from: components) ?? date
            
        case .week, .month:
            return calendar.startOfDay(for: date)
            
        case .all:
            let components = calendar.dateComponents(
                [.year, .month],
                from: date
            )
            return calendar.date(from: components) ?? date
        }
    }
    
    private func formatVisitsAxisDate(_ date: Date) -> String {
        switch selectedPeriod {
        case .today:
            return date.formatted(
                .dateTime.hour().minute()
            )
        case .week:
            return date.formatted(
                .dateTime.weekday(.abbreviated)
            )
        case .month:
            return date.formatted(
                .dateTime.day().month(.abbreviated)
            )
        case .all:
            return date.formatted(
                .dateTime.month(.abbreviated).year(.twoDigits)
            )
        }
    }
    
    private func formattedCurrency(_ amount: Decimal) -> String {
        amount.formatted(
            .currency(code: currencyCode)
                .precision(.fractionLength(2))
        )
    }
}

private extension View {
    @ViewBuilder
    func visitsHorizontalScrolling(
        enabled: Bool,
        visibleDomainLength: TimeInterval,
        initialPosition: Date,
        alignment: DateComponents
    ) -> some View {
        if enabled {
            self
                .chartScrollableAxes(.horizontal)
                .chartXVisibleDomain(length: visibleDomainLength)
                .chartScrollPosition(initialX: initialPosition)
                .chartScrollTargetBehavior(.valueAligned(matching: alignment))
        } else {
            self
        }
    }
}

#Preview {
    FinanceStatisticsView()
        .modelContainer(PreviewData.shared.container)
        .environment(AppRouter())
}

