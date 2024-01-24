//
//  RegistrationView.swift
//  TaskSwift
//
//  Created by Phyo Thiengi  on 01/01/2024.
//

import SwiftUI

struct RegistrationView: View {
    @State var viewModel = RegistrationViewModel()
  
    @Environment(\.dismiss) var dimiss
    var body: some View {
        VStack {
            Spacer()
            Image("Threads-Logo")
                .resizable()
                .scaledToFit()
                .frame(width:150, height:150)
                .padding()
            VStack {
                TextField("Enter your email", text: $viewModel.email)
                    .autocapitalization(.none)
                    
                
                SecureField("Enter your password", text: $viewModel.password)
                    
                
                TextField("Enter your Full Name", text: $viewModel.fullname)
                    
                
                TextField("Enter your Username", text: $viewModel.username)
                    .autocapitalization(.none)
            }
            Button {
                Task { try await viewModel.createUser()}
            } label: {
                Text("Sign Up")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 352, height: 44)
                    .background(.black)
                    .cornerRadius(8)
            }
            .padding(.vertical)
            
            Spacer()
            
            Divider()
            
            Button{
                dimiss()
            }label: {
                HStack(spacing: 3) {
                    Text("Already have an account")
                    Text("Sign In")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.black)
                .font(.footnote)
            }
            .padding(.vertical, 16)
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
