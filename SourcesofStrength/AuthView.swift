//
//  AuthView.swift
//  SourcesofStrength
//
//  Created by Greg Schloemer on 4/7/20.
//  Copyright © 2020 Berea Community Schools. All rights reserved.
//

import SwiftUI

struct AuthView: View{
    var body: some View {
        NavigationView{
            SignInView()
        }
    }
}

struct SignInView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @EnvironmentObject var session: SessionStore
    
    func getWelcomeMessageFromTime() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 6..<12 : return "Good morning!"
        case 12..<17 : return "Good afternoon"
        default: return "Good evening."
        }
    }
    
    func signIn() {
        session.signIn(email: email, password:password) { (result, error) in
            if let error = error{
                self.error = error.localizedDescription
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
    
    var body: some View {
        VStack{
            Image("Big-wheel")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(2)
            Text(getWelcomeMessageFromTime())
                .font(.system(size:32, weight:.heavy))
            
            Text("Sign in to continue...")
                .font(.system(size:18, weight:.medium))
                .foregroundColor(.gray)
            
            VStack(spacing: 18){
                TextField("Email:", text: $email)
                    .font(.system(size:14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(.systemGray), lineWidth: 1))
                
                SecureField("Password:", text: $password)
                    .font(.system(size:14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(.systemGray), lineWidth: 1))
            }
            .padding(.vertical, 64)
            
            Button(action:signIn) {
                Text("Sign in")
                    .frame(minWidth:0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .font(.system(size:14, weight:.bold))
                    .background(LinearGradient(gradient:Gradient(colors:[Color(.blue), Color(.red)]), startPoint:.leading, endPoint: .trailing))
                    .cornerRadius(5)
            }
            if (error != ""){
                Text(error)
                    .font(.system(size:14, weight:.semibold))
                    .foregroundColor(.red)
                    .padding()
            }
            Spacer()
            
            NavigationLink(destination: SignUpView()){
                HStack {
                    Text("I'm a new user.")
                        .font(.system(size:14, weight:.light))
                        .foregroundColor(.primary)
                    
                    Text("Create an account")
                        .font(.system(size:14, weight:.semibold))
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.horizontal, 32)
        
    }
}

struct SignUpView: View{
    
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @EnvironmentObject var session: SessionStore
    
    func signUp() {
        session.signUp(email: email, password:password) { (result, error) in
            if let error = error{
                self.error = error.localizedDescription
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }
    
    var body: some View{
        VStack {
            Text("Create an Account")
                .font(.system(size:32, weight:.heavy))
            
            Text("Let's get to know you...")
                .font(.system(size:18, weight:.medium))
                .foregroundColor(.gray)
            
            VStack(spacing: 18) {
                TextField("Email address", text: $email)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(.systemGray), lineWidth: 1))
                
                SecureField("Password:", text: $password)
                    .font(.system(size:14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(.systemGray), lineWidth: 1))
            }
            Button(action:signUp) {
                Text("Sign up")
                    .frame(minWidth:0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .font(.system(size:14, weight:.bold))
                    .background(LinearGradient(gradient:Gradient(colors:[Color(.blue), Color(.red)]), startPoint:.leading, endPoint: .trailing))
                    .cornerRadius(5)
            }
            
            if (error != ""){
                Text(error)
                    .font(.system(size:14, weight: .semibold))
                    .foregroundColor(.red)
                .padding()
            }
            Spacer()
        }
        .padding(.vertical, 64)
        
    }
}
    
    struct SignInView_Previews: PreviewProvider {
        static var previews: some View {
            SignInView()
        }
}
