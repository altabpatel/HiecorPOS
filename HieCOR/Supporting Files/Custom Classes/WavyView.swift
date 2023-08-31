//
//  WavyView.swift
//  HieCOR
//
//  Created by Deftsoft on 11/12/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import Foundation

class WavyView1: UIView {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil // TODO
    }
    
    override func draw(_ rect: CGRect) {
        // Fill the whole background
        UIColor(red: 1, green: 1, blue: 1, alpha: 1).set()
        let bg = UIBezierPath(rect: rect)
        bg.fill()
        
        // Add the first sine wave filled with a very transparent white
        let top1: CGFloat = 10.0
        let wave1 = wavyPath(rect: CGRect(x: 0, y: frame.height - top1 - 1, width: frame.width, height: frame.height - top1), periods: 20, amplitude: 5, start: 0.3)
        UIColor(red: 1, green: 1, blue: 1, alpha: 1).set()
        wave1.stroke()
        
    }
    
}

class WavyView2 : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil // TODO
    }
    
    override func draw(_ rect: CGRect) {
        // Fill the whole background
        UIColor(red: 1, green: 1, blue: 1, alpha: 1).set()
        let bg = UIBezierPath(rect: rect)
        bg.fill()
        
        // Add the first sine wave filled with a very transparent white
        let top2: CGFloat = 10.0
        let wave2 = wavyPath(rect: CGRect(x: 0, y: 1, width: frame.width, height: frame.height - top2), periods: 20, amplitude: 5, start: 0.8)
        UIColor(red: 1, green: 1, blue: 1, alpha: 1).set()
        wave2.stroke()
        
    }
    
}

extension UIView {
    func wavyPath(rect: CGRect, periods: Double, amplitude: Double, start: Double) -> UIBezierPath {
        let path = UIBezierPath()
        
        // start in the bottom left corner
        path.move(to: CGPoint(x: rect.minX - 1, y: rect.minY))
        
        let radsPerPoint = Double(rect.width) / periods / 2.0 / Double.pi
        let radOffset = start * 2 * Double.pi
        let xOffset = Double(rect.minX)
        let yOffset = Double(rect.minY) + amplitude
        // This loops through the width of the frame and calculates and draws each point along the size wave
        // Adjust the "by" value as needed. A smaller value gives smoother curve but takes longer to draw. A larger value is quicker but gives a rougher curve.
        for x in stride(from: 0, to: Double(rect.width), by: 0.01) {
            let rad = Double(x) / radsPerPoint + radOffset
            let y = sin(rad) * amplitude
            
            path.addLine(to: CGPoint(x: x + xOffset, y: y + yOffset))
        }
        
        let context = UIGraphicsGetCurrentContext()
        
        
        // Shadow Declarations
        let shadowOffset = CGSize(width: 0, height: 0)
        let shadowBlurRadius: CGFloat = 5
        
        // Bezier 2 Drawing
        
        path.move(to: CGPoint(x: 30.5, y: 90.5))
        path.addLine(to: CGPoint(x: 115.5, y: 90.5))
        context?.saveGState()
        context?.setShadow(offset: shadowOffset, blur: shadowBlurRadius)
        UIColor.black.setStroke()
        path.lineWidth = 0.1
        path.stroke()
        context!.restoreGState()
        
        
        // Add the last point on the sine wave at the right edge
        let rad = Double(rect.width) / radsPerPoint + radOffset
        let y = sin(rad) * amplitude
        
        path.addLine(to: CGPoint(x: Double(rect.maxX), y: y + yOffset))
        
        // Add line from the end of the sine wave to the bottom right corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        // Close the path
        path.close()
        
        return path
    }

}
