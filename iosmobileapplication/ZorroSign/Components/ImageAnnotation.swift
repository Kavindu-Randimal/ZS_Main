//
//  ImageAnnotation.swift
//  ZorroSign
//
//  Created by Apple on 12/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import PDFKit

@available(iOS 11.0, *)
public class ImageAnnotation: PDFAnnotation {
    
    private var _image: UIImage?
    
    public init(imageBounds: CGRect, image: UIImage?) {
        self._image = image
        super.init(bounds: imageBounds, forType: .stamp, withProperties: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(with box: PDFDisplayBox, in context: CGContext) {
        guard let cgImage = self._image?.cgImage else {
            return
        }
        let drawingBox = self.page?.bounds(for: box)
        //Virtually changing reference frame since the context is agnostic of them. Necessary hack.
        context.draw(cgImage, in: self.bounds.applying(CGAffineTransform(
            translationX: (drawingBox?.origin.x)! * -1.0,
            y: (drawingBox?.origin.y)! * -1.0)))
    }
    
}
