//
//  EditUserNameView.swift
//  RoyaleConnect
//
//  Created by Dillon Borden on 9/29/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct EditUsernameView: View {
    @Binding var newUsername: String
    @Environment(\.presentationMode) var presentationMode

    @State private var isUsernameTaken = false
    @State private var errorMessage = ""
    @State private var successMessage = ""

    var body: some View {
        VStack {
            TextField("New Username", text: $newUsername)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Text(errorMessage)
                .foregroundColor(.red)
                .padding()

            Text(successMessage)
                .foregroundColor(.green)
                .padding()

            Button(action: {
                updateUsername()
            }) {
                Text("Update Username")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
        }
    }

    private func updateUsername() {
        guard let currentUser = Auth.auth().currentUser else {
            // Handle the case where the user is not authenticated
            return
        }

        // Check if the new username is taken
        checkUsernameAvailability(newUsername) { isAvailable in
            if isAvailable {
                // Update the username
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(currentUser.uid)

                userRef.updateData(["username": newUsername]) { error in
                    if let error = error {
                        // Handle the error
                        errorMessage = "Error updating username: \(error.localizedDescription)"
                        successMessage = ""
                    } else {
                        // Username updated successfully, show success message
                        successMessage = "Username updated successfully!"
                        errorMessage = ""
                        // Dismiss the view after a delay (optional)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            } else {
                errorMessage = "Username is already taken. Please choose a different one."
                successMessage = ""
            }
        }
    }

    // Function to check if the new username is available
    private func checkUsernameAvailability(_ username: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let usersRef = db.collection("users")

        usersRef.whereField("username", isEqualTo: username).getDocuments { snapshot, error in
            if let error = error {
                print("Error checking username availability: \(error.localizedDescription)")
                completion(false)
            } else if let documents = snapshot?.documents, !documents.isEmpty {
                completion(false) // Username is already taken
            } else {
                completion(true) // Username is available
            }
        }
    }
}

