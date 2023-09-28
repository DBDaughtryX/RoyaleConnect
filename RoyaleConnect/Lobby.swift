//
//  Lobby.swift
//  RoyaleConnect
//
//  Created by Dillon Borden on 9/28/23.
//

import SwiftUI

struct Lobby: View {
    @State private var selectedTab = 0

        var body: some View {
            TabView(selection: $selectedTab) {
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
                        Label("clan Stats", systemImage: "trophy")
                    }
                    .tag(2)

                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(3)
            }
        }
    }

struct Lobby_Previews: PreviewProvider {
    static var previews: some View {
        Lobby()
    }
}
