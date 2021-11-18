//
//  NetworkConfigurableMock.swift
//  Bayut-AssignmentTests
//
//  Created by Ali Abdul Jabbar on 18/11/2021.
//

import Foundation

class NetworkConfigurableMock: NetworkConfigurable {
    var baseURL: URL = URL(string: "https://mock.test.com")!
    var headers: [String: String] = [:]
    var queryParameters: [String: String] = [:]
}
