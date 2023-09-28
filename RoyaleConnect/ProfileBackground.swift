//
//  ProfileBackground.swift
//  RoyaleConnect
//
//  Created by Dillon Borden on 9/28/23.
//

import SwiftUI

struct ProfileBackground: View {
    @State private var isGlowing = false

     var body: some View {
         ZStack {
             Color.black.edgesIgnoringSafeArea(.all)

             Text("RoyaleConnect")
                 .font(.largeTitle)
                 .foregroundColor(Color.white)
                 .opacity(isGlowing ? 1.0 : 0.8)
                 .blendMode(.screen)
                 .offset(y: -300)
                 .animation(
                     Animation.easeInOut(duration: 1.0)
                         .repeatForever(autoreverses: false)
                 )
                 .onAppear() {
                     isGlowing.toggle()
                 }

             Text("RoyaleConnect")
                 .font(.largeTitle)
                 .foregroundColor(Color.clear)
                 .background(
                     Text("RoyaleConnect")
                         .font(.largeTitle)
                         .foregroundColor(Color.white)
                         .padding(4)
                         .background(
                             Color.black
                                 .blur(radius: 10)
                         )
                         .mask(
                             Text("RoyaleConnect")
                                 .font(.largeTitle)
                                 .foregroundColor(Color.white)
                         )
                 )
                 .blendMode(.colorDodge)
             
         }
         
     }
 }

struct ProfileBackground_Previews: PreviewProvider {
    static var previews: some View {
        ProfileBackground()
    }
}
