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
import AVKit

struct ExerciseView: View {
  @EnvironmentObject var history: HistoryStore
  @State private var showHistory = false
  @State private var showSuccess = false
  @Binding var selectedTab: Int
  let index: Int
  @State private var timerDone = false
  @State private var showTimer = false

  var lastExercise: Bool {
    index + 1 == Exercise.exercises.count
  }

  var body: some View {
    GeometryReader { geometry in
      VStack {
        HeaderView(
          selectedTab: $selectedTab,
          titleText: Exercise.exercises[index].exerciseName)
          .padding(.bottom)
        if let url = Bundle.main.url(
          forResource: Exercise.exercises[index].videoName,
          withExtension: "mp4") {
          VideoPlayer(player: AVPlayer(url: url))
            .frame(height: geometry.size.height * 0.45)
        } else {
          Text(
            "Couldn't find \(Exercise.exercises[index].videoName).mp4")
            .foregroundColor(.red)
        }
        HStack(spacing: 150) {
          Button("Start Exercise") {
            showTimer.toggle()
          }
          Button("Done") {
            history.addDoneExercise(Exercise.exercises[index].exerciseName)
            timerDone = false
            showTimer.toggle()
            if lastExercise {
              showSuccess.toggle()
            } else {
              selectedTab += 1
            }
          }
          .disabled(!timerDone)
          .sheet(isPresented: $showSuccess) {
            SuccessView(selectedTab: $selectedTab)
          }
        }
        .font(.title3)
        .padding()
        if showTimer {
          TimerView(timerDone: $timerDone)
        }
        Spacer()
        RatingView(exerciseIndex: index)
          .padding()
        Button("History") {
          showHistory.toggle()
        }
        .sheet(isPresented: $showHistory) {
          HistoryView(showHistory: $showHistory)
        }
          .padding(.bottom)
      }
    }
  }
}

struct ExerciseView_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseView(selectedTab: .constant(0), index: 0)
      .environmentObject(HistoryStore())
  }
}
