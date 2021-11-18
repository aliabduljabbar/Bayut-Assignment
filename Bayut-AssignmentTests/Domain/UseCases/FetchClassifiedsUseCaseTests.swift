//
//  FetchClassifiedsUseCaseTests.swift
//  Bayut-AssignmentTests
//
//  Created by Ali Abdul Jabbar on 18/11/2021.
//

import XCTest

class FetchClassifiedsUseCaseTests: XCTestCase {
    
    static let moviesPages: [ClassifiedsPage] = {
        let page1 = ClassifiedsPage(classifieds: [
            Classified.stub(id: "1", createdAt: Date(), imageIds: ["1"], imageUrls: ["/1"], imageUrlsThumbnails: ["/thumbnail-1"], name: "name1", price: "$1"),
            Classified.stub(id: "2", createdAt: Date(), imageIds: ["2"], imageUrls: ["/2"], imageUrlsThumbnails: ["/thumbnail-2"], name: "name2", price: "$2")])
        return [page1]
    }()
    
    enum ClassifiedsRepositorySuccessTestError: Error {
        case failedFetching
    }
    
    struct ClassifiedsRepositoryMock: ClassifiedsRepository {
        var result: Result<ClassifiedsPage, Error>
        func fetchClassifiedsList(query: ClassifiedQuery, page: Int, cached: @escaping (ClassifiedsPage) -> Void, completion: @escaping (Result<ClassifiedsPage, Error>) -> Void) -> Cancellable? {
            completion(result)
            return nil
        }
    }
    
    func testFetchClassifiedsUseCase_whenSuccessfullyFetchesClassifiedsForQuery_thenQueryIsSavedInRecentQueries() {
        // given
        let expectation = self.expectation(description: "Classified Pages should be fetched")
        expectation.expectedFulfillmentCount = 1
        let useCase = DefaultFetchClassifiedsUseCase(classifiedsRepository: ClassifiedsRepositoryMock(result: .success(FetchClassifiedsUseCaseTests.moviesPages[0])))
        var classifiedsPages = [ClassifiedsPage]()

        // when
        let requestValue = FetchClassifiedsUseCaseRequestValue(query: ClassifiedQuery(query: ""),
                                                           page: 0)
        _ = useCase.execute(requestValue: requestValue, cached: { _ in }) { result in
            if case .success(let classifiedsPage) = result {
                classifiedsPages = [classifiedsPage]
            }
            expectation.fulfill()
        }
        // then

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(classifiedsPages.contains(FetchClassifiedsUseCaseTests.moviesPages[0]))
    }
    
    func testFetchClassifiedsUseCase_whenFailedFetchingClassifiedsForQuery_thenClassifiedsPageShouldBeEmpty() {
        // given
        let expectation = self.expectation(description: "classifieds should not be fetched")
        expectation.expectedFulfillmentCount = 1
        let useCase = DefaultFetchClassifiedsUseCase(classifiedsRepository: ClassifiedsRepositoryMock(result: .failure(ClassifiedsRepositorySuccessTestError.failedFetching)))
        var classifiedsPages = [ClassifiedsPage(classifieds: [Classified.stub()])]
        // when
        let requestValue = FetchClassifiedsUseCaseRequestValue(query: ClassifiedQuery(query: "title1"),
                                                           page: 0)
        _ = useCase.execute(requestValue: requestValue, cached: { _ in }) { result in
            if case .failure(_ ) = result {
                classifiedsPages = []
            }
            expectation.fulfill()
        }
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(classifiedsPages.isEmpty)
    }
}
