//
//  NSSecureCoding+URL.swift
//  SkyMark Shared Views
//
//  Created by Joseph Wardell on 12/1/24.
//

import Foundation

public extension NSSecureCoding {
    
    var asURL: URL? {
        
        // there are many ways that we could be given an URL
        // try them from most to least likely
        
        // 1. as an URL
        if let url = self as? URL {
            return url
        }
        
        // 2. as a string that is in the form of an URL
        else if let string = self as? String,
                let url = URL(string: string) {
            return url
        }
        
        // 3. as a string encoded into a Data object
        else if let data = self as? Data,
                let string = String(data: data, encoding: .utf8),
                let url = URL(string: string) {
            return url
        }
        
        // 4. as some other object that can be stringified into a string that is in the form of an URL
        else if let stringifiable = self as? CustomStringConvertible,
                let url = URL(string: stringifiable.description) {
            return url
        }
        
        return nil
    }
}
