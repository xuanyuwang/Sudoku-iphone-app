//
//  DataModel.swift
//  Grid
//
//  Created by xjiang on 2016-09-29.
//  Copyright © 2016 xjiang. All rights reserved.
//

import Foundation

struct cell{
    var value: Int = -1
    var display: Bool = false
    var isClue: Bool = false
}

class DataModel {
    
    var numOfEmptyCell = 81
    var cells: [[cell]] = []
    var level: Double = 0.5
    
    init(numItemsPerRow: Int, initialization: Int) {
        cells = Array(count: numItemsPerRow, repeatedValue: Array(count: numItemsPerRow, repeatedValue: cell()))
    }
    
    
    func get_num(row:Int, column:Int) -> Int {
        return cells[row][column].value
    }
    
    func get_display_state(row: Int, column: Int) -> Bool{
        return cells[row][column].display
    }
    
    func set_num(row:Int, column:Int, value:Int) {
        cells[row][column].value = value
    }
    
    func set_display_state(row:Int, column:Int, value:Bool) {
        cells[row][column].display = value
    }
    
    func getPuzzle() {
        //initialize grids
        for i in cells.indices {
            for j in cells.indices {
                cells[i][j].value = Int(-1)
                cells[i][j].display = false
                cells[i][j].isClue = false
            }
        }
        
        //generate
        let gen = Generator()
        
        // set the difficulty of our puzzle; needs to be in the range (0.0, 1.0) with lower being easier
        let difficulty = level
        
        // generate a puzzle...
        let puzzle = gen.generate(difficulty, verbose: true)
        for i in cells.indices {
            for j in cells.indices {
                if  puzzle.grid[i][j] != 0{
                    cells[i][j].value = Int(puzzle.grid[i][j])
                    cells[i][j].display = true
                    cells[i][j].isClue = true
                }
            }
        }
        
        //generateSudokuPuzzle(&cells, x: 0, y: 0)
        //selectClues(&cells)
    }
    
    func selectClues(inout cells: [[cell]]) {
        for _ in 0...50 {
            let xValue: Int = Int(arc4random() % 9)
            let yValue: Int = Int(arc4random() % 9)
            cells[xValue][yValue].isClue = true
            cells[xValue][yValue].display = true
        }
    }
    
    //Generate a valid board
    func generateSudokuPuzzle(inout cells: [[cell]], x: Int, y: Int) -> Int {
        var stateOfNums = Array(count: 9, repeatedValue: 1)
        let used: Int = 0
        //////////////////////////////////////////////////////////////////////////
        //In this setion, find which number has been used in the corresponding
        //row, column, and block, and mark it as "used"
        if (y-1) >= 0 {
            for i in 0...(y-1) {
                stateOfNums[cells[x][i].value - 1] = used
            }
        }
        
        if (x - 1) >= 0 {
            for i in 0...(x-1) {
                stateOfNums[cells[i][y].value - 1] = used
            }
        }
        
        for i in (3*(x/3))...(3*(x/3)+3 - 1) {
            if (y - 1) >= (3*(y/3)) {
                for j in (3*(y/3))...(y-1) {
                    stateOfNums[cells[i][j].value - 1] = used
                }
            }
        }
        
        //Find out the number of valid numbers
        var numOfValidNums: Int = 0;
        for i in 0...8 {
            numOfValidNums += stateOfNums[i]
        }
        
        var numsToAssign = Array(count: numOfValidNums, repeatedValue: 0)
        
        var j: Int = 0
        for i in 0...8 {
            if stateOfNums[i] == 1 {
                numsToAssign[j] = i + 1
                j += 1
            }
        }
        
        //Coordinates of the next cell which we will assign number to it
        var ny: Int, nx: Int
        
        if x == 8 {
            ny = y + 1
            nx = 0
        }
        else{
            ny = y
            nx = x + 1
        }
        
        while numOfValidNums > 0 {
            let index: Int = Int(arc4random() % UInt32(numOfValidNums))
            cells[x][y].value = numsToAssign[index]
            numsToAssign[index] = numsToAssign[numOfValidNums - 1]
            numOfValidNums -= 1
            
            if x == 8 && y == 8 {
                return 1
            }
            
            if (generateSudokuPuzzle(&cells, x: nx, y: ny)) == 1 {
                return 1
            }
        }
        return 0
    }

    func isValidNum(row: Int, column: Int) -> Bool {
        //figure if the current value has been used in the same column
        for i in 0...8 {
            if i != column &&
                cells[row][i].display &&
                cells[row][column].value == cells[row][i].value {
                return false
            }
        }
        
        //figure if the current value has been used in the same row
        for i in 0...8 {
            if i != row &&
                cells[i][column].display &&
                cells[row][column].value == cells[i][column].value {
                return false
            }
        }
        //figure if the current value has been used in the same block
        for i in (3*(row/3))...(3*(row/3)+3 - 1) {
            for j in (3*(column/3))...(3*(column/3)+3 - 1) {
                if (i != row && j != column) &&
                    cells[i][j].display &&
                    cells[row][column].value == cells[i][j].value {
                    return false
                }
            }
        }
        return true
    }
}