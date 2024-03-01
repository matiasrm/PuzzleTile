//
//  PuzzleTileApp.swift
//  PuzzleTile
//
//  Created by Mati Montenegro on 01/03/24.
//

import SwiftUI
import Combine

@main
struct PuzzleTileApp: App {
    var viewModel: PuzzleViewModel
    
    init() {
        let tiles = [PuzzleTile]()
        let puzzle = Puzzle(tiles: tiles)
        viewModel = PuzzleViewModel(puzzle: puzzle)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
