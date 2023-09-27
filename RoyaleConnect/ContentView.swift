//
//  ContentView.swift
//  RoyaleConnect
//
//  Created by Dillon Borden on 9/27/23.
//

import SwiftUI

struct ContentView: View {
    @State private var userName = ""
    @State private var password = ""
    @State private var clashTag = ""
    
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    @State private var invalidSuperCellID = 0
    
    @State private var showingLoginScreen = false
    
    @State private var animatedGradient = false
    
    
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
                            .offset(x: -100)
                        
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
                        
                        Text("Clash royale #: ")
                            .foregroundColor(.white)
                            .offset(x: -99)
                            .font(.subheadline)
                            .bold()
                        
                        TextField("Clash royale Tag#", text: $clashTag)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.white.opacity(1))
                            .foregroundColor(.black )
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(invalidSuperCellID))
                        
                        
                    }
                    Image("logo2")
                    
                        .resizable()
                        .frame(width: 171, height: 130)
                        .offset(y: -185)
                    
                    Text("RoyaleConnect")
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                    
                        .offset(y:-140)
                    
                        Spacer()
                        
                }
                
                
            }
        .navigationBarHidden(true)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
