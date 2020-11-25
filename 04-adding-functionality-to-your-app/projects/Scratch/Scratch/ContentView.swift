//
//  ContentView.swift
//  Scratch
//
//  Created by Audrey Tam on 18/11/20.
//

import SwiftUI

struct ContentView: View {
  @State var rating = 4
  var body: some View {
    RatingView(rating: $rating)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
