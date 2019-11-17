//
//  PSIMapViewControllerSpec.swift
//  PSIApp
//
//  Created by Swarup on 25/6/17.
//  Copyright © 2017 swarup. All rights reserved.
//

import Foundation
import Quick
import Nimble
import CoreLocation
import Alamofire

@testable import PSIApp

class PSIMapViewControllerSpec: QuickSpec {
    
    override func spec() {
        
        describe("PSIMapViewController") {
            var subject: PSIMapViewController!
            let mockPSIService =  MockPSIService(networkClient: MockNetworkClient())
            
            beforeEach {
                subject = UIStoryboard.getViewController(storyboardName: "Main", identifier: "\(PSIMapViewController.self)")
                subject.psiService = mockPSIService
                _ = subject.view
            }
            
            context("when the view is loaded") {
                it("should set the title") {
                    expect(subject.title).to(equal("PSI"))
                }
                
                it("should have a mapview") {
                    expect(subject.mapView).toNot(beNil())
                }
                
                it("should fetch psi info") {
                    expect(mockPSIService.isGetPSICalled).to(beTrue())
                }
            }
            
            context("when psi info is fetched") {
                
                it("should load the map with annotations") {
                    expect(subject.mapView.annotations.count).to(equal(2))
                }
                
                it("should create annotation of type PSIAnnotation") {
                    expect(subject.mapView.annotations[0]).to(beAKindOf(PSIAnnotation.self))
                }
                
                it("should set the title for annotation") {
                    let annotation = subject.mapView.annotations[0]
                    expect(annotation.title!).to(equal(mockPSIService.psis[0].region.direction.rawValue))
                    
                }
                
                it("should set the subtitle for annotation") {
                    let annotation = subject.mapView.annotations[0]
                    expect(annotation.subtitle!).to(satisfyAnyOf(
                        equal(mockPSIService.psis[0].getDescription()),
                        equal(mockPSIService.psis[1].getDescription())
                    ))
                }
                
                it("should set the coordinate for annotation") {
                    let annotation = subject.mapView.annotations[0]
                    let psis = mockPSIService.psis
                    
                    expect(annotation.coordinate.latitude).to(satisfyAnyOf(
                        equal(psis[0].region.locationCoordinate.latitude),
                        equal(psis[1].region.locationCoordinate.latitude)
                    ))
                    
                    expect(annotation.coordinate.longitude).to(satisfyAnyOf(
                        equal(psis[0].region.locationCoordinate.longitude),
                        equal(psis[1].region.locationCoordinate.longitude)
                    ))
                }
                
                it("should create a annotation view of type PSIAnnotationView") {
                    let annotationView = subject.mapView(subject.mapView, viewFor: subject.mapView.annotations[0])
                    expect(annotationView).to(beAKindOf(PSIAnnotationView.self))
                }
                
                it("should set the subtitle label of annotationView") {
                    let annotationText = subject.mapView.annotations[0].subtitle
                    let annotationView = subject.mapView(subject.mapView, viewFor: subject.mapView.annotations[0]) as! PSIAnnotationView
                    expect(annotationView.subtitleLabel.text).to(equal(annotationText!))
                }
            }
        }
    }
}

fileprivate class MockPSIService: PSIService {
    var isGetPSICalled = false
    var psis =  [PSI]()
    override func getPSI(date: Date, completion: @escaping ([PSI]) -> Void) {
        
        isGetPSICalled = true
        
        let region1 = Region.init(direction: .east, locationCoordinate: CLLocationCoordinate2D.init(latitude: 1.35735, longitude: 103.94))
        var psi = PSI.init(region: region1)
        psi.psiTwentyFourHourly = 25
        
        let region2 = Region.init(direction: .west, locationCoordinate: CLLocationCoordinate2D.init(latitude: 1.36000, longitude: 103.82))
        var psi2 = PSI.init(region: region2)
        psi2.pm10TwentyFourHourly = 10
        
        psis = [psi, psi2]
        completion(psis)
    }
}

fileprivate class MockNetworkClient: NetworkClient {
    func get(urlRequest: URLRequestConvertible, completion: @escaping (Result<Any>) -> Void) {
        //noop
    }
}
