//
//  ExpensePhoto.swift
//  coinApp
//
//  Created by Ермолицкий Иван on 17/08/2026.
//

import Foundation
import SwiftData

@Model
final class ExpensePhoto {
    @Attribute(.externalStorage) var imageData: Data
    
    var sortOrder: Int
    var record: ExpenseRecord?
    
    init(imageData: Data, sortOrder: Int) {
        self.imageData = imageData
        self.sortOrder = sortOrder
    }
}
