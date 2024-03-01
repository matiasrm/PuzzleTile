//
//  PuzzleViewModel.swift
//  PuzzleTile
//
//  Created by Mati Montenegro on 01/03/24.
//

import Foundation
import SwiftUI
import Combine

class PuzzleViewModel: ObservableObject {
    @Published var puzzle: Puzzle
    @Published var selectedTileIndex: Int?
    
    init(puzzle: Puzzle) {
        self.puzzle = puzzle
        fetchAndPrepareImage()
    }
    
    func fetchAndPrepareImage() {
        let urlString = "https://picsum.photos/1024"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self?.sliceImageIntoTiles(image)
                } else {
                    if let localImage = UIImage(named: "LocalPuzzleImage") {
                        self?.sliceImageIntoTiles(localImage)
                    }
                }
            }
        }
        task.resume()
    }
    
    private func sliceImageIntoTiles(_ image: UIImage) {
        let tileSize = image.size.width / 3
        var tiles: [PuzzleTile] = []
        
        for row in 0..<3 {
            for column in 0..<3 {
                let x = CGFloat(column) * tileSize
                let y = CGFloat(row) * tileSize
                let rect = CGRect(x: x, y: y, width: tileSize, height: tileSize)
                if let cgCrop = image.cgImage?.cropping(to: rect) {
                    let croppedImage = UIImage(cgImage: cgCrop)
                    let position = row * 3 + column
                    let tile = PuzzleTile(id: position, image: croppedImage, correctPosition: position, currentPosition: position)
                    tiles.append(tile)
                }
            }
        }
        self.puzzle.tiles = tiles.shuffled()
    }
    
    func indexOfTile(withId id: Int) -> Int? {
        return puzzle.tiles.firstIndex(where: { $0.id == id })
    }
    
    func selectTile(at index: Int) {
        if let selectedIndex = selectedTileIndex, selectedIndex != index {
            swapTiles(at: selectedIndex, with: index)
            selectedTileIndex = nil
        } else {
            selectedTileIndex = index
        }
    }
    
    func swapTiles(at firstIndex: Int, with secondIndex: Int) {
        guard firstIndex != secondIndex else { return }
        
        let firstTile = puzzle.tiles[firstIndex]
        puzzle.tiles[firstIndex] = puzzle.tiles[secondIndex]
        puzzle.tiles[secondIndex] = firstTile
        
        objectWillChange.send()
    }
}

