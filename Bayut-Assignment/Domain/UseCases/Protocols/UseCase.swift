//
//  UseCase.swift
//  Bayut-Assignment
//
//  Created by Ali Abdul Jabbar on 14/11/2021.
//

import Foundation

public protocol UseCase {
    @discardableResult
    func start() -> Cancellable?
}
