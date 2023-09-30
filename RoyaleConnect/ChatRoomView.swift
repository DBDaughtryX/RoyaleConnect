//
//  ChatRoomView.swift
//  RoyaleConnect
//
//  Created by Dillon Borden on 9/28/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ChatRoomView: View {
    @State private var message = ""
    @State private var messages: [ChatMessage] = []
    private var db = Firestore.firestore()
    private let currentUser = Auth.auth().currentUser
    private let messageLifetimeInSeconds: TimeInterval = 10 // Set the message lifetime to 60 seconds

    var body: some View {
        VStack {
            List(messages, id: \.id) { message in
                MessageRow(message: message, currentUser: currentUser)
            }
            HStack {
                TextField("Type your message", text: $message)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    sendMessage()
                }
            }
            .padding()
        }
        .onAppear {
            loadMessages()
        }
        .navigationBarTitle("Chat Room")
        .onReceive(Timer.publish(every: 10, on: .main, in: .common).autoconnect()) { _ in
            removeExpiredMessages()
        }
    }

    private func loadMessages() {
        db.collection("chatMessages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                messages = documents.compactMap { document in
                    let data = document.data()
                    guard
                        let text = data["text"] as? String,
                        let senderID = data["senderID"] as? String,
                        let timestamp = (data["timestamp"] as? Timestamp)?.dateValue()
                    else { return nil }

                    return ChatMessage(id: document.documentID, text: text, senderID: senderID, timestamp: timestamp)
                }
                // Fetch and update usernames
                fetchUsernames()
            }
    }

    private func sendMessage() {
        if !message.isEmpty, let currentUser = currentUser {
            let messageData: [String: Any] = [
                "text": message,
                "senderID": currentUser.uid,
                "timestamp": FieldValue.serverTimestamp()
            ]

            db.collection("chatMessages").addDocument(data: messageData) { error in
                if let error = error {
                    print("Error sending message: \(error.localizedDescription)")
                } else {
                    message = ""
                }
            }
        }
    }

    private func fetchUsernames() {
        // Fetch usernames for senderIDs
        let senderIDs = Set(messages.map { $0.senderID })

        for senderID in senderIDs {
            db.collection("users").document(senderID).getDocument { document, error in
                if let error = error {
                    print("Error fetching username: \(error.localizedDescription)")
                } else if let document = document, document.exists {
                    if let username = document.data()?["username"] as? String {
                        // Update the usernames in the messages
                        messages = messages.map { message in
                            var updatedMessage = message
                            if message.senderID == senderID {
                                updatedMessage.username = username
                            }
                            return updatedMessage
                        }
                    }
                }
            }
        }
    }

    private func removeExpiredMessages() {
        let currentDate = Date()
        messages = messages.filter { message in
            if let timestamp = message.timestamp {
                return currentDate.timeIntervalSince(timestamp) <= messageLifetimeInSeconds
            } else {
                return true // Keep messages with no timestamp (just in case)
            }
        }
        // Remove expired messages from Firebase Firestore
        let expiredMessages = messages.filter { message in
            if let timestamp = message.timestamp {
                return currentDate.timeIntervalSince(timestamp) > messageLifetimeInSeconds
            } else {
                return false // No timestamp, don't remove
            }
        }
        for expiredMessage in expiredMessages {
            db.collection("chatMessages").document(expiredMessage.id).delete { error in
                if let error = error {
                    print("Error deleting message: \(error.localizedDescription)")
                }
            }
        }
    }
}

struct ChatRoomView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomView()
    }
}

struct MessageRow: View {
    let message: ChatMessage
    let currentUser: User?

    var body: some View {
        HStack {
            if let currentUser = currentUser, message.senderID == currentUser.uid {
                Spacer()
                Text(message.text)
                    .padding(10)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            } else {
                Text("\(message.username ?? "Unknown User"): \(message.text)")
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

struct ChatMessage: Identifiable, Hashable {
    var id: String
    var text: String
    var senderID: String
    var timestamp: Date?
    var username: String? 

    // Conform to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // Conform to Equatable
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs.id == rhs.id
    }
}
