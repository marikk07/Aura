//
//  SubscriptionManager.swift
//  Aura
//
//  Created by Alex on 11/29/17.
//  Copyright © 2017 Hubwester. All rights reserved.
//

import Foundation
import StoreKit

@objc final class SubscriptionManager: NSObject {
    
    fileprivate struct Consts {
        static let productId = "aura.subscription" //"com.exposit.ds.aura.unlock.all" //"aura.subscription"
        static let subscriptionUnlockKey = "unlockAll"
    }
    
    @objc enum Status: Int {
        case active
        case inactive
    }
    
    @objc static let instance = SubscriptionManager()
    
    @objc fileprivate(set) var status: Status = .inactive {
        didSet {
            stateDidChange()
        }
    }
    
    fileprivate let purchasesManager = PurchasesManager()
    
    private override init() {
        super.init()
        refreshStatus()
    }

    @objc func subscribe(_ callback: @escaping (Bool) -> ()) {
        purchasesManager.product(with: Consts.productId) { [weak self] (product) in
            guard let product = product else {
                callback(false)
                return
            }
            self?.purchasesManager.purchase(product) { success in
                if success {
                    unlockAll = true
                    UserDefaults.standard.set(true, forKey: Consts.subscriptionUnlockKey)
                }
                callback(success)
            }
        }
    }
    
    @objc func restorePurchases(_ callback: @escaping (Bool) -> ()) {
        purchasesManager.restorePurchases { success in
            if success {
                unlockAll = true
                UserDefaults.standard.set(true, forKey: Consts.subscriptionUnlockKey)
            }
            callback(success)
        }
    }
    
    @objc func subscriptionDetails(_ callback: @escaping (SKProduct?) -> ()) {
        purchasesManager.product(with: Consts.productId, callback: callback)
    }
    
}

private extension SubscriptionManager {

    func refreshStatus() {
        let unlock = UserDefaults.standard.bool(forKey: Consts.productId)
        status = unlock ? .active : .inactive
        purchasesManager.product(with: Consts.productId) { [weak self] (product) in
            guard let strongSelf = self, let product = product else {
                return
            }
            strongSelf.status = strongSelf.purchasesManager.isSubscriptionActive(product) ? .active : .inactive
        }
    }
    
    func stateDidChange() {
        
    }
    
}

private final class ProductRequest: NSObject, SKProductsRequestDelegate {
    
    typealias RequestCallback = ([SKProduct]) -> ()
    
    private let productId: String
    private var callback: RequestCallback?
    private var strongSelf: Any?
    
    init(productId: String) {
        self.productId = productId
        super.init()
    }
    
    func execute(_ callback: @escaping RequestCallback) {
        strongSelf = self
        self.callback = callback
        let productRequest = SKProductsRequest(productIdentifiers: Set([productId]))
        productRequest.delegate = self
        productRequest.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        defer {
            callback = nil
            strongSelf = nil
        }
        let products = response.products.filter { response.invalidProductIdentifiers.contains($0.productIdentifier) == false }
        callback?(products)
    }
    
}

private final class ReceiptRefreshRequest: NSObject, SKRequestDelegate {

    private var callback: ((Bool) -> ())?
    private var strongSelf: Any?
    
    func execute(_ callback: @escaping (Bool) -> ()) {
        self.callback = callback
        strongSelf = self
        let request = SKReceiptRefreshRequest()
        request.delegate = self
        request.start()
    }
    
    func requestDidFinish(_ request: SKRequest) {
        callback?(true)
        callback = nil
        strongSelf = nil
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        callback?(false)
        callback = nil
        strongSelf = nil
    }
    
}

private final class PurchasesManager: NSObject, SKPaymentTransactionObserver {
    
    private struct Purchase {
        let product: SKProduct
        let callback: (Bool) -> ()
    }
    
    private var purchaseQueue = [Purchase]()
    private var products = Set<SKProduct>()
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func restorePurchases(_ callback: @escaping (Bool) -> ()) {
        let refreshRequest = ReceiptRefreshRequest()
        refreshRequest.execute(callback)
    }
    
    func product(with identifier: String, callback: @escaping (SKProduct?) -> ()) {
        if let product = products.filter({ $0.productIdentifier == identifier }).first {
            callback(product)
        } else {
            let productRequest = ProductRequest(productId: identifier)
            productRequest.execute { [weak self] products in
                guard let strongSelf = self else { return }
                strongSelf.products = strongSelf.products.union(Set(products))
                if let product = products.filter({ $0.productIdentifier == identifier }).first {
                    callback(product)
                } else {
                    callback(nil)
                }
            }
        }
    }
    
    func purchase(_ product: SKProduct, callback: @escaping (Bool) -> ()) {
        let purchase = Purchase(product: product, callback: callback)
        purchaseQueue.append(purchase)
        let payment = SKMutablePayment(product: product)
        payment.quantity = 1
        SKPaymentQueue.default().add(payment)
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .deferred, .purchasing:
                break
            case .failed:
                paymentCompleted(transaction.payment, success: false)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .purchased, .restored:
                paymentCompleted(transaction.payment, success: true)
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    func isSubscriptionActive(_ product: SKProduct) -> Bool {
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL, let receiptData = try? Data(contentsOf: appStoreReceiptURL) else { return false }
        let json = try? JSONSerialization.jsonObject(with: receiptData, options: .allowFragments)
        print(json)
        return false
    }
    
    private func paymentCompleted(_ payment: SKPayment, success: Bool) {
        let purchases = purchaseQueue
        for (i, purchase) in purchases.enumerated() where purchase.product.productIdentifier == payment.productIdentifier {
            let purchaseInfo = purchaseQueue.remove(at: i)
            purchaseInfo.callback(success)
            break
        }
    }

}
