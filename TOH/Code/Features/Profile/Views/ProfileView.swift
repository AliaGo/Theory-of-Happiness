//
//  ProfileView.swift
//  TOH
//
//  Created by Alia on 2025/1/26.
//

import SwiftUI
import PhotosUI


struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    @State private var profilePhoto: PhotosPickerItem? = nil
    @State private var url: URL? = nil
    
    @State private var showRamenSheet = false
    @State private var showCastleSheet = false
    
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("Personal Info")){
                    PhotosPicker(selection: $profilePhoto, matching: .images, photoLibrary: .shared()) {
                        HStack{
                            Image(systemName: "photo.badge.plus.fill")
                            Text("Select profile photo")
                        }
                       
                    }
                    
                    if let urlString = viewModel.user?.profileImagePathUrl, let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: 80, maxHeight: 80,alignment: .center)
                                .clipShape(Circle())
                                .overlay {
                                    Circle().stroke(.white, lineWidth: 4)
                                }
                                .shadow(radius: 7)
                        } placeholder: {
                            ProgressView()
                                .frame(maxWidth: 80, maxHeight: 80)
                        }
                    }
                    
                    if viewModel.user?.profileImagePath != nil {
                        Button("Delete Image") {
                            viewModel.deleteProfileImage()
                        }
                    }
                    
                    if let user = viewModel.user {
                        //Text("UserID: \(user.userId)")
                        
                        if let userNickname = user.userNickname {
                            HStack{
                                Image(systemName: "person")
                                Text("\(userNickname)")
                            }
                        }
                        
                        if let email = user.email {
                            HStack{
                                Image(systemName: "envelope.circle.fill")
                                Text("\(email)")
                            }
                        }
                        
                        if let dateCreated = user.dateCreated {
                            HStack{
                                Image(systemName: "calendar.circle")
                                Text("Start Date：\(viewModel.formattedDateCreated)")
                            }
                        }
                        
                        /*
                        Button {
                            viewModel.togglePremiumStatus()
                        } label: {
                            Text("User is Premium: \((user.isPremium ?? false).description.capitalized)")
                        }
                        */
                    }
                }
                
                
                
                Section(header: Text("My Collection")){
                    HStack(spacing:5){
                        List{
                            Button {
                                showRamenSheet = true
                            } label: {
                                VStack {
                                    Text("我的照片庫")
                                    Text("5")
                                        .font(.system(size: 20))
                                }
                            }
                            .tint(.gray)
                            .buttonStyle(.bordered)
                            .sheet(isPresented: $showRamenSheet) {
                                RamenSheet()
                                    .presentationBackground(.thinMaterial)
                                    .presentationDetents([.height(600)])
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .frame(width: 200, height: 50)
                            
                            
                            Button {
                                showCastleSheet = true
                            } label: {
                                VStack {
                                    Text("我的城堡印章")
                                    if let stampsNum = viewModel.userCollectedStamps?.count{
                                        Text(String(stampsNum))
                                            .font(.system(size: 20))
                                    } else {
                                        Text("0")
                                            .font(.system(size: 20))
                                    }
                                    
                                }
                            }
                            .tint(.gray)
                            .buttonStyle(.bordered)
                            .sheet(isPresented: $showCastleSheet){
                                CastleSheet()
                                    .presentationDetents([.height(600)])
                                    .presentationBackground(.thinMaterial)
                                
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            .frame(width: 200, height: 50)
                        }
                        .listRowInsets(EdgeInsets())
                    }
                }
                
                Section(header: Text("INFORMATION")){
                    NavigationLink(destination: GuideView()) {
                        HStack {
                            Image(systemName: "questionmark.circle")
                            Text("How to use")
                        }
                    }
                    NavigationLink(destination: PointShopView()){
                        HStack{
                            Image(systemName: "cart.fill")
                            Text("Point Shop")
                        }
                    }
                }
            }
            .task{
                try? await viewModel.loadCurrentUser()
            }
            .onChange(of: profilePhoto, perform: { newValue in
                if let newValue {
                    viewModel.saveProfileImage(item: newValue)
                }
            })
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingsView(showSignInView: $showSignInView, userNickname: viewModel.user?.userNickname ?? "")
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
                
            }
        }
        .task {
            try? await viewModel.getCollectedStamps()
        }
    }
}

#Preview {
    ProfileView(showSignInView: .constant(false))
}
