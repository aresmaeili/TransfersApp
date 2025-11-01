//
//  FetchTransfersUseCase.swift
//  TransferFeature
//
//  Created by AREM on 10/30/25.
//


import Foundation

protocol FetchTransfersUseCase: Sendable {
    func execute(page: Int) async throws -> [Transfer]
}

