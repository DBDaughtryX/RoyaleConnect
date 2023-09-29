//
//  ContentView.swift
//  RoyaleConnect
//
//  Created by Dillon Borden on 9/27/23.
//

import SwiftUI
import Foundation
//import FirebaseCore
import Firebase
import FirebaseAuth


// ...
      

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    
    

}




struct ContentView: View {
    
    
    
    
    @State private var email = ""
    @State private var password = ""
    @State private var loginError: String? = nil
    @State private var isLoggedIn: Bool = false
    
    @State private var loginStatus = ""
    
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    @State private var invalidSuperCellID = 0
    
    @State private var showingLoginScreen = false
    
    @State private var animatedGradient = false
    
    //  @State private var isLoggedIn = false // Added state to track login status
    
    
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
                        
                        Text("Email:  ")
                            .foregroundColor(.white)
                            .offset(x: -120, y: 10)
                        
                        TextField("Email", text: $email)
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
                            login()
                        }
                        
                        if isLoggedIn {
                            NavigationLink(destination: Lobby(), isActive: $isLoggedIn) {
                                EmptyView()
                            }
                            .animation(.easeInOut(duration: 10))
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
    
    private func login() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                loginError = "Login error: \(error.localizedDescription)"
            } else if let authResult = authResult {
                // Check if the user meets the criteria (e.g., linked Supercell ID)
                if meetsCriteria(authResult.user) {
                    // Successful login
                    loginError = nil
                    isLoggedIn = true
                } else {
                    loginError = "User does not meet criteria."
                }
            }
        }
    }

    private func meetsCriteria(_ user: User) -> Bool {
        // Implement your criteria-checking logic here.
        // For example, check if the user has linked their Supercell ID.
        // You can fetch user data from Firestore or another database to determine this.
        // If the criteria are met, return true; otherwise, return false.
        return true // Placeholder; implement your logic
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
