//
//  BriefFinanceRecordView.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 19/06/2026.
//
import SwiftUI
import SwiftData

struct BriefFinanceRecordView: View {
    @Query(
        sort: \ExpenseRecord.createdAt,
        order: .reverse
    )
    
    private var records: [ExpenseRecord]
    
    @State private var selectedPeriod: FilterPeriod = .all
    @State private var isAddingExpense = false
    @State private var selectedRecord: ExpenseRecord?
    
    var body: some View {
        NavigationStack {
            List {
                Section(selectedPeriod.filterValue) {
                    ForEach(filteredRecords) { record in
                        Button {
                            selectedRecord = record
                        } label: {
                            ExpenseRecordRowView(record: record, period: selectedPeriod)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .listRowSpacing(2)
            .contentMargins(.top, 8, for: .scrollContent)
            .scrollContentBackground(.hidden) // скрыть визуаль от list
            .navigationTitle("Расходы")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
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
                    
                    Button {
                        isAddingExpense = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(Color("AccentColor"))
                    }
                    .accessibilityLabel("Добавить")
                }
            }
            .navigationDestination(item: $selectedRecord) { record in
                ExpenseRecordDetailView(record: record)
            }
            .sheet(isPresented: $isAddingExpense) {
                NavigationStack {
                    AddExpenseView()
                }
            }
        }
    }
}

extension BriefFinanceRecordView {
    private var filteredRecords: [ExpenseRecord] {
        records.filter { record in
            selectedPeriod.contains(record.createdAt)
        }
    }
}

struct ExpenseRecordRowView: View {
    let record: ExpenseRecord
    let period: FilterPeriod
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(record.place?.name ?? "Место не указано.")
                    .font(.body.weight(.medium))
                    .lineLimit(2)
                
                Text(dateText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer(minLength: 12)
            
            Text(formatted(record.totalSpent))
                .font(.body.weight(.semibold))
                .foregroundStyle(Color("AccentColor"))
                .monospacedDigit()
        }
        .padding(.vertical, 4)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    private var dateText: String {
        switch period {
        case .today: RecordDateFormatter.time(record.createdAt)
        case .week, .month: RecordDateFormatter.dayMonthTime(record.createdAt)
        case .all: RecordDateFormatter.full(record.createdAt)
        }
    }
    private func formatted(_ amount: Decimal) -> String {
        amount.formatted(
            .currency(code: record.currencyCode)
            .precision(.fractionLength(2))
        )
    }
}


struct ExpenseRecordDetailView: View {
    let record: ExpenseRecord
    
    @State private var showsPlaceOnMap = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 6) {
                    Text(record.place?.name ?? "Место не указано.")
                        .modifier(MainTextModifier())
                    
                    Text(formatted(record.totalSpent))
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Color("AccentColor"))
                        .monospacedDigit()
                }
                .padding(.top, 8)
                
                Text(RecordDateFormatter.full(record.createdAt))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                ExpenseItemTableView(items: record.items, currencyCode: record.currencyCode)
                
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 32)
        }
        .navigationTitle("Запись о расходе")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button{
                    showsPlaceOnMap = true
                } label: {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.title2)
                        .foregroundStyle(Color("AccentColor"))
                }
                .disabled(record.place?.coordinate == nil)
                .accessibilityLabel("Показать место расхода на карте.")
            }
        }
        .navigationDestination(isPresented: $showsPlaceOnMap) {
            PlacesOnMapView()
        }
    }
    
    private func formatted(_ amount: Decimal) -> String {
        amount.formatted(
            .currency(code: record.currencyCode)
            .precision(.fractionLength(2))
        )
    }
}


struct MainTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(Color(.text))
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

//#Preview {
//    BriefFinanceRecordView()
//        .modelContainer(PreviewData.makeContainer())
//}
