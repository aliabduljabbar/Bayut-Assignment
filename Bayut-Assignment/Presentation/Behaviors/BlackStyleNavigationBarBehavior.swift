//
//  BlackStyleNavigationBarBehavior.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//

import UIKit

struct BlackStyleNavigationBarBehavior: ViewControllerLifecycleBehavior {

    func viewDidLoad(viewController: UIViewController) {

        viewController.navigationController?.navigationBar.barStyle = .black
    }
}
