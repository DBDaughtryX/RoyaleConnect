//
//  SignUpView.swift
//  RoyaleConnect
//
//  Created by Dillon Borden on 9/27/23.
//

import SwiftUI
import Foundation
struct PlayerInfo: Decodable {
    // Define the properties you want to extract from the API response
    let name: String
    let trophies: Int
    // Add more properties as needed
}
struct SignUpView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var clashRoyaleID = ""
    @State private var registrationStatus = ""
    
    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Clash Royale ID", text: $clashRoyaleID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Sign Up") {
                saveClashRoyaleID()
            }
            .padding()
            
            Text(registrationStatus)
                .foregroundColor(registrationStatus == "Success" ? .green : .red)
        }
        .navigationBarTitle("Sign Up")
    }
    
    private func saveClashRoyaleID() {
        // Validate user input (you can implement more robust validation)
        guard !username.isEmpty, !password.isEmpty, !clashRoyaleID.isEmpty else {
            registrationStatus = "Please fill in all fields."
            return
        }
        
        // Create the Clash Royale API URL
        let apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6IjQ1OGI1ZTJjLTk5ZDItNDJjOS04MmY4LTZkMDg2OWUwODE1OSIsImlhdCI6MTY5NTY4ODYyNywic3ViIjoiZGV2ZWxvcGVyL2Y2ZWQ1N2UyLWVjMjktMjYyNi1lNTA4LTA2ZTcwZWY2NWJkYiIsInNjb3BlcyI6WyJyb3lhbGUiXSwibGltaXRzIjpbeyJ0aWVyIjoiZGV2ZWxvcGVyL3NpbHZlciIsInR5cGUiOiJ0aHJvdHRsaW5nIn0seyJjaWRycyI6WyIxNzIuMy4xMDkuMTU0Il0sInR5cGUiOiJjbGllbnQifV19.AQM76hWNfTP8zgXdcU-yalqmUsy9-gUM6iShiupVyvuiVT1AGLAJcMhSOBXIT6SyYLGaQurn6mmUsuZRZuO-xw"
        let playerTag = clashRoyaleID.replacingOccurrences(of: "#", with: "%23") // Encode the player tag
        let urlString = "https://api.clashroyale.com/v1/players/\(playerTag)"
        guard let url = URL(string: urlString) else {
            registrationStatus = "Invalid Clash Royale ID."
            return
        }
        
        // Create the API request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        // Make the API request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                registrationStatus = "Error: \(error.localizedDescription)"
                return
            }
            
            guard let data = data else {
                registrationStatus = "Invalid Clash Royale ID."
                return
            }
            
            // Parse the response (handle success or failure)
            do {
                _ = try JSONDecoder().decode(PlayerInfo.self, from: data)
                registrationStatus = "Success! Clash Royale ID is valid."
                UserDefaults.standard.set(username, forKey: "username")
                UserDefaults.standard.set(password, forKey: "password")
                UserDefaults.standard.set(clashRoyaleID, forKey: "clashRoyaleID")

            } catch {
                registrationStatus = "Invalid Clash Royale ID."
            }
        }.resume()
    }
    
    
    
    
    
    
    struct SignUpView_Previews: PreviewProvider {
        static var previews: some View {
            SignUpView()
        }
    }
}
