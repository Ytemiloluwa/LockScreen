//
//  ContentView.swift
//  Shared
//
//  Created by Temiloluwa on 05/10/2020.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationView {
            
            Home()
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    
    @State var unLocked = false
    
    var body : some View {
        
        ZStack {
            
            
            if unLocked {
            
                Text("TEMI")
                    .font(.system(size: 30))
            }
            else {
                
                LockScreen(unLocked: $unLocked)
                    .preferredColorScheme(.dark)
                
            }
            
        }
        .preferredColorScheme(unLocked ? .light: .dark)
        
        
    }
}

struct LockScreen: View {
    @State var password = ""
    
    // you can change it whgen the user clicks reset password
    // AppStorage => UserDefaults
    @AppStorage("lockpassword") var key = "5654"
    @Binding var unLocked: Bool
    @State var wrongPassword = false
    let height = UIScreen.main.bounds.width
    var body : some View {
        VStack{
            
            HStack {
                
                Spacer(minLength: 0)
                
                Menu(content: {
                    
                    Label(
                        title: { Text("Help") },
                        icon: { Image(systemName: "info.circle.fill") })
                        .onTapGesture(perform: {
                            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Code@*/ /*@END_MENU_TOKEN@*/
                        })
                    
                    Label(
                        title: { Text("Reset Password") },
                        icon: { Image(systemName: "key.fill") })
                        .onTapGesture(perform: {
                            //
                        })
                    
                    
                }) {
                    Image("menu")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 19, height: 5)
                        .foregroundColor(Color.white)
                        .padding()
                }
            }
            .padding()
            
            Image(systemName: "lock.fill")
                .resizable()
                .frame(width: 95, height: 95)
                .padding(.top, 20)
            
            Text("Enter pin to Unlock")
                .font(.title2)
                .fontWeight(.heavy)
                .padding(.top, 20)
            
            HStack(spacing: 22) {
                
                // Password circles  Views
                
                ForEach(0..<4, id: \.self) { index  in
                    PasswordView(index: index, password: $password)
                }
            }.padding(.top,height < 750 ? 20 :  30)
            
            // keypad
            
            Spacer(minLength: 0)
            
            Text(wrongPassword ? "IncorrectPassword" : "")
                .foregroundColor(Color.red)
                .fontWeight(.heavy)
            
            Spacer(minLength: 0)
            
            LazyVGrid(columns : Array(repeating: GridItem(.flexible()), count: 3), spacing: height < 750 ? 5 :15) {
                // password Button
                
                ForEach(1...9, id: \.self) { value in
                    
                    PasswordButton(value: "\(value)", password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword)
                    
                }
                
                PasswordButton(value: "delete.fill", password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword)
                
                PasswordButton(value: "0", password: $password, key: $key, unlocked: $unLocked, wrongPass: $wrongPassword)
                
            }
            .padding(.bottom)
            
            Spacer(minLength: 0)
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        
    }
}
struct PasswordView: View {
    
    var index: Int
    
    @Binding var password: String
    var body : some View {
        
        ZStack {
            
            Circle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: 30, height: 30)
            
            // Checking whether password is typed
            
            if password.count > index {
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 30, height: 30)
            }
        }
    }
    
}
struct PasswordButton: View {
    
    var value: String
    @Binding var password: String
    @Binding var key: String
    @Binding var unlocked: Bool
    @Binding var wrongPass: Bool
    
    var body : some View {
        
        Button(action: setPassword, label: {
            
            VStack {
                
                if value.count > 1 {
                    
                    // Image
                    
                    Image(systemName: "delete.left")
                        .font(.system(size: 24))
                        .foregroundColor(Color.white)
                }
                else {
                    Text(value)
                        .font(.title)
                        .foregroundColor(Color.white)
                    
                }
                
            }
            .padding()
            
        })
        
    }
    func setPassword() {
        
        // check if backspaced pressed
        
        withAnimation {
            
            if value.count > 1 {
                
                if password.count != 0 {
                    
                    password.removeLast()            }
            }
            else {
                if password.count != 4 {
                    
                    password.append(value)
                    
                    // Delay Animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation {
                            if password.count == 4 {
                                
                                if password == key {
                                    
                                    unlocked = true
                                }
                                else {
                                    wrongPass = true
                                    password.removeAll()
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    
}
