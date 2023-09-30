//
//  ContentView.swift
//  RoyaleConnect
//
//  Created by Dillon Borden on 9/27/23.
//




// ...
      

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    
    

}


import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loginError: String? = nil
    @State private var isLoggedIn: Bool = false
    @State private var loginStatus = ""
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    @State private var animatedGradient = false

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                    .hueRotation(.degrees(animatedGradient ? 45 : 0))
                    .onAppear {
                        withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                            animatedGradient.toggle()
                        }
                    }
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.black)
                VStack {
                    Text("Username")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    Text("Email:")
                        .foregroundColor(.white)
                    TextField("Email", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white.opacity(1))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .border(Color.red.opacity(0.5), width: CGFloat(wrongUsername))
                    Text("Password:")
                        .foregroundColor(.white)
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .foregroundColor(.black)
                        .background(Color.white.opacity(1))
                        .cornerRadius(10)
                        .border(Color.red.opacity(0.5), width: CGFloat(wrongPassword))
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .font(.headline)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.top)
                    }
                    Button("Login") {
                        login()
                    }
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top)
                    if isLoggedIn {
                        NavigationLink(destination: Lobby(), isActive: $isLoggedIn) {
                            EmptyView()
                        }
                        .animation(.easeInOut(duration: 10))
                        Text(loginStatus)
                            .foregroundColor(loginStatus == "Success" ? .green : .red)
                    }
                    if let error = loginError {
                        Text(error)
                            .foregroundColor(.red)
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
                    .offset(y: -300)
                Spacer()
            }
        }
        .navigationBarHidden(false)
    }

    private func login() {
           Auth.auth().signIn(withEmail: email, password: password) { [self] authResult, error in
               if let maybeError = error {
                       let err = maybeError as NSError
                       switch err.code {
                       case AuthErrorCode.wrongPassword.rawValue:
                           loginError = "Incorrect password"
                       case AuthErrorCode.invalidEmail.rawValue:
                           loginError = "Invalid email"
                       case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                           loginError = "Email already exists"
                     
                       default:
                           loginError = "Login error: \(error?.localizedDescription)"
                       }
                   loginStatus = "Failed"
               } else if let _ = authResult {
                   loginError = nil
                   isLoggedIn = true
                   loginStatus = "Success"
               }
           }
       }
    private func meetsCriteria(_ user: User) -> Bool {
        // Add your criteria here
        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
