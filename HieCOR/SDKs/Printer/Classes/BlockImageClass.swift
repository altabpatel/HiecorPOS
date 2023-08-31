//
//  Block.swift
//  Ticket
//
//  Created by gix on 2019/6/30.
//  Copyright © 2019 gix. All rights reserved.
//


import Foundation

public protocol PrintableForImageShow {
    func data(using encoding: String.Encoding) -> Data
}

public protocol BlockDataProviderForImage: PrintableForImageShow { }

public protocol AttributeForImage {
    var attribute: [UInt8] { get }
}

public struct BlockForImage: PrintableForImageShow {

    public static var defaultFeedPoints: UInt8 = 70
    
    private let feedPoints: UInt8
    private let dataProvider: BlockDataProviderForImage
    
    public init(_ dataProvider: BlockDataProviderForImage, feedPoints: UInt8 = BlockForImage.defaultFeedPoints) {
        self.feedPoints = feedPoints
        self.dataProvider = dataProvider
    }
    
    public func data(using encoding: String.Encoding) -> Data {
        return dataProvider.data(using: encoding) + Data.print(feedPoints)
    }
}

public extension BlockForImage {
    // blank line
    static var blank = BlockForImage(Blank())
    
    static func blank(_ line: UInt8) -> BlockForImage {
        return BlockForImage(Blank(), feedPoints: BlockForImage.defaultFeedPoints * line)
    }
//
//    // qr
//    static func qr(_ content: String) -> Block {
//        return Block(QRCode(content))
//    }
//
//    // title
//    static func title(_ content: String) -> Block {
//        return Block(Text.title(content))
//    }
//
//    // plain text
//    static func plainText(_ content: String) -> Block {
//        return Block(Text.init(content))
//    }
//
//    static func text(_ text: Text) -> Block {
//        return Block(text)
//    }
//
//    // key    value
//    static func kv(k: String, v: String) -> Block {
//        return Block(Text.kv(k: k, v: v))
//    }
//
    // dividing
    static var dividing = BlockForImage(Dividing.default)
    
    // image
    static func image(_ im: Image, attributes: TicketImage.PredefinedAttribute...) -> BlockForImage {
        return BlockForImage(TicketImage(im, attributes: attributes))
    }
    
}
