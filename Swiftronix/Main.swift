//
//  Main.swift
//  Swiftronix
//
//  Created by Ganesh on 27/12/24.
//

import SwiftUI
import Foundation

import Alamofire
import SwiftyJSON



public class APILayer {
    public init() {}
    
    public func fetchDataFromAPI(url: String, completion: @escaping (Result<JSON, Error>) -> Void) {
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                completion(.success(JSON(value)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

