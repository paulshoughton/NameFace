//
//  PersonView.swift
//  NameFace
//
//  Created by Paul Houghton on 01/12/2020.
//

import SwiftUI
import MapKit

struct PersonRow: View {
    var person: Person
    
    var body: some View {
        HStack {
            if let uiImage = Person.loadPhoto(photoFile: Person.getDocumentsDirectory().appendingPathComponent(self.person.photoFile) ) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
            else {
                Rectangle()
                    .fill(Color.secondary)
                    .frame(width:50, height: 50)
                    .clipShape(Circle())
            }
            Text(self.person.name)
            Spacer()
        }
    }
}

struct PersonPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct PersonView: View {
    var person: Person
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 51.459935, longitude: -0.968050
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 2, longitudeDelta: 2
        )
    )
    @State private var pins: [PersonPin] = [PersonPin]()
        
    var body: some View {
        ZStack {
            if pins.count > 0 {
                Map(coordinateRegion: $region, annotationItems: pins) { pin in
                    MapPin(coordinate: pin.coordinate)
                }
                .padding(.top, 100.0)
            }
            VStack {
                if let uiImage = Person.loadPhoto(photoFile: Person.getDocumentsDirectory().appendingPathComponent(self.person.photoFile) ) {

                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width:250, height: 250)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                        

                }
                else {
                    ZStack {
                        Circle()
                            .fill(Color.secondary)
                            .frame(width:250, height: 250)
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 150.0))
                    }
                }
                Spacer()
            }
            
        }
        .onAppear() {
            if let latitude = self.person.latitude, let longitude = self.person.longitude {
                self.region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: latitude, longitude: longitude
                    ),
                    span: MKCoordinateSpan(
                        latitudeDelta: 2, longitudeDelta: 2
                    )
                )
                self.pins.append(
                    PersonPin(
                        coordinate: .init(
                            latitude: latitude,
                            longitude: longitude)
                    )
                )
            }
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
            PersonView(person: Person(name: "Paul Houghton", latitude: 51.459935, longitude: -0.968050))
        }
        PersonForm(photo: Image("hat-person-phone"), name: .constant("Test"), saveImage: .constant(false))
        PersonRow(person: Person(name: "Paul Houghton", latitude: 51.459935, longitude: -0.968050))
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
