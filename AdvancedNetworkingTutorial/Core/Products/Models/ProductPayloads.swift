//
//  ProductPayloads.swift
//  AdvancedNetworkingTutorial
//
//  Created by Sachin Randive on 26/04/26.
//

import Foundation

struct CreateProductRequest: Encodable {
    let title: String
    let price: Int
    let description: String
    let categoryId: Int
    let images: [String]
}

