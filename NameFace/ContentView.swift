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
                    NavigationLink(
                        destination:
                            PersonView(person: person)
                    ) {
                        PersonRow(person: person)
                    }
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
        .onAppear(perform: loadDataFromDocumentsDirectory)
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
//        print("Name: \(self.personName)")

        let person = Person(name: personName)
        
        // Give the photo a name base on the UUID of the person.
        let url = Person.getDocumentsDirectory().appendingPathComponent(person.photoFile)
        
        if let jpegData = personImage?.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: url, options: [.atomicWrite, .completeFileProtection])
        }
        
        self.people.append(person)
        saveDataToDocumentsDirectory()
    }
    
    // Reset data ready for next
    func reset() {
        self.personImage = nil
        self.personName = ""
    }
    
    func saveDataToDocumentsDirectory() {
//        let str = "Test Message"
        let encoder = JSONEncoder()

        if let data = try? encoder.encode(self.people) {
            let url = Person.getDocumentsDirectory().appendingPathComponent("NameFaceData.json")
            
            do {
                try data.write(to: url)
//                let input = try String(contentsOf: url)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadDataFromDocumentsDirectory() {
        let url = Person.getDocumentsDirectory().appendingPathComponent("NameFaceData.json")
        
        let decoder = JSONDecoder()
        
        if let data = try? Data(contentsOf: url) {
            if let loaded = try? decoder.decode([Person].self, from: data) {
                self.people = loaded
            }
            else {
                fatalError("Cannot decode the people data.")
            }
        }
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
