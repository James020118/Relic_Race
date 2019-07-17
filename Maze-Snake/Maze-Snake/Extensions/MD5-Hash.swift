//
//  Graph-Checksum.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-06-27.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import CommonCrypto

extension NSData {
    func MD5() -> String {
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let md5Buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        
        CC_MD5(bytes, CC_LONG(length), md5Buffer)
        let output = NSMutableString(capacity: Int(CC_MD5_DIGEST_LENGTH * 2))
        for i in 0..<digestLength {
            output.appendFormat("%02x", md5Buffer[i])
        }
        
        return NSString(format: output) as String
    }
}


