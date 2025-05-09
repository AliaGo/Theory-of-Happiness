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
    @StateObject private var twRamenViewModel = TWRamenViewModel()
    
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State var selectedCastle: Castle? //check!!!
    @State var selectedRamen: TWRamen?
    
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
        //position: .constant(.region(mapRegion))
        Map(position: .constant(.region(mapRegion)), selection: $selectedResult, scope: mapScope){
            UserAnnotation()
            
            if isShowingCastle {
                ForEach(castleViewModel.castles, id: \.self) { c in
                    Annotation(c.name, coordinate: c.locationCoordinate) {
                        CastleAnnotationView(castle: c) {
                            selectedCastle = c
                            isShowingSheet = true
                        }
                    }
                }
            }
            
            if isShowingRamen {
                ForEach(twRamenViewModel.twRamens, id: \.self) { r in
                    Annotation(r.name, coordinate: CLLocationCoordinate2D(latitude: r.latitude, longitude: r.longitude)) {
                        RamenAnnotationView(ramen: r) {
                            selectedRamen = r
                            isShowingSheet = true
                        }
                    }
                }
            }
            
            if let route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 5)
            }
        }
        .mapControls {
            //MapUserLocationButton() // 目前位置
            //MapCompass() // 指北針
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
                
                // 之後還要再多增加日本拉麵（目前是台北）
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
                
                 */
            }
            .labelStyle(.iconOnly)
        }
         
        .onTapGesture {
            getDirection()
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
            if let twRamen = selectedRamen {
                TWRamenInfoView(ramen: twRamen)
            }
        }
        .task{
            LocationManager().checkIfLocationServicesIsEnabled()
            try? await castleViewModel.getAllCastles()
            try? await twRamenViewModel.getAllRamens()
        }
    }
}

#Preview {
    ExploreView()
}

