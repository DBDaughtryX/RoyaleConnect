//
//  ProfileView.swift
//  RoyaleConnect
//
//  Created by Dillon Borden on 9/28/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore


struct ClashRoyalePlayer: Codable {
    struct Clan: Codable {
        let name: String
        let clanName: String
    }
    
    let clan: Clan?
    // Add other properties you need here
}

struct ProfileView: View {
    @State private var currentUsername = ""
    @State private var currentClashRoyaleTag = ""
    @State private var isEditingUsername = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var playerID = ""
    @State private var trophies = ""
    @State private var rank = ""
    @State private var animateText = false
    @State private var clanInformation = "" // Add a state variable to store clan information
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("newbackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Text("© 2023 Dillon")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .offset(y: -310)
                    }
                    .padding(.bottom, 16)
                    
                    Text("Profile")
                        .fontWeight(.heavy)
                        .shadow(color: .black, radius: 2.9)
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        .offset(y: -140)
                    
                    HStack {
                        Text("\(currentUsername)")
                            .font(.title)
                            .bold()
                            .fontWeight(.bold)
                            .shadow(color: .white, radius: 2)
                            .offset(x: 40, y: -95)
                            .foregroundColor(Color.black)
                        
                        if !isEditingUsername {
                            Image(systemName: "pencil")
                                .font(.title)
                                .foregroundColor(.clear)
                                .padding()
                        }
                    }
                    .padding(.trailing)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(.white))
                        .frame(width: 320, height: 300)
                        .padding(.top, 20)
                        .overlay(
                            VStack(alignment: .leading) {
                                Text("Player Information")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.white))
                                    .padding(.top, 20)
                                    .offset(y: -90)
                                
                                HStack {
                                    Text("CR: \(currentClashRoyaleTag)")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(Color.black)
                                        .offset(y: -78)
                                }
                                .padding(.top, 10)
                                
                                HStack {
                                    Text("Rank: ")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(Color.black)
                                        .offset(y: -70)
                                    
                                    Text("\(rank)")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(Color.black)
                                }
                                .padding(.top, 10)
                                
                                HStack {
                                    Text("Clan:")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(Color.black)
                                        .offset(y: -60)
                                    
                                    Text(clanInformation) // Display clan information
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(Color.black)
                                        .offset(y: -60)
                                }
                                .padding(.top, 10)
                            }
                            .padding(.horizontal, 20)
                        )
                }
                .animation(.easeInOut(duration: 0.5))
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Profile"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .onAppear {
                    fetchUserData()
                    fetchClashRoyaleData() // Fetch Clash Royale data when the view appears
                    withAnimation {
                        animateText = true
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
    
    func fetchUserData() {
        guard let user = Auth.auth().currentUser else {
            alertMessage = "User not authenticated."
            showAlert = true
            return
        }
        
        // Fetch user data from Firebase Firestore
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        
        userRef.getDocument { document, error in
            if let error = error {
                alertMessage = "Error fetching data: \(error.localizedDescription)"
                showAlert = true
                return
            }
            
            if let document = document, document.exists {
                // Update the UI with the fetched data
                if let clanInfo = document.data()?["clanName"] as? String {
                    clanInformation = clanInfo
                }
                
                if let userName = document.data()?["username"] as? String {
                    currentUsername = userName
                }
                
                // Fetch and update other user data if needed
            }
        }
    }
    
    func fetchClashRoyaleData() {
        // Fetch Clash Royale data here
        guard let user = Auth.auth().currentUser else {
            alertMessage = "User not authenticated."
            showAlert = true
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        
        userRef.getDocument { document, error in
            if let error = error {
                alertMessage = "Error fetching Clash Royale data: \(error.localizedDescription)"
                showAlert = true
                return
            }
            
            if let document = document, document.exists {
                if let clashRoyaleTag = document.data()?["clashRoyaleID"] as? String {
                    currentClashRoyaleTag = clashRoyaleTag
                }
                
                // Perform additional tasks with Clash Royale data if needed
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}


