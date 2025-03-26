//
//  NSItemProvider+CGImage.swift
//  AsynchronousInterprocessCommunication
//
//  Created by Joseph Wardell on 3/26/25.
//

import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
import CoreGraphics

public extension NSItemProvider {
    
    /// returns a CGImage from the NSItemProvider, assuming that one is available
    /// - Returns: a `CGImage` or nil if none is available
    @MainActor
    func getCGImage() async throws -> CGImage? {
        
#if canImport(AppKit)
        if #available(macOS 13.0, *) {
            let image = try await getObject(type: NSImage.self)
            guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
            else { return nil }
            return cgImage
        }
        fatalError("\(#function) is only available in macOS 10.15 or iOS 13 or later")

#elseif canImport(UIKit)
        let image = try await getObject(type: UIImage.self)
        guard let cgImage = image.cgImage else { return nil }
        
        return cgImage
#endif
    }

}
