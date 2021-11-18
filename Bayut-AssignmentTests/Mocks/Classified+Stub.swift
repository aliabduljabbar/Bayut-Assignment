//
//  Classified+Stub.swift
//  Bayut-AssignmentTests
//
//  Created by Ali Abdul Jabbar on 18/11/2021.
//

import Foundation

extension Classified {
    static func stub(id: Classified.Identifier = "id1",
                     createdAt: Date? = Date() ,
                     imageIds: [String]? = ["imageId1"],
                     imageUrls: [String]? = ["/imageId1"],
                     imageUrlsThumbnails: [String]? = ["/imageThumbnailId1"],
                     name: String? = nil,
                     price: String? = nil) -> Self {
        Classified(id: id,
                   createdAt: createdAt,
                   imageIds: imageIds,
                   imageUrls: imageUrls,
                   imageUrlsThumbnails: imageUrlsThumbnails,
                   name: name,
                   price: price)
    }
}
