//
//  ContentView.swift
//  HW2
//
//  Created by Bo Fu on 10/25/24.
//

import SwiftUI
import PhotosUI
import Photos

struct ContentView: View {
    @SceneStorage("name") private var nameComponents : String = ""
    @SceneStorage("useSavedName") private var useSavedName : Bool = true
    @AppStorage("nameValue") private var savedName : String = ""
    @State private var nameComponents2 : String = ""
    @AppStorage("nameValue2") private var savedName2 : String = ""
    
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack {
            TextField(
                    "The Scene Storage Name",
                    text: $nameComponents
                )
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.secondary)
            Text(nameComponents)
            Button(action: {
                savedName = nameComponents
            }) {
                Text("Save the Name")
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(Color.black)
                    .cornerRadius(10)
            }
            
            TextField(
                    "The App Storage Name",
                    text: $nameComponents2
                )
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .border(.secondary)
            Text(nameComponents2)
        }
        .onAppear(){
            //when first appear, use the saved name
            if useSavedName == true {
                nameComponents = savedName
                useSavedName = false
            }
        }
        .onChange(of: scenePhase){
            if scenePhase == .background{
                savedName2 = nameComponents2
            }
            else if scenePhase == .active{
                nameComponents2 = savedName2
            }
        }

    }
}

#Preview {
    ContentView()
}

