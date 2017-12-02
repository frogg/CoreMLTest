//
//  ImagePreprocessor.swift
//  CoreMLTest
//
//  Created by Supphawit Getmark on 1/12/2560 BE.
//  Copyright © 2560 Supphawit Getmark. All rights reserved.
//

import Foundation
import CoreImage
import CoreVideo

class ImagePreprocessor {
    
    func detectFeature(from image:CIImage) {
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyLow]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: image)
        for face in faces as! [CIFaceFeature] {
            if face.hasLeftEyePosition{
                print("Left eye bounds are \(face.leftEyePosition)")
            }
            if face.hasRightEyePosition{
                print("Right eye bounds are \(face.rightEyePosition)")
            }
        }
        
        let imageBuffer = toImageBuffer(image: image)
    }
    
    func toImageBuffer(image: CIImage) -> CVImageBuffer? {
        var pixelBuffer: CVPixelBuffer? = nil
        let status = CVPixelBufferCreate(kCFAllocatorDefault, 224, 224, kCVPixelFormatType_32BGRA, nil, &pixelBuffer)
        if (status == kCVReturnSuccess){
            guard let _pixelBuffer = pixelBuffer else { fatalError() }
            CVPixelBufferLockBaseAddress(_pixelBuffer, CVPixelBufferLockFlags.init(rawValue: 0))
            let ciContext = CIContext()
            let cgImage = ciContext.createCGImage(image, from: image.extent)
            let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
            let context = CGContext(data: data, width: Int(224), height: Int(224), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue)
            
            context?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: 224, height: 224))
            
            CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.init(rawValue: 0))
            return pixelBuffer! as CVImageBuffer
        }
        else{
            print("convert fail")
        }
        return nil
    }
}
