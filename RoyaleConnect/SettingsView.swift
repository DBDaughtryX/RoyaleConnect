//
//  SettingsView.swift
//  RoyaleConnect
//
//  Created by Dillon Borden on 9/29/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var muteNotifications = false
    @State private var showAboutMe = false
    @State private var showLeaveReview = false
    @State private var showTermsOfService = false
    @State private var showEditUsername = false // New state variable
    @State private var newUsername = "" // New state variable to store the new username

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Notification Settings")) {
                    Toggle("Mute Notifications", isOn: $muteNotifications)
                }

                Section(header: Text("Username")) {
                    Button("Change Username") {
                        showEditUsername.toggle()
                    }
                }

                Section(header: Text("About Me")) {
                    Button("About me") {
                        showAboutMe.toggle()
                    }
                }

                Section(header: Text("Review")) {
                    Button("Leave review") {
                        showLeaveReview.toggle()
                    }
                }

                Section(header: Text("Legal")) { 
                    Button("Terms of Service") {
                        showTermsOfService.toggle()
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
        }
        .sheet(isPresented: $showAboutMe) {
            AboutMeView()
        }
        .sheet(isPresented: $showLeaveReview) {
            LeaveReviewView()
        }
        .sheet(isPresented: $showTermsOfService) {
            TermsOfServiceView()
        }
        .sheet(isPresented: $showEditUsername) {
            EditUsernameView(newUsername: $newUsername)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
