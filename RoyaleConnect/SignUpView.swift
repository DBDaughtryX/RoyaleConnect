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
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .top, endPoint: .bottom)
                    .animation(Animation.linear(duration: 3.0).repeatForever(autoreverses: true)) // Animate the gradient colors
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Image(systemName: "crown")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                                    .offset(y: -150)
                    Image(systemName: "arrowshape.turn.up.backward")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                                    .offset(x: -165,y: -280)
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Clash Royale ID", text: $clashRoyaleID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
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
                    }) {
                        Text("Register")
                            .frame(width: 200, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue)
                            )
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding()

                    if registrationSuccess {
                        Text("Registration successful!").foregroundColor(.green)
                    } else {
                        Text(registrationError ?? "").foregroundColor(.red)
                    }
                }
                .padding()
                .navigationBarTitle("Registration", displayMode: .inline)
                
                Text("R o y a l e C o n n e c t")
                    .offset(x: 0, y: -210)
                    
                                   .font(.system(size: 30))
                                   
                                   .bold()
                                   .foregroundColor(.white)
                                  //.padding()
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
                        "clashRoyaleID" : clashRoyaleID
                    ]
                    
                    // Create a user document in Firestore with the UID as the document ID
                    db.collection("users").document(user.uid).setData(userData) { error in
                        if let error = error {
                            completion(error)
                        } else {
                            // Username saved to Firestore, now fetch and save Clash Royale clan information
                            self.fetchClanInfoAndSaveToFirestore(uid: user.uid, clashRoyaleID: clashRoyaleID, completion: completion)
                        }
                    }
                }
            }
        }
    }
    
    private func fetchClanInfoAndSaveToFirestore(uid: String, clashRoyaleID: String, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "https://api.clashroyale.com/v1/players/%23\(clashRoyaleID)") else {
            let error = NSError(domain: "YourApp", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Invalid Clash Royale ID"])
            completion(error)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6IjQ1OGI1ZTJjLTk5ZDItNDJjOS04MmY4LTZkMDg2OWUwODE1OSIsImlhdCI6MTY5NTY4ODYyNywic3ViIjoiZGV2ZWxvcGVyL2Y2ZWQ1N2UyLWVjMjktMjYyNi1lNTA4LTA2ZTcwZWY2NWJkYiIsInNjb3BlcyI6WyJyb3lhbGUiXSwibGltaXRzIjpbeyJ0aWVyIjoiZGV2ZWxvcGVyL3NpbHZlciIsInR5cGUiOiJ0aHJvdHRsaW5nIn0seyJjaWRycyI6WyIxNzIuMy4xMDkuMTU0Il0sInR5cGUiOiJjbGllbnQifV19.AQM76hWNfTP8zgXdcU-yalqmUsy9-gUM6iShiupVyvuiVT1AGLAJcMhSOBXIT6SyYLGaQurn6mmUsuZRZuO-xw", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(ClashRoyalePlayer.self, from: data)
                    if let clanName = decodedData.clan?.name {
                        // Store clan information in Firestore
                        let db = Firestore.firestore()
                        let userRef = db.collection("users").document(uid)
                        
                        userRef.updateData(["clanName": clanName]) { error in
                            if let error = error {
                                completion(error)
                            } else {
                                completion(nil)
                            }
                        }
                    } else {
                        completion(nil) // No clan information found
                    }
                } catch {
                    completion(error)
                }
            } else if let error = error {
                completion(error)
            }
        }.resume()
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}


