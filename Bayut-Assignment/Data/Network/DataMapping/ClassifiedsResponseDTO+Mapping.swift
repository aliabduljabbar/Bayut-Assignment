//
//  ClassifiedsResponseDTO+Mapping.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//

import Foundation

// MARK: - Data Transfer Object

struct ClassifiedsResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case classifieds = "results"
    }
    let classifieds: [ClassifiedDTO]
}

extension ClassifiedsResponseDTO {
    struct ClassifiedDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case createdAt = "created_at"
            case imageIds = "image_ids"
            case imageUrls = "image_urls"
            case imageUrlsThumbnails = "image_urls_thumbnails"
            case name
            case price
            case uid
        }
        
        let createdAt : String?
        let imageIds : [String]?
        let imageUrls : [String]?
        let imageUrlsThumbnails : [String]?
        let name : String?
        let price : String?
        let uid : String
    }
}

// MARK: - Mappings to Domain

extension ClassifiedsResponseDTO {
    func toDomain() -> ClassifiedsPage {
        return .init(classifieds: classifieds.map { $0.toDomain() })
    }
}

extension ClassifiedsResponseDTO.ClassifiedDTO {
    func toDomain() -> Classified {
        return .init(id: Classified.Identifier(uid),
                     createdAt: dateFormatter.date(from: createdAt ?? ""),
                     imageIds: imageIds,
                     imageUrls: imageUrls,
                     imageUrlsThumbnails: imageUrlsThumbnails,
                     name: name,
                     price: price)
    }
}

// MARK: - Private

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()

