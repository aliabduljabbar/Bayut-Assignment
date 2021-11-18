//
//  ClassifiedsResponseEntity+Mapping.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//

import Foundation
import CoreData

extension ClassifiedsResponseEntity {
    func toDTO() -> ClassifiedsResponseDTO {
        return .init(classifieds: classifieds?.allObjects.map { ($0 as! ClassifiedResponseEntity).toDTO() } ?? [])
    }
}

extension ClassifiedResponseEntity {
    func toDTO() -> ClassifiedsResponseDTO.ClassifiedDTO {
        return .init(createdAt: createdAt, imageIds: imageIds, imageUrls: imageUrls, imageUrlsThumbnails: imageUrlsThumbnails, name: name, price: price, uid: id ?? "")
    }
}

extension ClassifiedsRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> ClassifiedsRequestEntity {
        let entity: ClassifiedsRequestEntity = .init(context: context)
        entity.query = query
        entity.page = Int32(page)
        return entity
    }
}

extension ClassifiedsResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> ClassifiedsResponseEntity {
        let entity: ClassifiedsResponseEntity = .init(context: context)
        classifieds.forEach {
            entity.addToClassifieds($0.toEntity(in: context))
        }
        return entity
    }
}

extension ClassifiedsResponseDTO.ClassifiedDTO {
    func toEntity(in context: NSManagedObjectContext) -> ClassifiedResponseEntity {
        let entity: ClassifiedResponseEntity = .init(context: context)
        entity.id = uid
        entity.createdAt = createdAt
        entity.name = name
        entity.price = price
        entity.imageIds = imageIds
        entity.imageUrls = imageUrls
        entity.imageUrlsThumbnails = imageUrlsThumbnails
        return entity
    }
}

