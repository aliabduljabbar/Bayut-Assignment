//
//  ClassifiedDetailsViewModelTests.swift
//  Bayut-AssignmentTests
//
//  Created by Ali Abdul Jabbar on 18/11/2021.
//

import XCTest

class ClassifiedDetailsViewModelTests: XCTestCase {
    
    private enum ClassifiedImageDowloadError: Error {
        case someError
    }
    
    func test_updateClassifiedImageWithWidthEventReceived_thenImageWithThisWidthIsDownloaded() {
        // given
        let classifiedImagesRepository = ClassifiedImagesRepositoryMock()
        classifiedImagesRepository.expectation = self.expectation(description: "Image with download")
        let expectedImage = "image data".data(using: .utf8)!
        classifiedImagesRepository.image = expectedImage

        let viewModel = DefaultClassifiedDetailsViewModel(classified: Classified.stub(imageUrls: ["classifiedImageURL"]),
                                                     classifiedImagesRepository: classifiedImagesRepository)
        
        classifiedImagesRepository.validateInput = { (imagePath: String, width: Int) in
            XCTAssertEqual(imagePath, "classifiedImageURL")
            XCTAssertEqual(width, 200)
        }
        
        // when
        viewModel.updateClassifiedImage(width: 200)
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.classifiedImage.value, expectedImage)
    }
}
