//
//  TransferFlowFactory.swift
//  TransferFeature
//
//  Created by AREM on 11/1/25.
//

import UIKit

protocol TransferFlowFactory: AnyObject {
    func makeTransferList(coordinator: TransferCoordinator) -> UIViewController
    func makeTransfersDetails(transfer: Transfer) -> UIViewController
}
