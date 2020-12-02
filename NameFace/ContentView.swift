//
//  ContentView.swift
//  NameFace
//
//  Created by Paul Houghton on 25/11/2020.
//

import SwiftUI

enum SheetMode {
    case imagePicker, imageSaver
}

struct ContentView: View {
    @State private var showingSheet = false
    @State private var sheetMode: SheetMode = .imagePicker
//    @State private var showingImagePicker = false
//    @State private var showingImageSaver = false
    
    @State private var personImage: UIImage?

    
    @State var people: [Person] = [Person]()
    
    var body: some View {
        NavigationView {
            VStack {
                List(people, id: \.id) { person in
                    PersonRow(name: person.name, photoFile: person.photoFile)
                }
            }
            .navigationTitle("NameFace")
            .navigationBarItems(trailing: Button("Add") {
                    self.showingSheet = true
                    self.sheetMode = .imagePicker
                }
            )
        }
        .sheet(isPresented: $showingSheet, onDismiss: loadImage) {
            
            if (self.sheetMode == .imagePicker) {
                ImagePicker(image: self.$personImage)
            }
            else {
                PersonRow(name: "Test", photoFile: "TEST")
            }
        }
//        .sheet(isPresented: $showingImageSaver, content: {
//            PersonRow(name: "Test", photoFile: "TEST")
//        })
        
    }
    
    func loadImage() {
        // load image
    }
}

struct ContentView_Previews: PreviewProvider {
    //let person = Person(name: "Paul")
    static let people = [
        Person(name: "Paul Houghton"),
        Person(name: "Shane Houghton")
    ]
    
    static var previews: some View {
        ContentView(people: people)
    }
}
