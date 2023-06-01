//
//  SearchView.swift
//  PlaceFinder
//
//  Created by Dmitry Zasenko on 31.05.23.
//

import SwiftUI
import MapKit

struct SearchView: View {
    
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 15) {
                    Button {} label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    Text("Search Location")
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Find Locations here", text: $locationManager.searchText)
                }
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(.gray)
                }
                
                if let places = locationManager.fetchedPaces, !places.isEmpty {
                    List {
                        ForEach(places, id: \.self) { place in
                            NavigationLink {
                                MapViewSelection()
                                    .environmentObject(locationManager)
                                    .ignoresSafeArea()
                                    .onAppear() {
                                        if let coordinate = place.location?.coordinate {
                                            locationManager.pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                                            locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                            locationManager.addDraggablePin(coordinate: coordinate)
                                            locationManager.unpdatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                                        }
                                    }
                            } label: {
                                HStack(alignment: .top, spacing: 15) {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(place.name ?? "")
                                        Text(place.locality ?? "")
                                        Text(place.country ?? "")
                                        Text(place.isoCountryCode ?? "")
                                        Text(place.subAdministrativeArea ?? "")
                                        Text(place.subLocality ?? "")
                                        Text(place.subThoroughfare ?? "")
                                        Text(place.thoroughfare ?? "")
                                    }.font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                } else {
                    NavigationLink {
                        MapViewSelection()
                            .environmentObject(locationManager)
                            .ignoresSafeArea()
                            .onAppear() {
                                if let coordinate = locationManager.userLocation?.coordinate {
                                    locationManager.mapView.region = .init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                                    locationManager.addDraggablePin(coordinate: coordinate)
                                    locationManager.unpdatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                                }
                            }
                    } label: {
                        Label {
                            Text("Use Current Location")
                                .font(.callout)
                        } icon: {
                            Image(systemName: "location.north.circle.fill")
                        }
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//MARK: - MapView Live Selection
struct MapViewSelection: View {
    
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        ZStack {
            MapViewHelper()
                .environmentObject(locationManager)
                .ignoresSafeArea()
            
            if let place = locationManager.pickedPlaceMark {
                VStack(spacing: 15) {
                    Text("Confirm Location")
                        .font(.title2.bold())
                    
                    HStack(alignment: .top, spacing: 15) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                        VStack(alignment: .leading, spacing: 6) {
                            Text(place.name ?? "")
                            Text(place.locality ?? "")
                            Text(place.country ?? "")
                            Text(place.isoCountryCode ?? "")
                            Text(place.subAdministrativeArea ?? "")
                            Text(place.subLocality ?? "")
                            Text(place.subThoroughfare ?? "")
                            Text(place.thoroughfare ?? "")
                        }.font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                    
                    Button {} label: {
                        Text("Confirm Location" )
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background{
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.green)
                            }
                            .overlay (alignment: .trailing) {
                                Image(systemName: "arrow.right")
                                    .font(.title3.bold())
                                    .padding(.trailing)
                            }
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .padding()
                .background() {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .toolbar(.hidden)
        .onDisappear() {
            locationManager.pickedLocation = nil
            locationManager.pickedPlaceMark = nil
            
            locationManager.mapView.removeAnnotations(locationManager.mapView.annotations)
        }
    }
}

//MARK: - UIKit MapView

struct MapViewHelper: UIViewRepresentable {
    
    @EnvironmentObject var locationManager: LocationManager
    
    func makeUIView(context: Context) -> MKMapView {
        return locationManager.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}
