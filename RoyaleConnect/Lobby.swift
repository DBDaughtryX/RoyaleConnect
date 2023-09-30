//
//  Lobby.swift
//  RoyaleConnect
//
//  Created by Dillon Borden on 9/28/23.
//

import SwiftUI

struct Lobby: View {
    @State private var selectedTab = 0
    @State private var isMainPagePresented = false // State variable to control the Main Page presentation

    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                NavigationLink(destination: MainPage()) {
                    Text("Main")
                }
                .tabItem {
                    Label("Main", systemImage: "house")
                }
                .tag(4) // Assign a unique tag to the "Main" tab

                ChatRoomView()
                    .tabItem {
                        Label("Chat", systemImage: "message")
                    }
                    .tag(0)

                FriendListView()
                    .tabItem {
                        Label("Friends", systemImage: "person.2")
                    }
                    .tag(1)

                ClanStats()
                    .tabItem {
                        Label("Clan Stats", systemImage: "trophy")
                    }
                    .tag(2)

                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(3)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(trailing: NavigationLink(destination: SettingsView()) {
                Image(systemName: "gear")
                    .font(.system(size: 30))
                    .imageScale(.large)
                    .padding()
            })
        }
    }
}

struct Lobby_Previews: PreviewProvider {
    static var previews: some View {
        Lobby()
    }
}

