//
//  PersonView.swift
//  NameFace
//
//  Created by Paul Houghton on 01/12/2020.
//

import SwiftUI

struct PersonRow: View {
    var person: Person
    
    var body: some View {
        HStack {
            if let uiImage = Person.loadPhoto(photoFile: Person.getDocumentsDirectory().appendingPathComponent(self.person.photoFile) ) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            }
            else {
                Rectangle()
                    .fill(Color.secondary)
                    .frame(width:60, height: 60)
            }
            Text(self.person.name)
            Spacer()
        }
    }
}

struct PersonView: View {
    var person: Person
    
    var body: some View {
        VStack {
            if let uiImage = Person.loadPhoto(photoFile: Person.getDocumentsDirectory().appendingPathComponent(self.person.photoFile) ) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            }
            else {
                Rectangle()
                    .fill(Color.secondary)
                    .frame(width:200, height: 200)
            }
            Spacer()
        }
        .navigationTitle(self.person.name)
    }
}

struct PersonForm: View {
    @Environment(\.presentationMode) var presentationMode
    var photo: Image?
    @Binding var name: String
    @Binding var saveImage: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                if let photo = self.photo {
                    photo
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding(.top)
                }
                else {
                    Rectangle()
                        .fill(Color.secondary)
                        .frame(height: 200)
                }

                Form {
                    TextField("Name", text: $name)
                    
                }
                
                Spacer()
            }
            .navigationTitle("Add Person")
            .navigationBarItems(
                leading: Button("Cancel") {
                    // Cancel and dismiss
                    self.saveImage = false
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    // Save and dismiss
                    self.saveImage = true
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct PersonView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            PersonView(person: Person(name: "Paul Houghton"))
        }
        PersonForm(photo: Image("hat-person-phone"), name: .constant("Test"), saveImage: .constant(false))
        PersonRow(person: Person(name: "Paul Houghton"))
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
