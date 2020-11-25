/// Copyright (c) 2020 Razeware LLC
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
  @EnvironmentObject var tab: Tab
  @EnvironmentObject var history: HistoryStore

  @State var exercise: Exercise
  let nextExercise: NSUUID?

  @State var timeRemaining = 30
  @State var showTimer = false
  @State var showSuccess = false
  @State var showHistory = false

  var lastExercise: Bool {
    tab.selected == Exercise.exercises.last?.id
  }

  var body: some View {
    GeometryReader { geometry in
      VStack {
        HeaderView(titleText: exercise.exerciseName)
          .padding(.bottom)
        if let url = Bundle.main.url(
          forResource: exercise.videoName,
          withExtension: "mp4") {
          VideoPlayer(player: AVPlayer(url: url))
            .frame(height: geometry.size.height * 0.45)
        } else {
          Text("Couldn't find \(exercise.videoName).mp4")
            .foregroundColor(.red)
        }
        if showTimer {
          TimerView(timeRemaining: $timeRemaining)
        }
        Button(showTimer ? "Done" : "Start Exercise") {
          if showTimer {
            history.addDoneExercise(exercise.exerciseName)
            if let next = nextExercise {
              tab.selected = next
            } else {
              showSuccess.toggle()
            }
          }
          showTimer.toggle()
        }
        .font(.title3)
        .padding()
        .sheet(isPresented: $showSuccess) {
          SuccessView(showSuccess: $showSuccess)
        }
        RatingView(rating: $exercise.rating)
          .padding()
        Spacer()
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

//struct ExerciseView_Previews: PreviewProvider {
//  static var previews: some View {
//    ExerciseView(
//      exercise: Exercise(
//        exerciseName: "Step Up",
//        videoName: "step-up",
//        rating: 3),
//      showHistory: false)
//  }
//}
