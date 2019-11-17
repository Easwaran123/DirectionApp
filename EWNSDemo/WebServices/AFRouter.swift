//
//  PSIRouter.swift
//  PSIApp
//
//  Created by Swarup on 25/6/17.
//  Copyright © 2017 swarup. All rights reserved.
//

import Foundation
import Alamofire


enum PSIRouter: URLRequestConvertible {
    
    static let baseURL = "https://api.data.gov.sg/v1/environment/psi"
    
    case get(String)
    
    func asURLRequest() throws -> URLRequest {
        
        let result: (path: String, parameters: Parameters) = {
            switch self {
            case .get(let dateTime):
                return ("", ["date_time": dateTime])
            }
        }()
        
        let url = try PSIRouter.baseURL.asURL()
        var request = URLRequest(url: url.appendingPathComponent(result.path))
        request.addValue(PSIConstants.API_KEY, forHTTPHeaderField: "api-key")
        
        return try URLEncoding.default.encode(request, with: result.parameters)
        
    }
}
