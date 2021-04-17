//
//  ContentView.swift
//  oauthsample
//
//  Created by Sachin Gupta on 4/16/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = SignInViewModel()
        
        var body: some View {
            VStack(spacing: 16) {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.yellow)
                
                VStack(spacing: 8) {
                    Text("You must be logged in to your Anilist account to use this feature")
                        .foregroundColor(.secondary)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button {
                        viewModel.signIn()
                    } label: {
                        Text("Sign In")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(.blue))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
