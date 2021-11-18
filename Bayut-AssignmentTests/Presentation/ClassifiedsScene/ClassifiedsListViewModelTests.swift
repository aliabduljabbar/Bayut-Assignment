//
//  ClassifiedsListViewModelTests.swift
//  Bayut-AssignmentTests
//
//  Created by Ali Abdul Jabbar on 18/11/2021.
//

import XCTest

class ClassifiedsListViewModelTests: XCTestCase {
    
    private enum SearchClassifiedsUseCaseError: Error {
        case someError
    }
    
    let classifiedsPages: [ClassifiedsPage] = {
        let page1 = ClassifiedsPage(classifieds: [
            Classified.stub(id: "1", createdAt: Date(), imageIds: ["1"], imageUrls: ["/1"], imageUrlsThumbnails: ["/thumbnail-1"], name: "name1", price: "$1"),
            Classified.stub(id: "2", createdAt: Date(), imageIds: ["2"], imageUrls: ["/2"], imageUrlsThumbnails: ["/thumbnail-2"], name: "name2", price: "$2")])
        let page2 = ClassifiedsPage(classifieds: [
            Classified.stub(id: "3", createdAt: Date(), imageIds: ["3"], imageUrls: ["/3"], imageUrlsThumbnails: ["/thumbnail-3"], name: "name3", price: "$3")])
        return [page1, page2]
    }()
    
    class SearchClassifiedsUseCaseMock: FetchClassifiedsUseCase {
        var expectation: XCTestExpectation?
        var error: Error?
        var page = ClassifiedsPage(classifieds: [])
        
        func execute(requestValue: FetchClassifiedsUseCaseRequestValue,
                     cached: @escaping (ClassifiedsPage) -> Void,
                     completion: @escaping (Result<ClassifiedsPage, Error>) -> Void) -> Cancellable? {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(page))
            }
            expectation?.fulfill()
            return nil
        }
    }
    
    func test_whenSearchClassifiedsUseCaseRetrievesFirstPage_thenViewModelContainsOnlyFirstPage() {
        // given
        let searchClassifiedsUseCaseMock = SearchClassifiedsUseCaseMock()
        searchClassifiedsUseCaseMock.expectation = self.expectation(description: "contains only first page")
        searchClassifiedsUseCaseMock.page = ClassifiedsPage(classifieds: classifiedsPages[0].classifieds)
        let viewModel = DefaultClassifiedsListViewModel(fetchClassifiedsUseCase: searchClassifiedsUseCaseMock)
        // when
        viewModel.didFetch(query: "query")
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertFalse(viewModel.hasMorePages)
    }
    
    func test_whenSearchClassifiedsUseCaseReturnsError_thenViewModelContainsError() {
        // given
        let searchClassifiedsUseCaseMock = SearchClassifiedsUseCaseMock()
        searchClassifiedsUseCaseMock.expectation = self.expectation(description: "contain errors")
        searchClassifiedsUseCaseMock.error = SearchClassifiedsUseCaseError.someError
        let viewModel = DefaultClassifiedsListViewModel(fetchClassifiedsUseCase: searchClassifiedsUseCaseMock)
        // when
        viewModel.didFetch(query: "query")
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(viewModel.error)
    }
    
    func test_whenLastPage_thenHasNoPageIsTrue() {
        // given
        let searchClassifiedsUseCaseMock = SearchClassifiedsUseCaseMock()
        searchClassifiedsUseCaseMock.expectation = self.expectation(description: "First page loaded")
        searchClassifiedsUseCaseMock.page = ClassifiedsPage(classifieds: classifiedsPages[0].classifieds)
        let viewModel = DefaultClassifiedsListViewModel(fetchClassifiedsUseCase: searchClassifiedsUseCaseMock)
        // when
        viewModel.didFetch(query: "query")
        waitForExpectations(timeout: 5, handler: nil)

        viewModel.didLoadNextPage()
        
        // then
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertFalse(viewModel.hasMorePages)
    }
}
