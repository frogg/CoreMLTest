//
//  TestImagePreprocessor.swift
//  CoreMLTestTests
//
//  Created by Supphawit Getmark on 1/12/2560 BE.
//  Copyright © 2560 Supphawit Getmark. All rights reserved.
//


import XCTest
import Foundation
import CoreImage
import CoreVideo

class TestImagePreprocessor: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testConvertCVImageBuffer(){
        
        var mockImageBuffer: CIImage = CIImage.init(color: CIColor.black)
        let imagePreprocessor: ImagePreprocessor = ImagePreprocessor()
        mockImageBuffer = mockImageBuffer.clampedToExtent().cropped(to: CGRect.init(x: 0, y: 0, width: 224, height: 224))
        print(imagePreprocessor.toImageBuffer(image: mockImageBuffer))
    }
    
}
