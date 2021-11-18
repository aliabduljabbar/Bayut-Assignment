//
//  ClassifiedsResponseStorage.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//

import Foundation

protocol ClassifiedsResponseStorage {
    func getResponse(for request: ClassifiedsRequestDTO, completion: @escaping (Result<ClassifiedsResponseDTO?, CoreDataStorageError>) -> Void)
    func save(response: ClassifiedsResponseDTO, for requestDto: ClassifiedsRequestDTO)
}
