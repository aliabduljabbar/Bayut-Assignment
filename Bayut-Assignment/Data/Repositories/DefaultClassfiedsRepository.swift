//
//  DefaultClassfiedsRepository.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//
// **Note**: DTOs structs are mapped into Domains here, and Repository protocols does not contain DTOs

import Foundation

final class DefaultClassifiedsRepository {

    private let dataTransferService: DataTransferService
    private let cache: ClassifiedsResponseStorage

    init(dataTransferService: DataTransferService, cache: ClassifiedsResponseStorage) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
}

extension DefaultClassifiedsRepository: ClassifiedsRepository {

    public func fetchClassifiedsList(query: ClassifiedQuery, page: Int,
                                cached: @escaping (ClassifiedsPage) -> Void,
                                completion: @escaping (Result<ClassifiedsPage, Error>) -> Void) -> Cancellable? {

        let requestDTO = ClassifiedsRequestDTO(query: query.query, page: page)
        let task = RepositoryTask()

        cache.getResponse(for: requestDTO) { result in

            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain())
            }
            guard !task.isCancelled else { return }

            let endpoint = APIEndpoints.getClassifieds(with: requestDTO)
            task.networkTask = self.dataTransferService.request(with: endpoint) { result in
                switch result {
                case .success(let responseDTO):
                    self.cache.save(response: responseDTO, for: requestDTO)
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        return task
    }
}
