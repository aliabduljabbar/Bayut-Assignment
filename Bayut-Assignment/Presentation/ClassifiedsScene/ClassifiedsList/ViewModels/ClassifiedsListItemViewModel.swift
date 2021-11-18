//
//  ClassifiedsListItemViewModel.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//

import Foundation

struct ClassifiedsListItemViewModel: Equatable {
    let name: String
    let price: String
    let createdAt: String
    let classifiedImagePath: String?
}

extension ClassifiedsListItemViewModel {
    
    init(classified: Classified) {
        self.name = classified.name ?? ""
        self.classifiedImagePath = classified.imageUrls?.first
        self.price = classified.price ?? ""
        if let createdAt = classified.createdAt {
            self.createdAt = "\(NSLocalizedString("Created At", comment: "")): \(dateFormatter.string(from: createdAt))"
        } else {
            self.createdAt = NSLocalizedString("Created date is not available", comment: "")
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

