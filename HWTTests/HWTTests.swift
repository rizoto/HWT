//
//  HWTTests.swift
//  HWTTests
//
//  Created by Lubor Kolacny on 12/4/19.
//  Copyright © 2019 Lubor Kolacny. All rights reserved.
//

import XCTest
@testable import HWT

class HWTTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        UIGraphicsBeginImageContext(CGSize(width: 200, height: 200))
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.setFillColor(UIColor.yellow.cgColor)
            ctx.fill(CGRect(x: 0, y: 0, width: 200, height: 200))
            ctx.setLineCap(.round)
            ctx.setLineWidth(10.0)
            ctx.setStrokeColor(red: 255, green: 255, blue: 255, alpha: 1)
            ctx.move(to: CGPoint.init(x: 0, y: 0))
            ctx.addLine(to: CGPoint.init(x: 200, y: 200))
            ctx.strokePath()
            let image = UIGraphicsGetImageFromCurrentImageContext()
            // add breakpoint and check the image
            XCTAssert(image != nil)
        }
        UIGraphicsEndImageContext()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
