//
//  Person.swift
//  NameFace
//
//  Created by Paul Houghton on 26/11/2020.
//

import Foundation

struct Person: Identifiable, Codable {
    var id = UUID()
    var name: String
    
    var photoFile: String {
        return "\(self.id)"
    }
}
