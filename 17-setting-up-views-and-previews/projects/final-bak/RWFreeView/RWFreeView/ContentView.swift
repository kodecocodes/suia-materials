/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct ContentView: View {
  @StateObject var store = EpisodeStore()
  @State var showFilters = false

  var body: some View {
    NavigationView {
      List {
        HeaderView(count: store.episodes.count)
        ForEach(store.episodes, id: \.name) { episode in
          NavigationLink(
            destination: PlayerView(episode: episode)) {
            EpisodeView(episode: episode)
          }
//          ZStack {
//            NavigationLink(destination: PlayerView(episode: episode)) {
//              EmptyView()
//            }
//            .opacity(0)
//            .buttonStyle(PlainButtonStyle())
//            EpisodeView(episode: episode)
//          }
//          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
//          .listRowInsets(EdgeInsets())
//          .padding(.bottom, 8)
//          .padding([.leading, .trailing], 26)
//          .background(Color.listBkgd)
        }
      }
      .navigationTitle("Videos")
      .toolbar {
        ToolbarItem {
          // swiftlint:disable:next multiple_closures_with_trailing_closure
          Button(action: { showFilters.toggle() }) {
            Image(systemName: "line.horizontal.3.decrease.circle")
              .accessibilityLabel(Text("Shows filter options"))
          }
          .sheet(isPresented: $showFilters) {
            FilterOptionsView()
          }
        }
      }
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
    //.preferredColorScheme(.dark)
  }
}

struct HeaderView: View {
  let count: Int
  @State private var sortOn = "popular"

  var body: some View {
    HStack {
      Text("\(count) Tutorials")
      Spacer()
      Picker("", selection: $sortOn) {
        Text("New").tag("new")
        Text("Popular").tag("popular")
      }
      .pickerStyle(SegmentedPickerStyle())
      //.background(Color(UIColor.systemFill))
      .frame(width: 130)
    }
    .font(.footnote)
    .padding()
    .roundedGradientBackground()
  }
}

struct EpisodeView: View {
  let episode: Episode

  var body: some View {
    HStack(alignment: .top) {
      PlayButtonIcon(width: 40, height: 40, radius: 6)
      VStack(alignment: .leading, spacing: 6) {
        Text(episode.name)
          .font(.headline)
          .fontWeight(.bold)
          .foregroundColor(Color(UIColor.label))
        HStack {
          Text(episode.released + "  ")
          Text(episode.domain + "  ")
          Text(String(episode.difficulty).capitalized)
        }
        Text(episode.description)
          .lineLimit(2)
      }
      .padding(.horizontal)
      .font(.footnote)
      .foregroundColor(Color(UIColor.systemGray))
    }
//    .padding()
//    .background(Color.itemBkgd)
//    .cornerRadius(15)
//    .shadow(color: Color.black.opacity(0.1), radius: 10)
  }
}
