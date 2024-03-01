//
//  Model.swift
//  PuzzleTile
//
//  Created by Mati Montenegro on 01/03/24.
//

import Foundation
import SwiftUI
import Combine

struct Puzzle {
    var tiles: [PuzzleTile]
}

struct PuzzleTile: Identifiable {
    let id: Int
    var image: UIImage
    var correctPosition: Int
    var currentPosition: Int
}
