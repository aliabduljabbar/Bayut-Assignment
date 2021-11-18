//
//  ClassifiedImagesRepositoryMock.swift
//  Bayut-AssignmentTests
//
//  Created by Ali Abdul Jabbar on 18/11/2021.
//

import Foundation
import XCTest

class ClassifiedImagesRepositoryMock: ClassifiedImagesRepository {
    var expectation: XCTestExpectation?
    var error: Error?
    var image = Data()
    var validateInput: ((String, Int) -> Void)?
    
    func fetchImage(with imagePath: String, width: Int, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        validateInput?(imagePath, width)
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(image))
        }
        expectation?.fulfill()
        return nil
    }
}
