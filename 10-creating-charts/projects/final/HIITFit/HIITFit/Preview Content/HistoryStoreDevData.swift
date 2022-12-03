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

import Foundation

extension HistoryStore {
  func createDevData() {
    // Development data
    exerciseDays = [
      ExerciseDay(
        date: Date().addingTimeInterval(-86400),
        exercises: [
          Exercise.exercises[0].exerciseName,
          Exercise.exercises[1].exerciseName,
          Exercise.exercises[2].exerciseName,
          Exercise.exercises[0].exerciseName,
          Exercise.exercises[0].exerciseName
        ]),
      ExerciseDay(
        date: Date().addingTimeInterval(-86400 * 3),
        exercises: [
          Exercise.exercises[2].exerciseName,
          Exercise.exercises[2].exerciseName,
          Exercise.exercises[3].exerciseName
        ]),
      ExerciseDay(
        date: Date().addingTimeInterval(-86400 * 4),
        exercises: [
          Exercise.exercises[1].exerciseName,
          Exercise.exercises[1].exerciseName
        ]),
      ExerciseDay(
        date: Date().addingTimeInterval(-86400 * 5),
        exercises: [
          Exercise.exercises[0].exerciseName,
          Exercise.exercises[1].exerciseName,
          Exercise.exercises[3].exerciseName,
          Exercise.exercises[3].exerciseName
        ])
    ]
  }

  // copy history.plist to Documents directory
  func copyHistoryTestData() {
    let filename = "history.plist"
    if let resourceURL = Bundle.main.resourceURL {
      let sourceURL = resourceURL.appending(component: filename)
      let documentsURL = URL.documentsDirectory
      let destinationURL = documentsURL.appending(component: filename)
      do {
        try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
      } catch {
        print("Failed to copy", filename)
      }
      print("Sample History data copied to Documents directory")
    }
  }

  // This method creates random test data.
  func createHistoryTestData() {
    print("Data construction started")
    exerciseDays = []
    let numberOfDays: Int = 720
    for day in 0..<numberOfDays {
      guard let date =
        Calendar.current.date(byAdding: .day, value: -day, to: Date())
      else {
        continue
      }
      var exerciseNames: [String] = []
      // repeat a random number of times (max 6) (max 24 exercises)
      // this will result in eg
      // [Squat, Step Up, Burpee, Step Up, Sun Salute, Step Up, Sun Salute]
      for _ in 0..<Int.random(in: 0...5) {
        for exercise in Exercise.exercises {
          if Bool.random() {
            exerciseNames.append(exercise.exerciseName)
          }
        }
      }
      if !exerciseNames.isEmpty {
        exerciseDays.append(ExerciseDay(date: date, exercises: exerciseNames))
      }
    }
    try? save()
    print("Data construction completed")
  }
}
