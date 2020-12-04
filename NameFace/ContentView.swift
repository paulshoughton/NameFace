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
    @State private var personName: String = ""
    
    @State var people: [Person] = [Person]()
    
    var body: some View {
        NavigationView {
            VStack {
                List(people, id: \.id) { person in
                    PersonRow(name: person.name, photoFile: person.photoFile)
                }
            }
            .navigationTitle("NameFace")
            .navigationBarItems(
                trailing:
                    Button("Add") {
                        self.showingSheet = true
                        self.sheetMode = .imagePicker
                    }
            )
        }
        .sheet(isPresented: $showingSheet, onDismiss: sheetDismissed) {
            
            if (self.sheetMode == .imagePicker) {
                ImagePicker(image: self.$personImage)
            }
            else {
                if let photo = self.personImage {
                    PersonForm(photo: Image(uiImage: photo), name: self.$personName)
                }
                else {
                    PersonForm(photo: nil, name:self.$personName)
                }
                
            }
        }
        
    }
    
    func sheetDismissed() {
        if self.sheetMode == .imagePicker
            && self.personImage != nil {
            // Open the sheet in the image saver mode...
            self.sheetMode = .imageSaver
            self.showingSheet = true
        }
        else if self.sheetMode == .imageSaver {
            
            // If the image was saved
            if 1==1 {
                // PROPER LOGIC CHECK NEEDED
                saveNameFace()
            }

            // Prepare for next photo to be selected
            reset()
        }
    }
    
    func saveNameFace() {
        print("Name: \(self.personName)")
    }
    
    // Reset data ready for next
    func reset() {
        self.personImage = nil
        self.personName = ""
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
