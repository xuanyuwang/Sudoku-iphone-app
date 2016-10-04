//
//  DataModel.swift
//  Grid
//
//  Created by xjiang on 2016-09-29.
//  Copyright © 2016 xjiang. All rights reserved.
//

import Foundation

class DataModel {
    var nums: [[Int]] = []
    
    init(numItemsPerRow: Int, initialization: Int) {
        nums = Array(count: numItemsPerRow, repeatedValue: Array(count: numItemsPerRow, repeatedValue: initialization))
        
        // populate grid with random numbers
        for i in nums.indices {
            for j in nums.indices {
                nums[i][j] = Int(arc4random() % 10)
            }
        }
        
        
        
    }
    
    func get_num(row:Int, column:Int) -> Int {
        return nums[row][column]
    }
    
    func set_num(row:Int, column:Int, value:Int) {
        nums[row][column] = value
    }
    

}