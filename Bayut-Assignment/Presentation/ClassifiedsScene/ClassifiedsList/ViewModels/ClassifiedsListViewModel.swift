//
//  ClassifiedsListViewModel.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//

import Foundation

struct ClassifiedsListViewModelActions {
    /// Note: if you would need to edit classified inside Details screen and update this Classifieds List screen with updated classified then you would need this closure:
    /// showClassifiedDetails: (Classified, @escaping (_ updated: Classified) -> Void) -> Void
    let showClassifiedDetails: (Classified) -> Void
}

enum ClassifiedsListViewModelLoading {
    case fullScreen
    case nextPage
}

protocol ClassifiedsListViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didSearch(query: String)
    func didCancelSearch()
    func didSelectItem(at index: Int)
}

protocol ClassifiedsListViewModelOutput {
    var items: Observable<[ClassifiedsListItemViewModel]> { get } /// Also we can calculate view model items on demand:  https://github.com/kudoleh/iOS-Clean-Architecture-MVVM/pull/10/files
    var loading: Observable<ClassifiedsListViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

protocol ClassifiedsListViewModel: ClassifiedsListViewModelInput, ClassifiedsListViewModelOutput {}

final class DefaultClassifiedsListViewModel: ClassifiedsListViewModel {

    private let searchClassifiedsUseCase: FetchClassifiedsUseCase
    private let actions: ClassifiedsListViewModelActions?

    var currentPage: Int = 0
    var totalPageCount: Int = 1
    var hasMorePages: Bool { currentPage < totalPageCount }
    var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }

    private var pages: [ClassifiedsPage] = []
    private var classifiedsLoadTask: Cancellable? { willSet { classifiedsLoadTask?.cancel() } }

    // MARK: - OUTPUT

    let items: Observable<[ClassifiedsListItemViewModel]> = Observable([])
    let loading: Observable<ClassifiedsListViewModelLoading?> = Observable(.none)
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    let screenTitle = NSLocalizedString("Classifieds", comment: "")
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    let errorTitle = NSLocalizedString("Error", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search Classifieds", comment: "")

    // MARK: - Init

    init(searchClassifiedsUseCase: FetchClassifiedsUseCase,
         actions: ClassifiedsListViewModelActions? = nil) {
        self.searchClassifiedsUseCase = searchClassifiedsUseCase
        self.actions = actions
    }

    // MARK: - Private

    private func appendPage(_ classifiedsPage: ClassifiedsPage) {
        pages = pages + [classifiedsPage]

        items.value = pages.classifieds.map(ClassifiedsListItemViewModel.init)
    }

    private func resetPages() {
        currentPage = 0
        totalPageCount = 1
        pages.removeAll()
        items.value.removeAll()
    }

    private func load(classifiedQuery: ClassifiedQuery, loading: ClassifiedsListViewModelLoading) {
        self.loading.value = loading
        query.value = classifiedQuery.query

        classifiedsLoadTask = searchClassifiedsUseCase.execute(
            requestValue: .init(query: classifiedQuery, page: nextPage),
            cached: appendPage,
            completion: { result in
                switch result {
                case .success(let page):
                    self.appendPage(page)
                case .failure(let error):
                    self.handle(error: error)
                }
                self.loading.value = .none
        })
    }

    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading classifieds", comment: "")
    }

    private func update(classifiedQuery: ClassifiedQuery) {
        resetPages()
        load(classifiedQuery: classifiedQuery, loading: .fullScreen)
    }
}

// MARK: - INPUT. View event methods

extension DefaultClassifiedsListViewModel {

    func viewDidLoad() { }

    func didLoadNextPage() {
        guard hasMorePages, loading.value == .none else { return }
        load(classifiedQuery: .init(query: query.value),
             loading: .nextPage)
    }

    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        update(classifiedQuery: ClassifiedQuery(query: query))
    }

    func didCancelSearch() {
        classifiedsLoadTask?.cancel()
    }

    func didSelectItem(at index: Int) {
        actions?.showClassifiedDetails(pages.classifieds[index])
    }
}

// MARK: - Private

private extension Array where Element == ClassifiedsPage {
    var classifieds: [Classified] { flatMap { $0.classifieds } }
}
