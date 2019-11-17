//
//  PSIService.swift
//  PSIApp
//
//  Created by Swarup on 25/6/17.
//  Copyright © 2017 swarup. All rights reserved.
//

import Foundation
import SwiftyJSON


class PSIService {
 
    var networkClient: NetworkClient
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }()
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getPSI(date: Date, completion: @escaping ([PSI]) -> Void) {
        let dateString = dateFormatter.string(from: date)
        self.networkClient.get(urlRequest: PSIRouter.get(dateString)) { (result) in
            if result.isSuccess {
                var psis = [PSI]()
                
                let json = JSON(result.value!)
                for regionJSON in json["region_metadata"].arrayValue {
                    if let region = Region.init(json: regionJSON) {
                        psis.append(PSI(region: region))
                    }
                }
                
                let readingJSON = json["items"][0]["readings"]
                for i in psis.indices {
                    psis[i].parseFromJSON(json: readingJSON)
                }
                
                completion(psis)
            } else {
                
                completion([])
            }
        }
    }
}
