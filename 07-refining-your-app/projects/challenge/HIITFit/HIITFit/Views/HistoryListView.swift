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

struct HistoryListView: View {
  @EnvironmentObject var history: HistoryStore

  var body: some View {
    ScrollView {
      ForEach(history.exerciseDays) { day in
        Section(
          header:
            HStack {
              Text(day.date.formatted(as: "MMM d"))
                .font(.title3)
                .fontWeight(.medium)
                .padding()
              Spacer()
            },
          footer:
            Divider()
            .padding(.top, 40)
        ) {
          // Only the first four exercises are shown
          // After Part II, you will be able to add all
          // exercises in a grid
          HStack(spacing: 40) {
            ForEach(0..<min(day.exercises.count, 4)) { index in
              let exercise = day.exercises[index]
              VStack {
                IndentView {
                  switch exercise {
                  case "Squat":
                    Image(systemName: "bolt.fill")
                      .frame(minWidth: 60)
                  //                        .padding(15)
                  case "Step Up":
                    Image(systemName: "arrow.uturn.up")
                      .frame(minWidth: 60)
                  case "Burpee":
                    Image(systemName: "hare.fill")
                      .frame(minWidth: 60)
                  default:
                    Image(systemName: "sun.max.fill")
                      .frame(minWidth: 60)
                  //                        .padding(15)
                  }
                }
                .foregroundColor(Color("exercise-history"))
                .padding(.bottom, 20)
                Text(exercise)
                  .font(.caption)
                  .fontWeight(.light)
                  .foregroundColor(Color.primary)
              }
            }
          }
          .frame(maxWidth: .infinity)
          .font(.headline)
        }
      }
    }
    .frame(maxWidth: .infinity)
  }
}

struct HistoryListView_Previews: PreviewProvider {
  static var previews: some View {
    HistoryListView()
      .environmentObject(HistoryStore(debugData: true))
  }
}
