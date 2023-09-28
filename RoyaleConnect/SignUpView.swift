//
//  SignUpView.swift
//  RoyaleConnect
//
//  Created by Dillon Borden on 9/27/23.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
        @State private var email = ""
        @State private var password = ""
        @State private var username = ""
        @State private var clashRoyaleID = ""
        @State private var registrationError: String? = nil
    
   
    var body: some View {
        
        NavigationView {
                    VStack {
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Username", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Clash Royale ID", text: $clashRoyaleID)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Button("Register") {
                            registerUser(email: email, password: password, username: username) { error in
                                if let error = error {
                                    registrationError = "Registration failed: \(error.localizedDescription)"
                                } else {
                                    // Registration succeeded
                                    registrationError = nil
                                }
                            }
                        }
                        .padding()

                        Text(registrationError ?? "")
                            .foregroundColor(.red)
                    }
                    .padding()
                    .navigationTitle("Registration")
                }
            }
    
    func registerUser(email: String, password: String, username: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(error)
            } else {
                // User registration succeeded
                let db = Firestore.firestore()
                let user = Auth.auth().currentUser

                if let user = user {
                    let userData: [String: Any] = [
                        "email": email,
                        "username": username,
                        // Add other user data as needed
                    ]

                    // Create a user document in Firestore with the UID as the document ID
                    db.collection("users").document(user.uid).setData(userData) { error in
                        if let error = error {
                            completion(error)
                        } else {
                            // Username saved to Firestore
                            completion(nil)
                        }
                    }
                }
            }
        }
    }


            private func saveAdditionalUserData(uid: String) {
                // Store additional user data (e.g., Clash Royale ID) in Firestore
                let db = Firestore.firestore()
                
              let userRed =  db.collection("users").document(uid).setData(["clashRoyaleID": clashRoyaleID]) { error in
                    if let error = error {
                        registrationError = "Error saving additional user data: \(error.localizedDescription)"
                    } else {
                        // Registration and data storage successful
                        registrationError = nil
                    }
                }
            }
        }
       
    
    
    
    
    
    struct SignUpView_Previews: PreviewProvider {
        static var previews: some View {
            SignUpView()
        }
    }
