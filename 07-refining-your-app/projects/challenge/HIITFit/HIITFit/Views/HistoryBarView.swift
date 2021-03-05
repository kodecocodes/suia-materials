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

struct HistoryBarView: View {
  let history: HistoryStore

  @State private var days: [Date] = []
  @State private var exercisesForWeek: [ExerciseDay] = []
  @State private var countsForWeek: [Int] = []
  @State private var datesExercised: [Date] = []

  var maxBarHeight: Int = 300

  var body: some View {
    GeometryReader { geometry in
      VStack {
  //      Spacer()
        HStack {
          ForEach(0..<7) { index in
            bar(day: index, size: geometry.size)
          }
  //        ForEach(days, id: \.self) { date in
  //          bar(date: date)
  //        }
        }
        Divider()
        Spacer()
      }
      .onAppear {
        days = Date().lastSevenDays
        exercisesForWeek = [ExerciseDay](history.exerciseDays.prefix(7))
        let counts: [Int] = days.map { day in
          let foundDate = exercisesForWeek.filter {
            $0.date.yearMonthDay == day.yearMonthDay
          }
          return foundDate.first?.exercises.count ?? 0
        }
        assert(counts.count == 7)
        // remap values to 0 to maxBarHeight
        let maxValue = max(counts.max() ?? 0, 1)
        countsForWeek = counts.map {
          $0 * maxBarHeight / maxValue
        }
      }
      .frame(height: geometry.size.height * 0.7)
    }
  }

  func bar(day: Int, size: CGSize) -> AnyView {
    guard days.count > day else {
      return AnyView(EmptyView())
    }
    print(day, days)
    let date = days[day]
    let view = VStack {
      Spacer()
      ZStack {
        if countsForWeek[day] > 0 {
        RoundedRectangle(cornerRadius: 10)
          .padding(3)
          .foregroundColor(Color("background"))
          .shadow(
            color: Color("drop-highlight"),
            radius: 4,
            x: -4,
            y: -4)
          .shadow(
            color: Color("drop-shadow"),
            radius: 4,
            x: 4,
            y: 4)
        RoundedRectangle(cornerRadius: 6)
          .padding(12)
          .foregroundColor(Color("history-bar"))
        }
      }
      .frame(height: CGFloat(countsForWeek[day]))
        Text(date.truncatedDayName)
        Text(date.truncatedDayMonth)
    }
    .frame(width: size.width / 9)
    .font(.caption)
    .foregroundColor(Color.primary)
    return AnyView(view)
  }
}

struct HistoryBarView_Previews: PreviewProvider {
  static var previews: some View {
    HistoryBarView(history: HistoryStore(debugData: true))
      .previewDevice("iPhone 12 Pro Max")

  }
}
