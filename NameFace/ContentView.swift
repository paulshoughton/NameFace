//
//  ContentView.swift
//  NameFace
//
//  Created by Paul Houghton on 25/11/2020.
//

import SwiftUI
import MapKit

enum SheetMode {
    case imagePicker, imageSaver
}

struct ContentView: View {
    @State private var showingSheet = false
    @State private var sheetMode: SheetMode = .imagePicker
    @State private var saveImage = false
    
    @State private var showingActionSheet = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var personImage: UIImage?
    @State private var personName: String = ""
    
    @State var people: [Person] = [Person]()
    
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(people, id: \.id) { person in
                        NavigationLink(
                            destination:
                                PersonView(person: person)
                        ) {
                            PersonRow(person: person)
                        }
                    }
                    .onDelete(perform: deletePerson)
                }
            }
            .navigationTitle("NameFace")
            .navigationBarItems(
                leading: EditButton(),
                trailing:
                    Button("Add") {
                        self.showingActionSheet = true
                    }
            )
        }
        .onAppear(perform: startAppAndLoadData)
        .sheet(isPresented: $showingSheet, onDismiss: sheetDismissed) {
            
            if (self.sheetMode == .imagePicker) {
                ImagePicker(image: self.$personImage, sourceType: self.imagePickerSourceType)
            }
            else {
                if let photo = self.personImage {
                    PersonForm(photo: Image(uiImage: photo), name: self.$personName, saveImage: self.$saveImage)
                }
                else {
                    PersonForm(photo: nil, name:self.$personName, saveImage: self.$saveImage)
                }
            }
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text("Choose Image Source"), message: Text("Select the source of your image."), buttons: [
                .default(Text("Photo Library")) {
                    self.showingSheet = true
                    self.sheetMode = .imagePicker
                    self.imagePickerSourceType = .photoLibrary
                },
                .default(Text("Camera")) {
                    self.showingSheet = true
                    self.sheetMode = .imagePicker
                    #if targetEnvironment(simulator)
                        self.imagePickerSourceType = .photoLibrary
                    #else
                        self.imagePickerSourceType = .camera
                    #endif
                },
                .cancel()
            ])
        }
        
        
        #if targetEnvironment(simulator)
          // your simulator code
        #else
          // your real device code
        #endif
        
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
            if self.saveImage {
                saveNameFace()
            }

            // Prepare for next photo to be selected
            reset()
        }
    }
    
    func saveNameFace() {
        
        let person: Person
        
        if let currentLocation = self.locationFetcher.lastKnownLocation {
            person = Person(name: personName, latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        }
        else {
            person = Person(name: personName)
        }
        
        // Better error handling when coordinates are not known.
        
        
        // Give the photo a name based on the UUID of the person.
        let url = Person.getDocumentsDirectory().appendingPathComponent(person.photoFile)
        
        if let jpegData = personImage?.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: url, options: [.atomicWrite, .completeFileProtection])
        }
        
        self.people.append(person)
        self.people.sort()
        saveDataToDocumentsDirectory()
    }
    
    // Reset data ready for next
    func reset() {
        self.saveImage = false
        self.personImage = nil
        self.personName = ""
    }
    
    func saveDataToDocumentsDirectory() {
        let encoder = JSONEncoder()

        if let data = try? encoder.encode(self.people) {
            let url = Person.getDocumentsDirectory().appendingPathComponent("NameFaceData.json")
            
            do {
                try data.write(to: url)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func startAppAndLoadData() {
        //  Initialise location fetcher when app starts.
        self.locationFetcher.start()
        
        // Load stored data.
        loadDataFromDocumentsDirectory()
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
        
        people.sort()
    }
    
    func deletePerson(at offsets: IndexSet) {
        
        people.sort()
        
        for offset in offsets {
            // Remove file from documents area
            let urlToRemove = Person.getDocumentsDirectory().appendingPathComponent(people[offset].photoFile)
            do {
                try FileManager.default.removeItem(at: urlToRemove)
            }
            catch {
                print("Error deleting \(people[offset].photoFile) for \(people[offset].name)")
            }
        }
        
        people.remove(atOffsets: offsets)
        
        // Save our data back to store updated list.
        saveDataToDocumentsDirectory()
    }
}

struct ContentView_Previews: PreviewProvider {
    static let people = [
        Person(name: "Paul Houghton", latitude: 51.459935, longitude: -0.968050),
        Person(name: "Shane Houghton", latitude: 51.459935, longitude: -0.968050)
    ]
    
    static var previews: some View {
        ContentView(people: people)
    }
}
