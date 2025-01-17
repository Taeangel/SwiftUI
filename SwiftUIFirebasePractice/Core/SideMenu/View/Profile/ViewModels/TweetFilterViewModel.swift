//
//  TweetFilterViewModel.swift
//  SwiftUIFirebasePractice
//
//  Created by song on 2023/01/25.
//

import Foundation

enum TweetFilterViewModel: Int, CaseIterable {
  case tweets
  case replies
  case likes
  
  var  title: String {
    switch self {
    case .tweets:
      return "Tweets"
    case .replies:
      return "Replies"
    case .likes:
      return "LIkes"
    }
  }
}
