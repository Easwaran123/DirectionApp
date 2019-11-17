//
//  PSIServiceSpec.swift
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

class PSIServiceSpec: QuickSpec {
    override func spec() {
        
        describe("PSIService") {
            var subject: PSIService!
            let mockNetworkClient = MockNetworkClient()
            
            beforeEach {
                subject = PSIService(networkClient: mockNetworkClient)
            }
            
            context("when get PSI is called") {
                let dateString = "2017-06-25T12:15:00"
                let dateFormatter: DateFormatter = {
                   let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    return dateFormatter
                }()
                
                beforeEach {
                    let date = dateFormatter.date(from: dateString)!
                    subject.getPSI(date: date) {_ in 
                        
                    }
                }
                it("should call the network client with the right params") {
                    
                    expect(mockNetworkClient.isGetPSICalled).to(beTrue())
                    
                    expect(mockNetworkClient.urlRequestArg.urlRequest!).to(equal(PSIRouter.get(dateString).urlRequest))
                    
                    expect(mockNetworkClient.urlRequestArg.urlRequest?.value(forHTTPHeaderField: "api-key")).toNot(beNil())
                }
            }
            
            context("when response is received") {
                var response: Any?
                beforeEach {
                    
                    subject.getPSI(date: Date()) {
                        response = $0
                    }
                }
                
                it("should return array of psis") {
                    expect(response).to(beAKindOf([PSI].self))
                }
                
                it("should return have psis for 5 regions") {
                    let psis = response as! [PSI]
                    expect(psis.count).to(equal(5))
                }
                
                it("should fetch 24 hour psi value") {
                    let psis = response as! [PSI]
                    expect(psis[0].psiTwentyFourHourly).to(equal(52))
                }
                
                it("should fetch pm25 24 hour value") {
                    let psis = response as! [PSI]
                    expect(psis[0].pm25TwentyFourHourly).to(equal(13))
                }
                
                it("should fetch pm10 24 hour value") {
                    let psis = response as! [PSI]
                    expect(psis[0].pm10TwentyFourHourly).to(equal(21))
                }
             }
        }
    }
}

fileprivate class MockNetworkClient: NetworkClient {
    
    var isGetPSICalled = false
    var urlRequestArg: URLRequestConvertible!
    
    fileprivate func get(urlRequest: URLRequestConvertible, completion: @escaping (Result<Any>) -> Void) {
        
        isGetPSICalled = true
        self.urlRequestArg = urlRequest
        
        //get JSON from canned response file.
        let url = URL.init(fileURLWithPath: Bundle.init(for: MockNetworkClient.self).path(forResource: "psi", ofType: "json")!)
        let data = try! Data.init(contentsOf: url)
        
        completion(Result.success(data))
    }
}

