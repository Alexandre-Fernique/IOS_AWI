//
//  JSONError.swift
//  Cooking Manager
//
//  Created by m1 on 22/02/2022.
//

import SwiftUI
enum APIError : Error, CustomStringConvertible,Equatable{
        
    case urlNotFound(URL)
    case JsonDecodingFailed
    case JsonEncodingFailed
    case initDataFailed
    case httpResponseError(Int)
    case unknown

    var description : String {
        switch self {
            case .urlNotFound(let url): return "Url \(url) not found"
            case .JsonDecodingFailed: return "JSON decoding failed"
            case .JsonEncodingFailed: return "JSON encoding failed"
            case .initDataFailed: return "Bad data format: initialization of data failed"
            case .httpResponseError(let err): return "Http Error Stauts code : \(err)"
            case .unknown: return "unknown error"
            
        }
        
    }
}
