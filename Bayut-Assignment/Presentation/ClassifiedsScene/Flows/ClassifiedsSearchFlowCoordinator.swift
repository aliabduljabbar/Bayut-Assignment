//
//  ClassifiedsSearchFlowCoordinator.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//

import UIKit

protocol ClassifiedsSearchFlowCoordinatorDependencies  {
    func makeClassifiedsListViewController(actions: ClassifiedsListViewModelActions) -> ClassifiedsListViewController
    func makeClassifiedsDetailsViewController(classified: Classified) -> UIViewController
}

final class ClassifiedsSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: ClassifiedsSearchFlowCoordinatorDependencies

    private weak var classifiedsListVC: ClassifiedsListViewController?

    init(navigationController: UINavigationController,
         dependencies: ClassifiedsSearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        let actions = ClassifiedsListViewModelActions(showClassifiedDetails: showClassifiedDetails)
        let vc = dependencies.makeClassifiedsListViewController(actions: actions)

        navigationController?.pushViewController(vc, animated: false)
        classifiedsListVC = vc
    }

    private func showClassifiedDetails(classified: Classified) {
        let vc = dependencies.makeClassifiedsDetailsViewController(classified: classified)
        navigationController?.pushViewController(vc, animated: true)
    }
}
