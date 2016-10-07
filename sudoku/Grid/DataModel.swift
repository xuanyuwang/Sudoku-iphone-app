//
//  DataModel.swift
//  Grid
//
//  Created by xjiang on 2016-09-29.
//  Copyright © 2016 xjiang. All rights reserved.
//

import Foundation

class DataModel {
    struct cell{
        var value: Int = 0
        var state: Int = 0
    }
    var nums: [[Int]] = []
    var cells: [[cell]] = []
    let display: Int = 1
    
    init(numItemsPerRow: Int, initialization: Int) {
        nums = Array(count: numItemsPerRow, repeatedValue: Array(count: numItemsPerRow, repeatedValue: initialization))
        cells = Array(count: numItemsPerRow, repeatedValue: Array(count: numItemsPerRow, repeatedValue: cell()))
        
        for i in nums.indices {
            for j in nums.indices {
                nums[i][j] = Int(-1)
            }
        }
    }
    
    func assign_num_random(){
        //initialize those cells with -1
        for i in nums.indices {
            for j in nums.indices {
                if nums[i][j] == -1 {
                    nums[i][j] = Int(arc4random() % 10)
                }
            }
        }
    }
    
    func get_num(row:Int, column:Int) -> Int {
        return nums[row][column]
    }
    
    func set_num(row:Int, column:Int, value:Int) {
        nums[row][column] = value
    }
    
    func passValidBoard() {
        for i in nums.indices {
            for j in nums.indices {
                nums[i][j] = Int(-1)
            }
        }
        generateSudokuPuzzle(&cells, x: 0, y: 0)
        hide(&cells)
        for i in nums.indices {
            for j in nums.indices {
                if cells[i][j].state == display {
                    nums[i][j] = cells[i][j].value
                }
            }
        }
    }
    
    func hide(inout cells: [[cell]]) {
        for i in 0...8 {
            for j in 0...8 {
                cells[i][j].state = display
            }
        }
        
        for _ in 0...30 {
            var xvalue: Int = Int(arc4random() % 9)
            var yvalue: Int = Int(arc4random() % 9)
            cells[xvalue][yvalue].state = 0
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
            var index: Int = Int(arc4random() % UInt32(numOfValidNums))
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
}