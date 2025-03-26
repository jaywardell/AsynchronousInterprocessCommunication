//
//  NSItemProvider+Objects.swift
//  Image Reader
//
//  Created by Joseph Wardell on 3/26/25.
//

import Foundation
import CoreGraphics
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
import CoreGraphics

@available(macOS 10.15, iOS 13, *)
public extension NSItemProvider {
    
    @MainActor
    @preconcurrency
    func getObject<T: NSObject>(type: T.Type) async throws -> sending T
    where T: NSItemProviderReading {
        try await withCheckedThrowingContinuation { continuation in
            if canLoadObject(ofClass: T.self) {
                loadObject(ofClass: T.self) { object, _ in
                    guard let image = object as? T else {
                        return continuation.resume(throwing: NSError())
                    }
                    let tosend: T = image.copy() as! T
                    continuation.resume(returning: tosend)
                }
            }
            else {
                continuation.resume(throwing: NSError())
            }
        }
    }
    
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
        guard let cgImage = image.cgImage
        else { return nil }
        
        return cgImage
#endif
    }
}

