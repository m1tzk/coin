//
//  Item.swift
//  coinPrototypeApp
//
//  Created by Ермолицкий Иван on 18/06/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
