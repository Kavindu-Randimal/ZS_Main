//
//  ExUIImageView.swift
//  ZorroSign
//
//  Created by Apple on 28/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

extension UIImage {
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / (size.width)
        let heightRatio = targetSize.height / (size.height)
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: (size.width) * heightRatio, height: (size.height) * heightRatio)
        } else {
            newSize = CGSize(width: (size.width) * widthRatio, height: (size.height) * widthRatio)
        }
        
        let XPt = ((targetSize.width - newSize.width)/2)/2
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width:newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.5)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func imageByMakingWhiteBackgroundTransparent() -> UIImage? {
        
        if let rawImageRef = self.cgImage {
            
            let colorMasking: [CGFloat] = [200, 255, 200, 255, 200, 255]
            
            UIGraphicsBeginImageContext(self.size)
            
            if let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking) {
                //CGImageCreateWithMaskingColors(rawImageRef, colorMasking) {
                
                UIGraphicsGetCurrentContext()?.translateBy(x: 0.0, y: self.size.height)
                //CGContextTranslateCTM(UIGraphicsGetCurrentContext()!, 0.0, self.size.height)
                
                UIGraphicsGetCurrentContext()?.scaleBy(x: 1.0, y: -1.0)
                //CGContextScaleCTM(UIGraphicsGetCurrentContext()!, 1.0, -1.0)
                
                UIGraphicsGetCurrentContext()?.draw(maskedImageRef, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
                //CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, self.size.width, self.size.height), maskedImageRef)
                
                let result = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                
                return result
            }
        }
        
        return nil
    }
    
    func imageByMakingLightBrownBackgroundTransparent() -> UIImage? {
        
        if let rawImageRef = self.cgImage {
            
            let colorMasking: [CGFloat] = [200, 200, 200, 200, 200, 160]
            
            UIGraphicsBeginImageContext(self.size)
            
            if let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking) {
                //CGImageCreateWithMaskingColors(rawImageRef, colorMasking) {
                
                UIGraphicsGetCurrentContext()?.translateBy(x: 0.0, y: self.size.height)
                //CGContextTranslateCTM(UIGraphicsGetCurrentContext()!, 0.0, self.size.height)
                
                UIGraphicsGetCurrentContext()?.scaleBy(x: 1.0, y: -1.0)
                //CGContextScaleCTM(UIGraphicsGetCurrentContext()!, 1.0, -1.0)
                
                UIGraphicsGetCurrentContext()?.draw(maskedImageRef, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
                //CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, self.size.width, self.size.height), maskedImageRef)
                
                let result = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                
                return result
            }
        }
        
        return nil
    }
    
    func imageByMakingDarkBrownBackgroundTransparent() -> UIImage? {
        
        if let rawImageRef = self.cgImage {
            
            let colorMasking: [CGFloat] = [200, 200, 200, 200, 200, 160]
            
            UIGraphicsBeginImageContext(self.size)
            
            if let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking) {
                //CGImageCreateWithMaskingColors(rawImageRef, colorMasking) {
                
                UIGraphicsGetCurrentContext()?.translateBy(x: 0.0, y: self.size.height)
                //CGContextTranslateCTM(UIGraphicsGetCurrentContext()!, 0.0, self.size.height)
                
                UIGraphicsGetCurrentContext()?.scaleBy(x: 1.0, y: -1.0)
                //CGContextScaleCTM(UIGraphicsGetCurrentContext()!, 1.0, -1.0)
                
                UIGraphicsGetCurrentContext()?.draw(maskedImageRef, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
                //CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, self.size.width, self.size.height), maskedImageRef)
                
                let result = UIGraphicsGetImageFromCurrentImageContext()
                
                UIGraphicsEndImageContext()
                
                return result
            }
        }
        
        return nil
    }
    
    func removeWhitebg() -> UIImage? {
        guard let inputCGImage = self.cgImage else {
            print("unable to get cgImage")
            return nil
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return nil
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            print("unable to get context data")
            return nil
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        
        for y in 0 ..< Int(height) {
            for x in 0 ..< Int(width) {
                let point = CGPoint(x: x, y: y)
                let pixelInfo: Int = ((width * Int(point.y)) + Int(point.x))
                
                let red =  pixelBuffer[pixelInfo].redComponent
                let green = pixelBuffer[pixelInfo].greenComponent
                let blue = pixelBuffer[pixelInfo].blueComponent
                let alpha = pixelBuffer[pixelInfo].alphaComponent
                
                if (red >= 230 && green >= 230 && blue >= 230) {
                    
                    pixelBuffer[pixelInfo] = RGBA32(red: 0, green: 0, blue: 0, alpha: 0)
                    
                } else {
                    
                    pixelBuffer[pixelInfo] = RGBA32(red: red, green: green, blue: blue, alpha: alpha)
                    
                }
                
            }
        }
        
        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: self.scale, orientation: self.imageOrientation)
        
        return outputImage
    }
    
    func removeLightBrownbg() -> UIImage? {
        guard let inputCGImage = self.cgImage else {
            print("unable to get cgImage")
            return nil
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return nil
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            print("unable to get context data")
            return nil
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        
        for y in 0 ..< Int(height) {
            for x in 0 ..< Int(width) {
                let point = CGPoint(x: x, y: y)
                let pixelInfo: Int = ((width * Int(point.y)) + Int(point.x))
                
                let red =  pixelBuffer[pixelInfo].redComponent
                let green = pixelBuffer[pixelInfo].greenComponent
                let blue = pixelBuffer[pixelInfo].blueComponent
                let alpha = pixelBuffer[pixelInfo].alphaComponent
                
                if (red >= 200 && green >= 200 && blue >= 160) {
                    
                    pixelBuffer[pixelInfo] = RGBA32(red: 0, green: 0, blue: 0, alpha: 0)
                    
                } else {
                    
                    pixelBuffer[pixelInfo] = RGBA32(red: red, green: green, blue: blue, alpha: alpha)
                    
                }
                
            }
        }
        
        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: self.scale, orientation: self.imageOrientation)
        
        return outputImage
    }
    
    func removeDarkBrownbg() -> UIImage? {
        guard let inputCGImage = self.cgImage else {
            print("unable to get cgImage")
            return nil
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return nil
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            print("unable to get context data")
            return nil
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        
        for y in 0 ..< Int(height) {
            for x in 0 ..< Int(width) {
                let point = CGPoint(x: x, y: y)
                let pixelInfo: Int = ((width * Int(point.y)) + Int(point.x))
                
                let red =  pixelBuffer[pixelInfo].redComponent
                let green = pixelBuffer[pixelInfo].greenComponent
                let blue = pixelBuffer[pixelInfo].blueComponent
                let alpha = pixelBuffer[pixelInfo].alphaComponent
                
                if (red >= 175 && green >= 175 && blue >= 175) {
                    
                    pixelBuffer[pixelInfo] = RGBA32(red: 0, green: 0, blue: 0, alpha: 0)
                    
                } else {
                    
                    pixelBuffer[pixelInfo] = RGBA32(red: red, green: green, blue: blue, alpha: alpha)
                    
                }
                
            }
        }
        
        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: self.scale, orientation: self.imageOrientation)
        
        return outputImage
    }
    
    func convertGray() -> UIImage? {
        guard let inputCGImage = self.cgImage else {
            print("unable to get cgImage")
            return nil
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return nil
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            print("unable to get context data")
            return nil
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        
        for y in 0 ..< Int(height) {
            for x in 0 ..< Int(width) {
                let point = CGPoint(x: x, y: y)
                let pixelInfo: Int = ((width * Int(point.y)) + Int(point.x))
                
                let red =  pixelBuffer[pixelInfo].redComponent
                let green = pixelBuffer[pixelInfo].greenComponent
                let blue = pixelBuffer[pixelInfo].blueComponent
                let alpha = pixelBuffer[pixelInfo].alphaComponent
                
                if (red >= 175 && green >= 175 && blue >= 175) {
                    
                    pixelBuffer[pixelInfo] = RGBA32(red: 0, green: 0, blue: 0, alpha: 0)
                    
                } else {
                    
                    pixelBuffer[pixelInfo] = RGBA32(red: red, green: green, blue: blue, alpha: alpha)
                    
                }
                //Turn to gray image
                var grayscale = Double(red) * 0.3 + Double(green) * 0.59 + Double(blue) * 00.11;
                pixelBuffer[pixelInfo] = RGBA32(red: UInt8(grayscale), green: UInt8(grayscale), blue: UInt8(grayscale), alpha: pixelBuffer[pixelInfo].alphaComponent)
                
            }
        }
        
        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: self.scale, orientation: self.imageOrientation)
        
        return outputImage
    }
    
    func removeExtremebg() -> UIImage? {
        guard let inputCGImage = self.cgImage else {
            print("unable to get cgImage")
            return nil
        }
        let colorSpace       = CGColorSpaceCreateDeviceRGB()
        let width            = inputCGImage.width
        let height           = inputCGImage.height
        let bytesPerPixel    = 4
        let bitsPerComponent = 8
        let bytesPerRow      = bytesPerPixel * width
        let bitmapInfo       = RGBA32.bitmapInfo
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            print("unable to create context")
            return nil
        }
        context.draw(inputCGImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let buffer = context.data else {
            print("unable to get context data")
            return nil
        }
        
        let pixelBuffer = buffer.bindMemory(to: RGBA32.self, capacity: width * height)
        
        for y in 0 ..< Int(height) {
            for x in 0 ..< Int(width) {
                let point = CGPoint(x: x, y: y)
                let pixelInfo: Int = ((width * Int(point.y)) + Int(point.x))
                
                let red =  pixelBuffer[pixelInfo].redComponent
                let green = pixelBuffer[pixelInfo].greenComponent
                let blue = pixelBuffer[pixelInfo].blueComponent
                let alpha = pixelBuffer[pixelInfo].alphaComponent
                
                if (red >= 100 && green >= 100 && blue >= 100) {
                    
                    pixelBuffer[pixelInfo] = RGBA32(red: 0, green: 0, blue: 0, alpha: 0)
                    
                } else {
                    
                    pixelBuffer[pixelInfo] = RGBA32(red: red, green: green, blue: blue, alpha: alpha)
                    
                }
                
            }
        }
        
        let outputCGImage = context.makeImage()!
        let outputImage = UIImage(cgImage: outputCGImage, scale: self.scale, orientation: self.imageOrientation)
        
        return outputImage
    }
    
    struct RGBA32: Equatable {
        private var color: UInt32
        
        var redComponent: UInt8 {
            return UInt8((color >> 24) & 255)
        }
        
        var greenComponent: UInt8 {
            return UInt8((color >> 16) & 255)
        }
        
        var blueComponent: UInt8 {
            return UInt8((color >> 8) & 255)
        }
        
        var alphaComponent: UInt8 {
            return UInt8((color >> 0) & 255)
        }
        
        init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
            let red   = UInt32(red)
            let green = UInt32(green)
            let blue  = UInt32(blue)
            let alpha = UInt32(alpha)
            color = (red << 24) | (green << 16) | (blue << 8) | (alpha << 0)
        }
        
        static let red     = RGBA32(red: 255, green: 0,   blue: 0,   alpha: 255)
        static let green   = RGBA32(red: 0,   green: 255, blue: 0,   alpha: 255)
        static let blue    = RGBA32(red: 0,   green: 0,   blue: 255, alpha: 255)
        static let white   = RGBA32(red: 255, green: 255, blue: 255, alpha: 255)
        static let black   = RGBA32(red: 0,   green: 0,   blue: 0,   alpha: 255)
        static let magenta = RGBA32(red: 255, green: 0,   blue: 255, alpha: 255)
        static let yellow  = RGBA32(red: 255, green: 255, blue: 0,   alpha: 255)
        static let cyan    = RGBA32(red: 0,   green: 255, blue: 255, alpha: 255)
        
        static let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        
        static func ==(lhs: RGBA32, rhs: RGBA32) -> Bool {
            return lhs.color == rhs.color
        }
    }
    
    public func getPixelColor(pos: CGPoint) -> UIColor {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
}
