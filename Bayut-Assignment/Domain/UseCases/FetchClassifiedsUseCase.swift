//
//  FetchClassifiedsUseCase.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//

import Foundation

protocol FetchClassifiedsUseCase {
    func execute(requestValue: FetchClassifiedsUseCaseRequestValue,
                 cached: @escaping (ClassifiedsPage) -> Void,
                 completion: @escaping (Result<ClassifiedsPage, Error>) -> Void) -> Cancellable?
}

final class DefaultFetchClassifiedsUseCase: FetchClassifiedsUseCase {

    private let classifiedsRepository: ClassifiedsRepository

    init(classifiedsRepository: ClassifiedsRepository) {

        self.classifiedsRepository = classifiedsRepository
    }

    func execute(requestValue: FetchClassifiedsUseCaseRequestValue,
                 cached: @escaping (ClassifiedsPage) -> Void,
                 completion: @escaping (Result<ClassifiedsPage, Error>) -> Void) -> Cancellable? {

        return classifiedsRepository.fetchClassifiedsList(query: requestValue.query,
                                                page: requestValue.page,
                                                cached: cached,
                                                completion: { result in
            completion(result)
        })
    }
}

struct FetchClassifiedsUseCaseRequestValue {
    let query: ClassifiedQuery
    let page: Int
}

