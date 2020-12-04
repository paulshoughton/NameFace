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

struct PersonForm: View {
    @Environment(\.presentationMode) var presentationMode
    var photo: Image?
    @Binding var name: String
    
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
                    self.presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    // Save and dismiss
                    self.presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct PersonView_Previews: PreviewProvider {
    
    static var previews: some View {
        PersonView()
        PersonForm(photo: Image("hat-person-phone"), name: .constant("Test"))
        PersonRow(name: "Paul Houghton", photoFile: "12345  ")
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
