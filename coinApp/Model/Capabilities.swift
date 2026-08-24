//
//  Capabilities.swift
//  coinPrototypeApp
//
//  Created by Ермолицкий Иван on 19/06/2026.
//
import Foundation


enum Capabilities: String, CaseIterable {
    case briefFinanceRecord
    case financeGraphRepresentation
    case overallStatistics
}

extension Capabilities: Identifiable {
    var id: Self { self }
}

extension Capabilities {
    var name: String {
        switch self {
        case .briefFinanceRecord: "Расходы"
        case .financeGraphRepresentation: "Графическая статистика"
        case .overallStatistics: "Общая статистика"
        }
    }
    
    var description: String {
        switch self {
        case .briefFinanceRecord: "Сколько вы тратите"
        case .financeGraphRepresentation: "Визуальная оценка ваших трат"
        case .overallStatistics: "Оцените все ваши расходы в одном месте"
        }
    }
    
    var icon: String {
        switch self {
        case .briefFinanceRecord: "banknote"
        case .financeGraphRepresentation: "graph.2d"
        case .overallStatistics: "sum"
        }
    }
}
