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

struct ProfileView: View {
    @State private var currentUsername = ""
    @State private var currentClashRoyaleTag = ""
    @State private var newUsername = ""
    @State private var isEditingUsername = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var playerID = ""
    @State private var trophies = ""
    @State private var clanName = ""
    @State private var rank = ""
    @State private var animateText = false

    var body: some View {
        NavigationView {
            Color("MetallicGray1")
                .edgesIgnoringSafeArea(.all)
                .overlay(
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
                            .font(.largeTitle)
                            .foregroundColor(Color.black)
                            .offset(y: animateText ? -30 : -50)

                        HStack {
                            if isEditingUsername {
                                TextField("New Username", text: $newUsername)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 200)
                                    .padding(.bottom, 20)
                                    .foregroundColor(.black)
                            } else {
                                Text(" \(currentUsername)")
                                    .font(.title)
                                    .bold()
                                    .fontWeight(.bold)
                                    .shadow(color: .black, radius: 1)
                                    .offset(x: 15, y: -7)
                                    .foregroundColor(Color.black)
                            }

                            Button(action: {
                                isEditingUsername.toggle()
                            }) {
                                Image(systemName: isEditingUsername ? "checkmark" : "pencil")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .padding()
                            }
                            .padding(.leading, 10)
                            .foregroundColor(isEditingUsername ? Color.blue : Color.primary)
                        }


                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color(.white))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .overlay(
                                VStack {
                                    Text("Player Information")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(.black))
                                        .padding(.top, 20)
                                        .offset(y: -160)

                                    Text("CR#: \(currentClashRoyaleTag)")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(Color.black)
                                        .padding(.top, 10)
                                        .offset(x: -80, y: -140)

                                    Text("rank: \(rank)")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(Color.black)
                                        .padding(.top, 10)
                                        .offset(x: -140, y: -110)

                                    Text("Clan: \(clanName)")
                                        .font(.largeTitle)
                                        .bold()
                                        .foregroundColor(Color.black)
                                        .padding(.top, 10)
                                        .offset(y: -90)
                                }
                            )
                            .padding(.top, 20)

                        if isEditingUsername {
                            HStack {
                                Button(action: {
                                    updateUsernameInFirestore()
                                }) {
                                    Text("Save")
                                        .font(.headline)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .padding(.trailing, 20)

                                Button(action: {
                                    isEditingUsername = false
                                    newUsername = ""
                                }) {
                                    Text("Cancel")
                                        .font(.headline)
                                        .padding()
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .padding(.leading, 20)
                            }
                        }
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
                        withAnimation {
                            animateText = true
                        }
                    }
                )
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
                .navigationBarItems(trailing:
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                            .font(.title)
                            .foregroundColor(.black)
                            .padding()
                            
                    }
                )
        }
    }

    func fetchUserData() {
        guard let user = Auth.auth().currentUser else {
            alertMessage = "User not authenticated."
            showAlert = true
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)

        userRef.getDocument { document, error in
            if let error = error {
                alertMessage = "Error fetching user data: \(error.localizedDescription)"
                showAlert = true
                return
            }

            if let document = document, document.exists {
                if let username = document.data()?["username"] as? String {
                    currentUsername = username
                } else {
                    alertMessage = "Username not found in Firestore document."
                    showAlert = true
                }

                if let clashRoyaleTag = document.data()?["clashRoyaleID"] as? String {
                    currentClashRoyaleTag = clashRoyaleTag
                } else {
                    alertMessage = "Clash Royale Tag not found in Firestore document."
                    showAlert = true
                }

                if let playerID = document.data()?["playerID"] as? String {
                    self.playerID = playerID
                }

                if let trophies = document.data()?["trophies"] as? String {
                    self.clanName = clanName
                }
            } else {
                alertMessage = "Firestore document for the user not found."
                showAlert = true
            }
        }
    }

    func updateUsernameInFirestore() {
        guard let user = Auth.auth().currentUser else {
            alertMessage = "User not authenticated."
            showAlert = true
            return
        }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)

        // Update the 'username' field in the Firestore document.
        userRef.updateData(["username": newUsername]) { error in
            if let error = error {
                alertMessage = "Error updating username: \(error.localizedDescription)"
            } else {
                currentUsername = newUsername
                alertMessage = "Username updated successfully."
                isEditingUsername = false
                newUsername = ""
            }
            showAlert = true
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
