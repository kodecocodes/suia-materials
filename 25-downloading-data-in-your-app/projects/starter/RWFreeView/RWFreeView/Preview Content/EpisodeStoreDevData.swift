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

import Foundation

extension EpisodeStore {
  func createDevData() {
    // Development data
    // swiftlint:disable line_length
    episodes = [
      Episode(
        name: "SwiftUI vs. UIKit",
        description: "Learn about the differences between SwiftUI and UIKit, and whether you should learn SwiftUI, UIKit, or both.\n",
        released: "Sept 2019",
        domain: "iOS & Swift",
        difficulty: "beginner",
        videoURLString: "https://player.vimeo.com/external/357115704.m3u8?s=19d68c614817e0266d6749271e5432675a45c559&oauth2_token_id=897711146",
        uri: "rw://betamax/videos/3021"),
      Episode(
        name: "Challenge: Making a Programming To-Do List",
        description: "Make a programming to-do list of all the things you'll need to do to build the game. This helps build a good programming practice of gathering requirements first!\n",
        released: "Sept 2019",
        domain: "iOS & Swift",
        difficulty: "beginner",
        videoURLString: "https://player.vimeo.com/external/357115706.m3u8?s=e23cffbec2648d976c11be8ddb1729001f4ea179&oauth2_token_id=897711146",
        uri: "rw://betamax/videos/3022"),
      Episode(
        name: "Introduction",
        description: "Getting started with Android development begins right here. Learn about what you'll be making in this course.\n",
        released: "Mar 2018",
        domain: "Android & Kotlin",
        difficulty: "beginner",
        videoURLString: "https://player.vimeo.com/external/257192338.m3u8?s=c3bcd1dbbfd6897317084fb21987af6b89f81ec5&oauth2_token_id=897711146",
        uri: "rw://betamax/videos/1450")
    ]
  }
}
