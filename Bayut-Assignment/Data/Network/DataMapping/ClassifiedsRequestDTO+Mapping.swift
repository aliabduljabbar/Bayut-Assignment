//
//  ClassifiedsRequestDTO+Mapping.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//

import Foundation

struct ClassifiedsRequestDTO: Encodable {
    let query: String
    let page: Int
}
