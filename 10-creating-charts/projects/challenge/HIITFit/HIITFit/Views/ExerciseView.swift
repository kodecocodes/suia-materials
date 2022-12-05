/// Copyright (c) 2022 Kodeco LLC
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

struct ExerciseView: View {
  @EnvironmentObject var history: HistoryStore
  @State private var showHistory = false
  @State private var showSuccess = false
  @State private var timerDone = false
  @State private var showTimer = false

  @Binding var selectedTab: Int
  let index: Int

  var exercise: Exercise {
    Exercise.exercises[index]
  }
  var lastExercise: Bool {
    index + 1 == Exercise.exercises.count
  }

  var startButton: some View {
    RaisedButton(buttonText: "Start Exercise") {
      showTimer.toggle()
    }
  }

  var doneButton: some View {
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
  }

  var body: some View {
    let exerciseName = Exercise.exercises[index].exerciseName
    GeometryReader { geometry in
      VStack(spacing: 0) {
        HeaderView(
          selectedTab: $selectedTab,
          titleText: exerciseName)
          .padding(.bottom)
        Spacer()
        ContainerView {
          VStack {
            VideoPlayerView(videoName: exercise.videoName)
              .frame(height: geometry.size.height * 0.35)
              .padding(20)
            HStack(spacing: 150) {
              startButton
                .padding([.leading, .trailing], geometry.size.width * 0.1)
                .sheet(isPresented: $showTimer) {
                  TimerView(
                    timerDone: $timerDone,
                    exerciseName: exerciseName)
                  .onDisappear {
                    if timerDone {
                      history.addDoneExercise(Exercise.exercises[index].exerciseName)
                      timerDone = false
                      if lastExercise {
                        showSuccess.toggle()
                      } else {
                        withAnimation {
                          selectedTab += 1
                        }
                      }
                    }
                  }
                }
                .sheet(isPresented: $showSuccess) {
                  SuccessView(selectedTab: $selectedTab)
                    .presentationDetents([.medium, .large])
                }
            }
            .font(.title3)
            .padding()
            Spacer()
            RatingView(exerciseIndex: index)
              .padding()
            historyButton
              .sheet(isPresented: $showHistory) {
                HistoryView(showHistory: $showHistory)
              }
              .padding(.bottom)
          }
        }
        .frame(height: geometry.size.height * 0.8)
      }
    }
  }

  var historyButton: some View {
    Button(
      action: {
        showHistory = true
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
