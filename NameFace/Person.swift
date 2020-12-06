//
//  Person.swift
//  NameFace
//
//  Created by Paul Houghton on 26/11/2020.
//
import SwiftUI
import Foundation

struct Person: Identifiable, Codable, Comparable {
    var id = UUID()
    var name: String
    
    var photoFile: String {
        return "\(self.id).jpg"
    }
    
    static func < (lhs: Person, rhs: Person) -> Bool {
        lhs.name < rhs.name
    }
    
    static func loadPhoto(photoFile: URL) -> UIImage? {
        if let uiImage = UIImage(contentsOfFile: photoFile.path) {
            return uiImage
        } else {
            return nil
        }
    }
    
    static func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
}
