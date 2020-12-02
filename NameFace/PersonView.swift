//
//  PersonView.swift
//  NameFace
//
//  Created by Paul Houghton on 01/12/2020.
//

import SwiftUI

struct PersonRow: View {
    var name: String
    var photoFile: String
    
    var body: some View {
        HStack {
            Text(self.photoFile)
            Text(self.name)
            Spacer()
        }
    }
}

struct PersonView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        PersonView()
        PersonRow(name: "Paul Houghton", photoFile: "12345  ")
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
