//
//  Classified.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//

import Foundation

struct Classified: Equatable, Identifiable {
    typealias Identifier = String
    
    let id : Identifier
    let createdAt : Date?
    let imageIds : [String]?
    let imageUrls : [String]?
    let imageUrlsThumbnails : [String]?
    let name : String?
    let price : String?
}

struct ClassifiedsPage: Equatable {
    let classifieds: [Classified]
}
