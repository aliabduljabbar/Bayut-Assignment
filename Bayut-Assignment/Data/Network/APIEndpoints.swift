//
//  APIEndpoints.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//

import Foundation

struct APIEndpoints {
    
    static func getClassifieds(with classifiedsRequestDTO: ClassifiedsRequestDTO) -> Endpoint<ClassifiedsResponseDTO> {

        return Endpoint(path: "default/dynamodb-writer",
                        method: .get,
                        queryParametersEncodable: classifiedsRequestDTO)
    }

    static func getClassifiedImage(path: String, width: Int) -> Endpoint<Data> {

//        let sizes = [92, 154, 185, 342, 500, 780]
//        let closestWidth = sizes.enumerated().min { abs($0.1 - width) < abs($1.1 - width) }?.element ?? sizes.first!
        let strippedPath = path.replacingOccurrences(of: AppConfiguration().imagesBaseURL, with: "")
        return Endpoint(path: "\(strippedPath)",
                        method: .get,
                        responseDecoder: RawDataResponseDecoder())
    }
}

