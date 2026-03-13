//
//  ViewState.swift
//  NewsFeed
//
//  Created by  Prince Shrivastav on 13/03/26.
//

import Foundation

enum ViewState<T> {
    case idle
    case loading
    case success(T)
    case empty
    case failure(NetworkError)
}
