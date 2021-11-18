//
//  AppFlowCoordinator.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        // In App Flow we can check if user needs to login, if yes we would run login flow
        let classifiedsSceneDIContainer = appDIContainer.makeClassifiedsSceneDIContainer()
        let flow = classifiedsSceneDIContainer.makeClassifiedsSearchFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
