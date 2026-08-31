//
//  ExpenseItemTableView.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 27/08/2026.
//

import SwiftUI
import SwiftData

struct ExpenseItemTableView: View {
    let items: [ExpenseItem]
    let currencyCode: String
    
    @State private var tableWidth: CGFloat = 0
    
    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.persistentModelID) { index, item in
                
                if index > 0 {
                    Divider()
                        .gridCellUnsizedAxes(.horizontal)
                }

                GridRow {
                    Text(item.serviceName)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 8)
                    
                    Text("\(item.quantity) шт.")
                        .frame(width: 70)
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                    
                    Text(item.totalAmount, format: .currency(code: currencyCode))
                        .fixedSize(horizontal: true, vertical: false)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.leading, 8)
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
                .font(.subheadline)
                .padding(.vertical, 10)
            }
        }
    }
}

//#Preview {
//    ExpenseItemTableView()
//}
