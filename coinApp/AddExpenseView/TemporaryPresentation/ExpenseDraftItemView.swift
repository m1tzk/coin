//
//  ExpenseDraftItemView.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 13/08/2026.
//

import SwiftUI

struct ExpenseDraftItemView: View {
    @Binding var draft: ExpenseItemDraft
    private var priceBinding: Binding<Decimal?> {
        Binding(
            get: { draft.unitPrice == 0 ? nil : draft.unitPrice},
            set: { newValue in
                draft.unitPrice = newValue ?? 0
            }
        )
    }
    let currencyCode: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Введите наименование услуги...", text: $draft.serviceName)
                .textInputAutocapitalization(.sentences)
            HStack(spacing: 8) {
                TextField("Цена за единицу...", value: priceBinding, format: .number.precision(.fractionLength(2)))
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.leading)
                    .frame(width: 150)
                Spacer()
                Text(currencyCode)
                    .foregroundStyle(.secondary)
            }
            Stepper(value: $draft.quantity, in: 1...50) {
                LabeledContent("Количество") {
                    Text("\(draft.quantity)")
                        .monospacedDigit()
                }
            }
            LabeledContent("Итого") {
                HStack(spacing: 8) {
                    Text(draft.totalAmount, format: .number.precision(.fractionLength(2)))
                        .monospacedDigit()
                        .contentTransition(.numericText())
                        .animation(.snappy, value: draft.totalAmount)
                    Text(currencyCode)
                        .foregroundStyle(.secondary)
                }
                .foregroundStyle(Color("AccentColor"))
            }
        }
        .padding(.vertical, 4)
    }
}

//#Preview {
//    ExpenseDraftItemView()
//}
