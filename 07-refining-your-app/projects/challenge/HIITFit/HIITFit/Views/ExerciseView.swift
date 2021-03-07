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
  @Binding var selectedTab: Int
  @State private var timerDone = false

  @State private var showSuccess = false
  @State private var showSheet = false
  @State private var showHistory = false
  @State private var showTimer = false

  @State private var exerciseSheet: ExerciseSheet?

  let index: Int

  enum ExerciseSheet {
    case history, timer, success
  }

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
        Spacer()
        ContainerView {
          VStack {
            video(size: geometry.size)
            startExerciseButton
              .padding(20)
            RatingView(exerciseIndex: index)
              .padding()
            Spacer()
            historyButton
          }
        }
        .frame(height: geometry.size.height * 0.8)
        .sheet(isPresented: $showSheet, onDismiss: {
          if exerciseSheet == .timer {
            if timerDone {
            history.addDoneExercise(Exercise.exercises[index].exerciseName)
              timerDone = false
            }
            showTimer = false
            if lastExercise {
              showSuccess = true
              showSheet = true
              exerciseSheet = .success
            } else {
              selectedTab += 1
            }
          } else {
            exerciseSheet = nil
          }
          showHistory = false
          showSuccess = false
          showTimer = false
        }, content: {
          if let exerciseSheet = exerciseSheet {
            switch exerciseSheet {
            case .history:
              HistoryView(showHistory: $showHistory)
            case .timer:
              TimerView(
                timerDone: $timerDone,
                exerciseName: Exercise.exercises[index].exerciseName)
            case .success:
              SuccessView(selectedTab: $selectedTab)
            }
          }
        })
      }
    }
  }

  @ViewBuilder
  func video(size: CGSize) -> some View {
    if let url = Bundle.main.url(
      forResource: Exercise.exercises[index].videoName,
        withExtension: "mp4") {
      VideoPlayer(player: AVPlayer(url: url))
        .frame(height: size.height * 0.25)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(20)
    } else {
      Text(
        "Couldn't find \(Exercise.exercises[index].videoName).mp4")
        .foregroundColor(.red)
    }
  }

  var startExerciseButton: some View {
    RaisedButton(buttonText: "Start Exercise") {
      showTimer.toggle()
      showSheet = true
      exerciseSheet = .timer
    }
  }

  var historyButton: some View {
    Button(
      action: {
        showSheet = true
        showHistory = true
        exerciseSheet = .history
      }, label: {
        Text("History")
          .fontWeight(.bold)
          .padding([.leading, .trailing], 5)
      })
      .padding(.bottom, 10)
      .buttonStyle(EmbossedButtonStyle())
  }
}

struct ExerciseView_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseView(selectedTab: .constant(0), index: 0)
      .environmentObject(HistoryStore())
  }
}
