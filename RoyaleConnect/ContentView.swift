//
//  ContentView.swift
//  RoyaleConnect
//
//  Created by Dillon Borden on 9/27/23.
//

import SwiftUI
import Foundation

struct ContentView: View {
    
    @State private var userName = UserDefaults.standard.string(forKey: "username") ?? ""
    @State private var password = UserDefaults.standard.string(forKey: "password") ?? ""
    @State private var clashRoyaleID = UserDefaults.standard.string(forKey: "clashRoyaleID") ?? ""
    @State private var loginStatus = ""
    
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    @State private var invalidSuperCellID = 0
    
    @State private var showingLoginScreen = false
    
    @State private var animatedGradient = false
    
    @State private var isLoggedIn = false // Added state to track login status
    
    
    var body: some View {
        
        NavigationView{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                    .hueRotation(.degrees(animatedGradient ? 45 : 0))
                    .onAppear{
                        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)){
                            animatedGradient.toggle()
                        }
                    }
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.black)
                VStack{
                    Text("Username")
                        .foregroundColor(.black)
                        .offset(x: -900)
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .padding()
                    
                    Text("Username: ")
                        .foregroundColor(.white)
                        .offset(x: -100, y: 10)
                    
                    TextField("Username", text: $userName)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white.opacity(1))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongUsername))
                        .offset(y: 10)
                    
                    Text("Password: ")
                        .foregroundColor(.white)
                        .offset(x: -110, y: 22)
                    
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .foregroundColor(.black)
                        .background(Color.white.opacity(1))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongPassword))
                        .padding()
                    
                    Text("PlayerTag: ")
                        .foregroundColor(.white)
                        .offset(x: -110)
                        .font(.subheadline)
                        .bold()
                    
                    TextField("PlayerTag#", text: $clashRoyaleID)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white.opacity(1))
                        .foregroundColor(.black )
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(invalidSuperCellID))
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .offset(x: -90 )
                        
                    }
                    
                    Button("Login"){
                        signInUser()
                    }
                    
                    if isLoggedIn {
                        NavigationLink(destination: MainPage(), isActive: $isLoggedIn) {
                        }
                        Text(loginStatus)
                            .foregroundColor(loginStatus == "Success" ? .green : .red)
                            
                    }
                    
                    
                    
                    
                }
                Image("logo2")
                
                    .resizable()
                    .frame(width: 150, height: 70)
                    .offset(y: -210)
                
                Text("RoyaleConnect")
                    .foregroundColor(.white)
                    .font(.title)
                    .bold()
                    .offset(y:-300)
                
                Spacer()
                
                
                
                
                
            }
            
        }
        
        .navigationBarHidden(false)
    }
    private func signInUser() {
        // Debugging: Print entered data
        print("Entered Data:")
        print("Username: \(userName)")
        print("Password: \(password)")
        print("Clash Royale ID: \(clashRoyaleID)")
        
        // Debugging: Print stored data
        print("Stored Data:")
        if let storedUsername = UserDefaults.standard.string(forKey: "username"),
           let storedPassword = UserDefaults.standard.string(forKey: "password"),
           let storedClashRoyaleID = UserDefaults.standard.string(forKey: "clashRoyaleID") {
            print("Stored Username: \(storedUsername)")
            print("Stored Password: \(storedPassword)")
            print("Stored Clash Royale ID: \(storedClashRoyaleID)")
            
            if userName == UserDefaults.standard.string(forKey: "username") &&
                password == UserDefaults.standard.string(forKey: "password") &&
                clashRoyaleID == UserDefaults.standard.string(forKey: "clashRoyaleID") {
                loginStatus = "Success"
                isLoggedIn = true
            } else {
                print("Stored data not found")
                // Implement the login logic here, including validation
                // Example: Validate input, check credentials, and set loginStatus
                if userName == UserDefaults.standard.string(forKey: "username") &&
                    password == UserDefaults.standard.string(forKey: "password") &&
                    clashRoyaleID == UserDefaults.standard.string(forKey: "clashRoyaleID") {
                    loginStatus = "Success"
                    isLoggedIn = true
                } else {
                    loginStatus = "Invalid credentials"
                    isLoggedIn = false
                }
            }
            print("isLoggedIn: \(isLoggedIn)")
            print("loginStatus: \(loginStatus)")
            
        }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
