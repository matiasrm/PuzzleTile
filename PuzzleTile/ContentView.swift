//
//  ContentView.swift
//  PuzzleTile
//
//  Created by Mati Montenegro on 01/03/24.
//

import SwiftUI
import Combine
import UniformTypeIdentifiers

struct ContentView: View {
    @ObservedObject var viewModel: PuzzleViewModel
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(Array(viewModel.puzzle.tiles.enumerated()), id: \.element.id) { index, tile in
                        Image(uiImage: tile.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                            .onDrag {
                                let dragInfo = "\(tile.id)|\(index)"
                                return NSItemProvider(object: dragInfo as NSString)
                            }
                            .onDrop(of: [UTType.plainText.identifier], isTargeted: nil) { providers, _ in
                                providers.first?.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { (data, error) in
                                    guard let itemData = data as? Data, let dragInfoString = String(data: itemData, encoding: .utf8) else {
                                        return
                                    }
                                    let components = dragInfoString.split(separator: "|")
                                    guard components.count == 2, let draggedId = Int(components[0]), let sourceIndex = Int(components[1]) else {
                                        return
                                    }
                                    
                                    DispatchQueue.main.async {
                                        let destinationIndex = (sourceIndex + 1) % self.viewModel.puzzle.tiles.count
                                        
                                        self.viewModel.swapTiles(at: sourceIndex, with: destinationIndex)
                                        
                                    }
                                }
                                return true
                            }
                    }
                }
                .padding()
            }
        }
    }
    struct DropViewDelegate: DropDelegate {
        let sourceIndex: Int
        var viewModel: PuzzleViewModel
        
        func performDrop(info: DropInfo) -> Bool {
            let destinationIndex: Int = calculateDestinationIndex(from: info)
            
            viewModel.swapTiles(at: sourceIndex, with: destinationIndex)
            
            return true
        }
        
        private func calculateDestinationIndex(from dropInfo: DropInfo) -> Int {
            let location = CGPoint(x: dropInfo.location.x, y: dropInfo.location.y)
            
            let tileWidth: CGFloat = 100
            let spacing: CGFloat = 2
            
            let column = Int(location.x / (tileWidth + spacing))
            let row = Int(location.y / (tileWidth + spacing))
            
            let index = row * 3 + column
            print("Drop location: \(location), column: \(column), row: \(row), index: \(index)")
            return max(0, min(index, viewModel.puzzle.tiles.count - 1))
        }
    }
}

