//
//  Home.swift
//  PlaceFinder
//
//  Created by Dmitry Zasenko on 31.05.23.
//

import SwiftUI
import CoreLocation

struct Home: View {
    
    @StateObject var mapData = MapViewModel()
    @State var locationManager = CLLocationManager()
    
    var body: some View {
        ZStack {
           MapView()
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
            VStack {
                
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search", text: $mapData.searchText)
                        
                    }
                    .padding()
                    .background(.white)
                    
                    if !mapData.places.isEmpty && mapData.searchText != "" {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(mapData.places) { place in
                                    VStack {
                                        Text(place.placemark.name ?? "")
                                        Text(place.placemark.country ?? "")
                                    }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading)
                                        .onTapGesture {
                                            mapData.selectPlace(place: place)
                                        }
                                    Divider()
                                }
                            }
                            .padding(.top)
                        }
                        .background(.white)
                    }
                }
                .padding()
                
                Spacer()
                VStack {
                    Button {
                        mapData.focusLocation()
                    } label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .clipShape(Circle())
                        
                    }
                    Button {
                        mapData.updateMapType()
                    } label: {
                        Image(systemName: mapData.mapType == .standard ? "network" : "map")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .clipShape(Circle())
                    }

                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
            }
        }
        .onAppear() {
            locationManager.delegate = mapData
            locationManager.requestWhenInUseAuthorization()
        }
        .onChange(of: mapData.searchText, perform: { newValue in
            //time to avoid continous search requeat
            let delay = 0.3
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if newValue == mapData.searchText {
                    self.mapData.searchPlaces()
                }
            }
            
        })
        .alert(isPresented: $mapData.permissionDenied) {
            Alert(title: Text("Permission Denied"),
                  message: Text("Please Enable Permission In App Settings"),
                  dismissButton: .default(Text("Go to  Settings"), action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
