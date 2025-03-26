//
//  NSItemProvider+DictionaryRetrieval.swift
//  SkyMarkShareExtension
//
//  Created by Joseph Wardell on 11/27/24.
//

import Foundation
import UniformTypeIdentifiers

@available(macOS 11, iOS 14, *)
public extension NSItemProvider {
    
    func propertyListAsDictionary() async -> [String: Any]? {
        let typeIdentifier = UTType.propertyList.identifier

        guard hasItemConformingToTypeIdentifier(typeIdentifier),
              let dict = try? await loadItem(forTypeIdentifier: typeIdentifier) as? NSDictionary,
              let jsValues = dict[NSExtensionJavaScriptPreprocessingResultsKey] as? [String: Any]
        else { return nil }
        
        return jsValues
    }
    
    func getValue<Output>(for typeIdentifier: UTType) async -> Output? {
        guard hasItemConformingToTypeIdentifier(typeIdentifier.identifier) else { return nil }
        
        do {
            
            let result = try await loadItem(forTypeIdentifier: typeIdentifier.identifier)
            return result as? Output
        }
        catch {
            print(error)
            return nil
        }
    }
    
    func getURL() async -> URL? {
        let typeIdentifier = UTType.url
        guard hasItemConformingToTypeIdentifier(typeIdentifier.identifier) else { return nil }
        let result = try? await loadItem(forTypeIdentifier: typeIdentifier.identifier)
        return result?.asURL
    }
}
