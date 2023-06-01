//
//  ContentView.swift
//  PlaceFinder
//
//  Created by Dmitry Zasenko on 31.05.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            SearchView()
                .toolbar(.hidden)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
