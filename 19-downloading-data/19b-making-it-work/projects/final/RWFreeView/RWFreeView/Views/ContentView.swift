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
  @EnvironmentObject var store: EpisodeStore
  @State private var showFilters = false

  var body: some View {
    NavigationView {
      List {
        HeaderView(count: store.episodes.count)
        if store.episodes.isEmpty { ActivityIndicator() }
        ForEach(store.episodes) { episode in
          ZStack {
            NavigationLink(destination: PlayerView(episode: episode)) {
              EmptyView()
            }
            .opacity(0)
            .buttonStyle(PlainButtonStyle())
            EpisodeView(episode: episode)
          }
          .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .leading)
          .listRowInsets(EdgeInsets())
          .padding(.bottom, 8)
          .padding([.leading, .trailing], 20)
          .background(Color.listBkgd)
        }
        .redacted(
          reason: store.loading ? .placeholder : []
        )
      }
      .navigationTitle("Videos")
      .toolbar {
        ToolbarItem {
          // swiftlint:disable:next multiple_closures_with_trailing_closure
          Button(action: { showFilters.toggle() }) {
            Image(systemName: "line.horizontal.3.decrease.circle")
              .accessibilityLabel(Text("Shows filter options"))
          }
        }
      }
      .sheet(isPresented: $showFilters) {
        FilterOptionsView()
      }
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }

  init() {
    // 1. White title on black background
    let appearance = UINavigationBarAppearance()
    appearance.backgroundColor = UIColor(named: "top-bkgd")
    appearance.largeTitleTextAttributes =
      [.foregroundColor: UIColor.white]
    appearance.titleTextAttributes =
      [.foregroundColor: UIColor.white]

    // 2. Back button text and arrow color
    UINavigationBar.appearance().tintColor = .white

    // 3. Assign configuration to all appearances
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance

    // 4. Selected segment color
    UISegmentedControl.appearance()
      .selectedSegmentTintColor = UIColor(named: "list-bkgd")
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(EpisodeStore())
    //.preferredColorScheme(.dark)
  }
}
