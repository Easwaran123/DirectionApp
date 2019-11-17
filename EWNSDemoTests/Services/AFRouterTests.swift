//
//  PSIRouterSpec.swift
//  PSIApp
//
//  Created by Swarup on 25/6/17.
//  Copyright © 2017 swarup. All rights reserved.
//

import Foundation
import Quick
import Nimble
import Alamofire

@testable import PSIApp

class PSIRouterSpec: QuickSpec {
    override func spec() {
        
        describe("PSIRouter") {
            var subject: PSIRouter!
            var urlRequest: URLRequest!
            
            context("when calling PSI api") {
                let dateString = "2017-06-25T12:15:00"
                
                beforeEach {
                    subject = PSIRouter.get(dateString)
                    urlRequest = try! subject.asURLRequest()
                }
                
                it("should be a GET request") {
                    expect(urlRequest.httpMethod).to(equal(HTTPMethod.get.rawValue))
                }
                
                it("should point to right end point") {
                    expect(urlRequest.url?.path).to(equal("/v1/environment/psi"))
                }
                
                it("should append date_time as query parameter") {
                    expect(urlRequest.url?.query?.components(separatedBy: "=").first).to(equal("date_time"))
                }
            }
        }
    }
}
       
