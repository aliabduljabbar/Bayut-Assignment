//
//  CoreDataClassifiedsResponseStorage.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//

import Foundation
import CoreData

final class CoreDataClassifiedsResponseStorage {

    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    // MARK: - Private

    private func fetchRequest(for requestDto: ClassifiedsRequestDTO) -> NSFetchRequest<ClassifiedsRequestEntity> {
        let request: NSFetchRequest = ClassifiedsRequestEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@ AND %K = %d",
                                        #keyPath(ClassifiedsRequestEntity.query), requestDto.query,
                                        #keyPath(ClassifiedsRequestEntity.page), requestDto.page)
        return request
    }

    private func deleteResponse(for requestDto: ClassifiedsRequestDTO, in context: NSManagedObjectContext) {
        let request = fetchRequest(for: requestDto)

        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
}

extension CoreDataClassifiedsResponseStorage: ClassifiedsResponseStorage {

    func getResponse(for requestDto: ClassifiedsRequestDTO, completion: @escaping (Result<ClassifiedsResponseDTO?, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(for: requestDto)
                let requestEntity = try context.fetch(fetchRequest).first

                completion(.success(requestEntity?.response?.toDTO()))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }

    func save(response responseDto: ClassifiedsResponseDTO, for requestDto: ClassifiedsRequestDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(for: requestDto, in: context)

                let requestEntity = requestDto.toEntity(in: context)
                requestEntity.response = responseDto.toEntity(in: context)

                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                debugPrint("CoreDataClassifiedsResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}

