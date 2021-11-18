//
//  ClassifiedsRepository.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//

import Foundation

protocol ClassifiedsRepository {
    @discardableResult
    func fetchClassifiedsList(query: ClassifiedQuery, page: Int,
                         cached: @escaping (ClassifiedsPage) -> Void,
                         completion: @escaping (Result<ClassifiedsPage, Error>) -> Void) -> Cancellable?
}
