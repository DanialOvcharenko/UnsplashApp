//
//  ContentView.swift
//  UnsplashApp
//
//  Created by Mac on 20.01.2023.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        
        NavigationView{
            Home()
            .navigationBarHidden(true)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}












