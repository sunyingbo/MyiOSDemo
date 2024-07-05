//
//  MySKProductSwiftTest.swift
//  MyiOSDemo
//
//  Created by yingbo3 on 2023/11/6.
//

import Foundation
import StoreKit

@available(iOS 15.0, *)
class MySKProductSwiftTest: NSObject {
    
    @objc
    public static let shared = MySKProductSwiftTest()
    
    @objc func productsRequest(_ productID: String) {
        Task {
            if let fron = await Storefront.current {
                print("yingbo3 purchase front code \(fron.countryCode)")
            }
            let products = try await Product.products(for: [productID])
            print("yingbo3 purchase product =\(products.last!)")
            let currencyCode = products.last?.priceFormatStyle.currencyCode
            print("yingbo3 purchase currencyCode =\(String(describing: currencyCode))")
        }
    }
}
