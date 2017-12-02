//
//  VideoEncoder.swift
//  CoreMLTest
//
//  Created by Supphawit Getmark on 29/11/2560 BE.
//  Copyright © 2560 Supphawit Getmark. All rights reserved.
//

import Foundation
import VideoToolbox
import HaishinKit
import AVFoundation

class VideoEncoder {
    
    static let defaultWidth:Int32 = 480
    static let defaultHeight:Int32 = 272
    static let defaultBitrate:UInt32 = 160 * 1024
    static let defaultScalingMode:String = "Trim"
    
    static let defaultAttributes:[NSString: AnyObject] = [
        kCVPixelBufferIOSurfacePropertiesKey: [:] as AnyObject,
        kCVPixelBufferOpenGLESCompatibilityKey: kCFBooleanTrue,
        ]
    
    static let defaultDataRateLimits:[Int] = [0, 0]
    
    internal(set) var running:Bool = false
    private(set) var status:OSStatus = noErr
    
    private var _session:VTCompressionSession? = nil
    private var session:VTCompressionSession? {
        get {
            if (_session == nil)  {
                guard VTCompressionSessionCreate(
                    kCFAllocatorDefault,
                    VideoEncoder.defaultWidth,
                    VideoEncoder.defaultHeight,
                    kCMVideoCodecType_H264,
                    nil,
                    VideoEncoder.defaultAttributes as CFDictionary?,
                    nil,
                    callback,
                    unsafeBitCast(self, to: UnsafeMutableRawPointer.self),
                    &_session
                    ) == noErr else {
                        return nil
                }
//                invalidateSession = false
//                status = VTSessionSetProperties(_session!, properties as CFDictionary)
//                status = VTCompressionSessionPrepareToEncodeFrames(_session!)
            }
            return _session
        }
        set {
            if let session:VTCompressionSession = _session {
                VTCompressionSessionInvalidate(session)
            }
            _session = newValue
        }
    }
    
    
    func encodeImageBuffer(_ imageBuffer:CVImageBuffer, presentationTimeStamp:CMTime, duration:CMTime) {
        guard let session:VTCompressionSession = session else {
            return
        }
        var flags:VTEncodeInfoFlags = VTEncodeInfoFlags()
        VTCompressionSessionEncodeFrame(
            session,
            imageBuffer,
            presentationTimeStamp,
            duration,
            nil,
            nil,
            &flags
        )
    }
    
    
    private var callback:VTCompressionOutputCallback = {(
        outputCallbackRefCon:UnsafeMutableRawPointer?,
        sourceFrameRefCon:UnsafeMutableRawPointer?,
        status:OSStatus,
        infoFlags:VTEncodeInfoFlags,
        sampleBuffer:CMSampleBuffer?) in
        guard let sampleBuffer:CMSampleBuffer = sampleBuffer , status == noErr else {
            return
        }
        
//        encoder.formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer)
//        encoder.delegate?.sampleOutput(video: sampleBuffer)
    }
    
    init(){
        var httpStream:HTTPStream = HTTPStream()
        httpStream.attachCamera(DeviceUtil.device(withPosition: .back))
        httpStream.publish("hello")
        var httpService:HLSService = HLSService(domain: "", type: "_http._tcp", name: "lf", port: 8080)
        httpService.startRunning()
        httpService.addHTTPStream(httpStream)
    
    }
    
}
