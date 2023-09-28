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
    @State private var newUsername = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("© 2023 Dillon")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .offset(y: -310)
            }
            .padding(.bottom, 16)
            
            Text("Profile")
                .fontWeight(.heavy)
                .font(.largeTitle)
                .offset(y: -290)
            
            Text("\(currentUsername)") // Display the current username
                .offset(y: -150)
            
            Button(action: {
                showAlert = true
            }) {
                Image(systemName: "pencil")
            }
            .offset(x: -40, y: -170)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Change Username"),
                message: Text("Enter your new username:"),
                primaryButton: .default(
                    Text("Save"),
                    action: {
                        // Save the new username to Firestore.
                        updateUsernameInFirestore()
                    }
                ),
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            fetchCurrentUsername()
        }
    }
    
    func fetchCurrentUsername() {
        guard let user = Auth.auth().currentUser else {
            alertMessage = "User not authenticated."
            showAlert = true
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid) // Assuming you store user data under a "users" collection
        
        userRef.getDocument { document, error in
            if let error = error {
                alertMessage = "Error fetching username: \(error.localizedDescription)"
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
        let userRef = db.collection("users").document(user.uid) // Assuming you store user data under a "users" collection
        
        // Update the 'username' field in the Firestore document.
        userRef.updateData(["username": newUsername]) { error in
            if let error = error {
                alertMessage = "Error updating username: \(error.localizedDescription)"
            } else {
                currentUsername = newUsername
                alertMessage = "Username updated successfully."
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
