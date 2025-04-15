//
//  ExploreView.swift
//  TOH
//
//  Created by Alia on 2025/2/26.
//

import SwiftUI
import MapKit
import CoreLocation

extension CLLocationCoordinate2D {
    static let osaka = CLLocationCoordinate2D(latitude: 34.685216, longitude: 135.5231272757)
}

struct ExploreView: View {
    @StateObject private var castleViewModel = CastleViewModel()
    @StateObject private var ramenViewModel = RamenViewModel()
    
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State var selectedCastle: Castle? //check!!!
    
    @State var queryString: String = ""
    @State private var searchResults: [MKMapItem] = []
    @State var visibleRegion: MKCoordinateRegion?
    @State var selectedResult: MKMapItem?
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 34.687234, longitude: 135.525842), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
    @StateObject private var locationManager = LocationManager()
    @State var route: MKRoute?
    
    @Namespace var mapScope
    @State private var isShowingSheet = false
    @State private var isShowingCastle = false
    @State private var isShowingRamen = false

    func search(for query: String) {
        queryString = query
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = visibleRegion ?? MKCoordinateRegion(
            center: .osaka,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
         
        Task {
            
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
        }
    }
    func getRoute(dest: MKMapItem) async -> MKRoute? {
        route = nil
        let request = MKDirections.Request()
        if let xx = locationManager.lastKnownLocation  {
            request.source =  MKMapItem(placemark: MKPlacemark(coordinate: xx))
        } else {
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: .osaka))
        }
        request.destination = dest
        let directions = MKDirections(request: request)
        let resp = try? await directions.calculate()
        return resp?.routes.first
    }
    
    func getDirection() {
        guard let selectedResult else { return }
      Task {
          route = await getRoute(dest: selectedResult)
      }
    }
    //Map(selection: $selectedResult)
    var body: some View {
        Map(position: .constant(.region(mapRegion)),selection: $selectedResult, scope: mapScope){
            UserAnnotation()
            if isShowingCastle {
                ForEach(castleViewModel.castles, id: \.self) { c in
                    Annotation(c.name, coordinate: c.locationCoordinate) {
                        AsyncImage(url: URL(string: c.imageURL[0])) { image in
                            image.resizable()
                        } placeholder: {
                            Color.black
                        }
                        .frame(maxWidth: 40, maxHeight: 40)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(.black, lineWidth: 2)
                        }
                        .onTapGesture {
                            selectedCoordinate = c.locationCoordinate
                            selectedCastle = c
                            isShowingSheet.toggle()
                        }
                        
                    }
                    /*
                    Marker(c.name, image: "osaka-castle", coordinate: c.locationCoordinate)
                     */
                }
            }
            
            // ramen list with orange background
            
            /*
            ForEach(searchResults, id: \.self) {result in
                Marker(item: result)
            }
            //.annotationTitles(.hidden)
            */
            if let route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 5)
            }
        }
        .mapControls {
            MapUserLocationButton() // 目前位置
            MapCompass() // 指北針
            MapScaleView() // 比例尺
        }
        .overlay(alignment: .bottomTrailing) {
                    VStack {
                        MapUserLocationButton(scope: mapScope)
                        MapCompass(scope: mapScope)
                            .mapControlVisibility(.visible)
                    }
                    .padding(.trailing, 10)
                    .buttonBorderShape(.circle)
                }
                .mapScope(mapScope)
        .safeAreaInset(edge: .bottom) {
            
            HStack {
                Toggle("🏯", isOn: $isShowingCastle)
                    .toggleStyle(.button)
                    .tint(.black)
                Toggle("🍜", isOn: $isShowingRamen)
                    .toggleStyle(.button)
                    .tint(.black)
                /*
                Button {
                    //search(for: "ラーメン")
                    
                } label: {
                    Text(" 🍜  ")
                }
                .buttonStyle(.borderedProminent)
                
                
                Button {
                    //search(for: "城")
                } label: {
                    Text(" 🏯  ")
                }
                .buttonStyle(.borderedProminent)
                 */
            }
            .labelStyle(.iconOnly)
        }
         
        .onTapGesture {
            getDirection()
        }
        .onLongPressGesture {
            //selectedPlace = location
        }
        .onAppear{
            LocationManager().checkIfLocationServicesIsEnabled()
        }
        
        .onChange(of: searchResults) {
            position = .automatic
        }
        
         .onMapCameraChange {
             context in visibleRegion = context.region
         }
         
        // type: standard or imagery or hybrid
        .mapStyle(.standard(elevation: .realistic))
        //.mapStyle(.imagery(elevation: .realistic))
        .sheet(isPresented: $isShowingSheet) {
            //if let selectedCastle
            if let castle = selectedCastle {
                CastleInfoView(castle: castle)
            }
        }
        .task{
            try? await castleViewModel.getAllCastles()
            try? await ramenViewModel.getAllRamens()
        }
    }
}

#Preview {
    ExploreView()
}
