//
//  ClassifiedsSceneDIContainer.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//

import Foundation
import SwiftUI

final class ClassifiedsSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Persistent Storage
    lazy var classifiedsResponseCache: ClassifiedsResponseStorage = CoreDataClassifiedsResponseStorage()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeSearchClassifiedsUseCase() -> FetchClassifiedsUseCase {
        return DefaultFetchClassifiedsUseCase(classifiedsRepository: makeClassifiedsRepository())
    }
    
    
    // MARK: - Repositories
    func makeClassifiedsRepository() -> ClassifiedsRepository {
        return DefaultClassifiedsRepository(dataTransferService: dependencies.apiDataTransferService, cache: classifiedsResponseCache)
    }
    
    func makeClassifiedImagesRepository() -> ClassifiedImagesRepository {
        return DefaultClassifiedImagesRepository(dataTransferService: dependencies.imageDataTransferService)
    }
    
    // MARK: - Classifieds List
    func makeClassifiedsListViewController(actions: ClassifiedsListViewModelActions) -> ClassifiedsListViewController {
        return ClassifiedsListViewController.create(with: makeClassifiedsListViewModel(actions: actions),
                                               classifiedImagesRepository: makeClassifiedImagesRepository())
    }
    
    func makeClassifiedsListViewModel(actions: ClassifiedsListViewModelActions) -> ClassifiedsListViewModel {
        return DefaultClassifiedsListViewModel(searchClassifiedsUseCase: makeSearchClassifiedsUseCase(),
                                          actions: actions)
    }
    
    // MARK: - Classified Details
    func makeClassifiedsDetailsViewController(classified: Classified) -> UIViewController {
        return ClassifiedDetailsViewController.create(with: makeClassifiedsDetailsViewModel(classified: classified))
    }
    
    func makeClassifiedsDetailsViewModel(classified: Classified) -> ClassifiedDetailsViewModel {
        return DefaultClassifiedDetailsViewModel(classified: classified,
                                            classifiedImagesRepository: makeClassifiedImagesRepository())
    }

    // MARK: - Flow Coordinators
    func makeClassifiedsSearchFlowCoordinator(navigationController: UINavigationController) -> ClassifiedsSearchFlowCoordinator {
        return ClassifiedsSearchFlowCoordinator(navigationController: navigationController,
                                           dependencies: self)
    }
}

extension ClassifiedsSceneDIContainer: ClassifiedsSearchFlowCoordinatorDependencies {}
