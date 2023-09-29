//
//  SignUpView.swift
//  RoyaleConnect
//
//  Created by Dillon Borden on 9/27/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var clashRoyaleID = ""
    @State private var registrationError: String? = nil
    @State private var registrationSuccess = false
    
    var body: some View {
        
        NavigationView {
            VStack{Color("MetallicGray1")
                    .edgesIgnoringSafeArea(.all)
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
                        checkUsernameAvailability(username: username) { isUsernameAvailable in
                            if isUsernameAvailable {
                                checkClashRoyaleIDAvailability(clashRoyaleID: clashRoyaleID) { isCRIDAvailable in
                                    if isCRIDAvailable {
                                        registerUser(email: email, password: password, username: username, clashRoyaleID: clashRoyaleID) { error in
                                            if let error = error {
                                                registrationError = "Registration failed: \(error.localizedDescription)"
                                                registrationSuccess = false
                                            } else {
                                                // Registration succeeded
                                                registrationError = nil
                                                registrationSuccess = true
                                            }
                                        }
                                    } else {
                                        registrationError = "Clash Royale ID is already linked to an account."
                                        registrationSuccess = false
                                    }
                                }
                            } else {
                                registrationError = "Username is not available."
                                registrationSuccess = false
                            }
                        }
                    }
                    .padding()
                    
                    if registrationSuccess {
                        Text("Registration successful!").foregroundColor(.green)
                    } else {
                        Text(registrationError ?? "").foregroundColor(.red)
                    }
                }
                .padding()
                .navigationTitle("Registration")
                
            }
        }
    }
    // Check if the username is available
    private func checkUsernameAvailability(username: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").whereField("username", isEqualTo: username).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error checking username availability: \(error.localizedDescription)")
                completion(false)
            } else {
                if let documents = querySnapshot?.documents, documents.isEmpty {
                    // Username is available
                    completion(true)
                } else {
                    // Username is already taken
                    completion(false)
                }
            }
        }
    }

    // Check if the Clash Royale ID is available
    private func checkClashRoyaleIDAvailability(clashRoyaleID: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").whereField("clashRoyaleID", isEqualTo: clashRoyaleID).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error checking Clash Royale ID availability: \(error.localizedDescription)")
                completion(false)
            } else {
                if let documents = querySnapshot?.documents, documents.isEmpty {
                    // Clash Royale ID is available
                    completion(true)
                } else {
                    // Clash Royale ID is already linked to an account
                    completion(false)
                }
            }
        }
    }
        

    // Register the user if all checks pass
    private func registerUser(email: String, password: String, username: String, clashRoyaleID: String, completion: @escaping (Error?) -> Void) {
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
                            // Username saved to Firestore, now save the Clash Royale ID
                            self.saveAdditionalUserData(uid: user.uid, clashRoyaleID: clashRoyaleID, completion: completion)
                        }
                    }
                }
            }
        }
    }

    private func saveAdditionalUserData(uid: String, clashRoyaleID: String, completion: @escaping (Error?) -> Void) {
        // Store Clash Royale ID in Firestore
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)

        userRef.updateData(["clashRoyaleID": clashRoyaleID]) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

