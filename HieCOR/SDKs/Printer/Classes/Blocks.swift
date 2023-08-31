//
//  Blocks.swift
//  Printer
//
//  Created by GongXiang on 12/10/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

import Foundation

public protocol Attribute {
    
    var attribute: [UInt8] { get }
}

public extension String {
    
//    struct Encoding {
//
//        static let GB_18030_2000 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue)))
//    }
}

public struct TextBlock: Block {
    
    let content: String
    let attributes: [Attribute]?
    
    public init(_ content: String, attributes: [Attribute]? = nil) {
        self.content = content
        self.attributes = attributes
    }
    
    public var data: Data {
        
        var result = Data()
        
        if let attrs = attributes {
            result.append(Data(bytes: attrs.flatMap { $0.attribute }))
        }
        
        if let cd = content.data(using: String.GBEncoding.GB_18030_200033) {
            result.append(cd)
        }
        
        return result
    }
    public func dataForImage(using encoding: String.Encoding) -> Data {
        var result = Data()
        
        if let attrs = attributes {
            result.append(Data(attrs.flatMap { $0.attribute }))
        }
        
        if let cd = content.data(using: encoding) {
            result.append(cd)
        }
        
        return result
    }
}

public extension TextBlock {
    
    enum PredefinedAttribute: Attribute {
        
        public enum ScaleLevel: UInt8 {
            
            case l0 = 0x00
            case l1 = 0x11
            case l2 = 0x22
            case l3 = 0x33
            case l4 = 0x44
            case l5 = 0x55
            case l6 = 0x66
            case l7 = 0x77
        }
        
        case alignment(NSTextAlignment)
        case bold
        case underline
        case small
        case light
        case scale(ScaleLevel)
        case feed(UInt8)
        case smallFont
        case normalSize
        case boldFont
        case normalBoldFont
        
        public var attribute: [UInt8] {
            switch self {
            case let .alignment(v):
                return ESC_POSCommand.justification(v == .left ? 0 : v == .center ? 1 : 2).rawValue
            case .bold:
                return ESC_POSCommand.emphasize(mode: true).rawValue
            case .underline:
                return ESC_POSCommand.underline(mode: 2).rawValue
            case .small:
                return ESC_POSCommand.font(1).rawValue
            case .light:
                return ESC_POSCommand.color(n: 1).rawValue
            case let .scale(v):
                return [0x1D, 0x21, v.rawValue]
            case .smallFont:
                return [0x1B, 0x21, 0x03]
            case .normalSize:
                return[0x1B, 0x21, 0x06]
            case .boldFont:
                return [0x1B, 0x21, 0x12]
            case .normalBoldFont:
                return [0x1B, 0x21, 0x08]
                
            case let .feed(v):
                return ESC_POSCommand.feed(points: v).rawValue
            }
        }
    }
    
    init(content: String, predefined attributes: PredefinedAttribute...) {
        self.init(content, attributes: attributes)
    }
}

public extension TextBlock {
    
    static func title(_ content: String) -> Block {
        return TextBlock(content: content, predefined: .scale(.l1), .alignment(.center), .underline)
    }
    
    static func total(_ content: String) -> Block {
        return TextBlock(content: content, predefined: .bold, .alignment(.center))
    }
    
    static func kv(printDensity: Int, fontDensity: Int, k: String, v: String, attributes: [Attribute]? = nil) -> Block {
        
        var num = printDensity / fontDensity
        
        let string = k + v
        
        for c in string {
            if (c >= "\u{2E80}" && c <= "\u{FE4F}") || c == "\u{FFE5}"{
                num -= 2
            } else  {
                num -= 1
            }
        }
        
        var contents = stride(from: 0, to: num, by: 1).map { _ in " " }
        contents.insert(k, at: 0)
        contents.append(v)
        
        return TextBlock(contents.joined(), attributes: attributes)
    }
    
    static func dividing(printDensity: Int, fontDensity: Int, separatorProvider: @escaping ((Int, Int) -> String) = { _, _ in "-"}) -> Block {
        
        let num = printDensity / fontDensity
        
        let content = stride(from: 0, to: num, by: 1).map { String(separatorProvider($0, num)) }.joined()
        
        return TextBlock(content: content, predefined: .alignment(.center))
    }
    
    static func customSize(printDensity: Int, fontDensity: Int, isBold: Bool, string: String, attributes: [Attribute]? = nil) -> Block {
        
        let num = isBold ? (printDensity / fontDensity) / 2 : (printDensity / fontDensity)
        
        if string.count > num {
            var newString = String()
            var count = num
            var recent = Int()
            
            for (i,v) in string.enumerated() {
                newString.append(v)
                if newString.hasSuffix("\n") {
                    recent = i - (count > num ? count - num : num)
                    count = count + recent
                }
                if i == (count == num ? count - 1 : count) {
                  //  newString.append("\n")
                    count += num
                    recent = 0
                }
            }
            newString = newString.replacingOccurrences(of: "\n\n", with: "\n")
            return TextBlock(newString, attributes: attributes)
        }
        
        return TextBlock(string, attributes: attributes)
    }
    
}

public struct BlockConstructor {
    
    internal let content: Any
    
    public init(_ content: Any) {
        self.content = content
    }
    
    public var title: Block {
        return TextBlock.title(String(describing: content))
    }
    
    public var total: Block {
        return TextBlock.total(String(describing: content))
    }
    
    public var text: Block {
        return TextBlock(String(describing: content))
    }
    
    public func dividing(printDensity: Int, fontDensity: Int) -> Block {
        
        if let c = content as? String {
            return TextBlock.dividing(printDensity: printDensity, fontDensity: fontDensity, separatorProvider: { _, _ in
                return c
            })
        } else {
            return TextBlock.dividing(printDensity: 384, fontDensity: 12)
        }
    }
    
    public func customSize(printDensity: Int, fontDensity: Int,isBold: Bool = false, attributes: [TextBlock.PredefinedAttribute]? = nil) -> Block {
        return TextBlock.customSize(printDensity: printDensity, fontDensity: fontDensity, isBold: isBold, string: String(describing: content), attributes: attributes)
    }
    
    public func blank(_ l: UInt8 = 1) -> Block {
        return Data()
    }
    
    public func kv(printDensity: Int, fontDensity: Int, k: String, v: String, attributes: [TextBlock.PredefinedAttribute]? = nil) -> Block {
        return TextBlock.kv(printDensity: printDensity, fontDensity: fontDensity, k: k, v: v, attributes: attributes)
    }
    
//    // image
//    static func image(_ im: Image, attributes: TicketImage.PredefinedAttribute...) -> Block {
//        return Block(TicketImage(im, attributes: attributes))
//    }
}

public extension String {
    
    public var bc: BlockConstructor {
        return BlockConstructor(self)
    }
}

public extension Character {
    
    public var bc: BlockConstructor {
        return BlockConstructor(self)
    }
}

public extension Int {
    
    public var bc: BlockConstructor {
        return BlockConstructor(self)
    }
}

public extension Double {
    
    public var bc: BlockConstructor {
        return BlockConstructor(self)
    }
}
