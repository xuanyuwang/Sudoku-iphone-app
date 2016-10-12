

import Foundation

/// Holds a Sudoku grid and many useful operations for that grid
public struct Sudoku {
	var grid = [[UInt8]](count: 9, repeatedValue:[UInt8](count: 9, repeatedValue:0))
}


// Permutations to a board
extension Sudoku{
	/// Jumbles the puzzle clues in a random fashion using all separate jumblers
	/// - note: Possible permutations: `9! * 2 * (3 * 3!) * 2 * 3! * 4 * 2 = 1,254,113,280`
	public mutating func jumble(newSeed: Bool = true, seed: UInt32 = UInt32(time(nil))) {
		if newSeed {
			srandom(seed)
		}
		
		jumbleInnerRows()
		jumbleOuterRows()
		jumbleInnerColumns()
		jumbleOuterColumns()
		jumbleNumbers()
		
		rotateClockwise(random() % 4)
		
		if random() % 2 == 1 {
			mirrorHorizontal()
		}
		
		if random() % 2 == 1 {
			mirrorVertical()
		}
	}
	
	/// Performs a caesar cipher swap of numbers
	/// - note: Possible permutations: `9!`
	public mutating func jumbleNumbers() {
		var cipher = createCipher(9)
		cipher.insert(0, atIndex: 0)
		
		var newGrid = [[UInt8]]()
		
		for row in grid {
			var newRow = [UInt8]()
			for entry in row {
				newRow.append(UInt8((entry > 0) ? cipher[Int(entry)] + 1 : 0))
			}
			newGrid.append(newRow)
		}
		
		grid = newGrid
	}
	
	/// Jumbles the rows among the each group of 3 rows
	/// - note: Possible permutations: `3 * 3!`
	public mutating func jumbleInnerRows() {
		let cipher1 = createCipher(3)
		let cipher2 = createCipher(3)
		let cipher3 = createCipher(3)
		
		var newGrid = [[UInt8]](count: 9, repeatedValue: [UInt8]())
		
		for index in 0...2 {
			newGrid[index + 0] = grid[cipher1[index] + 0]
			newGrid[index + 3] = grid[cipher2[index] + 3]
			newGrid[index + 6] = grid[cipher3[index] + 6]
		}
		
		grid = newGrid
	}
	
	/// Jumbles the columns among the each group of 3 columns
	/// - note: Possible permutations: `3 * 3!`
	public mutating func jumbleInnerColumns() {
		let cipher1 = createCipher(3)
		let cipher2 = createCipher(3)
		let cipher3 = createCipher(3)
		
		var newGrid = [[UInt8]]()
		
		for row in grid {
			var newRow = [UInt8](count: 9, repeatedValue: 0)
			
			for index in 0...2 {
				newRow[index + 0] = row[cipher1[index] + 0]
				newRow[index + 3] = row[cipher2[index] + 3]
				newRow[index + 6] = row[cipher3[index] + 6]
			}
			
			newGrid.append(newRow)
		}
		
		grid = newGrid
	}
	
	/// Jumbles the 3 groups of 3 rows amongst themselves
	/// - note: Possible permutations: `3!`
	public mutating func jumbleOuterRows() {
		let cipher = createCipher(3)
		
		var newGrid = [[UInt8]](count: 9, repeatedValue: [UInt8]())
		
		for index in 0...2 {
			newGrid[3 * index + 0] = grid[3 * cipher[index] + 0]
			newGrid[3 * index + 1] = grid[3 * cipher[index] + 1]
			newGrid[3 * index + 2] = grid[3 * cipher[index] + 2]
		}
		
		grid = newGrid
	}
	
	/// Jumbles the 3 groups of 3 columns amongst themselves
	/// - note: Possible permutations: `3!`
	public mutating func jumbleOuterColumns() {
		let cipher = createCipher(3)
		
		var newGrid = [[UInt8]]()
		
		for row in grid {
			var newRow = [UInt8](count: 9, repeatedValue: 0)
			
			for index in 0...2 {
				newRow[3 * index + 0] = row[3 * cipher[index] + 0]
				newRow[3 * index + 1] = row[3 * cipher[index] + 1]
				newRow[3 * index + 2] = row[3 * cipher[index] + 2]
			}
			
			newGrid.append(newRow)
		}
		
		grid = newGrid
	}
	
	/// Rotates the values of the grid clockwise a specified number of steps
	/// - note: Possible permutations: `4`
	public mutating func rotateClockwise(rotations: Int = 1) {
		let xRotations = [{(y: Int, x: Int) in x}, {(y: Int, x: Int) in y}, {(y: Int, x: Int) in 8 - x}, {(y: Int, x: Int) in 8 - y}]
		let yRotations = [{(y: Int, x: Int) in y}, {(y: Int, x: Int) in 8 - x}, {(y: Int, x: Int) in 8 - y}, {(y: Int, x: Int) in x}]
		
		let mutX = xRotations[rotations % 4]
		let mutY = yRotations[rotations % 4]
		
		var newGrid = [[UInt8]](count: 9, repeatedValue:[UInt8](count: 9, repeatedValue:0))
		
		for y in 0...8 {
			for x in 0...8 {
				newGrid[y][x] = grid[mutY(y,x)][mutX(y,x)]
			}
		}
		
		grid = newGrid
	}
	
	/// Mirrors the values of the grid across the horizontal axis
	/// - note: Possible permutations: `2`
	/// - remark: this is functionally equivalent to the other mirror function with an additional rotation
	public mutating func mirrorHorizontal() {
		var newGrid = [[UInt8]](count: 9, repeatedValue:[UInt8](count: 9, repeatedValue:0))
		
		for y in 0...8 {
			for x in 0...8 {
				newGrid[y][x] = grid[y][8 - x]
			}
		}
		
		grid = newGrid
	}
	
	/// Mirrors the values of the grid across the vertical axis
	/// - note: Possible permutations: `2`
	/// - remark: this is functionally equivalent to the other mirror function with an additional rotation
	public mutating func mirrorVertical() {
		var newGrid = [[UInt8]](count: 9, repeatedValue:[UInt8](count: 9, repeatedValue:0))
		
		for y in 0...8 {
			for x in 0...8 {
				newGrid[y][x] = grid[8 - y][x]
			}
		}
		
		grid = newGrid
	}
}


// For checking the unique solution of the puzzle
extension Sudoku {
	/// - returns: Number of unique solutions in the current puzzle configuration
	public func solveDFS(startIndex: Int = 0) -> Int {
		var solutions = 0, index = startIndex
		var moves = Set<UInt8>()
		var coords = (0, 0)
		var completed = true
		
		// Search for the first empty cell after the starting index
		while index < (9*9) && completed {
			if grid[index/9][index%9] == 0 {
				completed = false
				coords = (index/9, index%9)
				moves = getValidMovesFor(coords)
				break
			}
			index = index + 1
		}
		
		// We have found a configuration that is a solution
		if completed {
			return 1
		}
		
		// We have found a configuration with no reachable solution
		if moves.isEmpty {
			return 0
		}
		
		// Copy the current grid to make an addition
		var newGrid = grid
		
		// Check each possible move in this empty position recursively
		for move in moves {
			newGrid[coords.0][coords.1] = move
			let guess = Sudoku(grid: newGrid)
			
			solutions += guess.solveDFS(index + 1)
		}
		
		return solutions
	}
}


// For checking properties of a configuration
extension Sudoku {
	/// - returns: `True` if the puzzle configuration does not violate any Sudoku rules
	public var checkValidity: Bool {
		// Check the rows
		for index in 0...8 {
			let row = grid[index]
			
			if checkGroup(row) {
				return false
			}
		}
		
		// Check the columns
		for index in 0...8 {
			let col = grid.map({$0[index]})
			
			if checkGroup(col) {
				return false
			}
		}
		
		// Check the clusters
		for y in 0...2 {
			for x in 0...2 {
				let cluster = getCluster(x, y)
				
				if checkGroup(cluster) {
					return false
				}
			}
		}
		
		return true
	}
	
	/// - returns: number of open cells remaining in the puzzle
	public var liberties: Int {
		var count = 0
		
		for row in grid {
			for value in row where value == 0 {
				count = count + 1
			}
		}
		
		return count
	}
	
	/// - returns: number of given cells in the puzzle
	public var givens: Int {
		var count = 0
		
		for row in grid {
			for value in row where value > 0 {
				count = count + 1
			}
		}
		
		return count
	}
	
	/// - returns: the difficulty of the given puzzle
	public var difficulty: Double {
		let L = Double(liberties)
		let D_l = (L / 64.0) * (L / 64.0)
		
		// T is the time it takes to find the unique solutions, with a timeout of 4 seconds
		// let D_t = max((sqrt(T) / 2.0), 1.0)
		
		// I would multiply D_l and D_t and return that nunmber as the difficulty value.
		
		return D_l
	}
	
	/// - returns: the coordinates of the nth liberty
	public func libertyCoords(lookup: Int) -> (Int, Int) {
		var count = 0
		
		for index in 0..<(9*9) where grid[index/9][index%9] == 0 {
			if count == lookup {
				return (index/9, index%9)
			}
			count = count + 1
		}
		
		return (-1, -1)
	}
}


// For printing the puzzle
//extension Sudoku : CustomStringConvertible {
//	public var description : String {
//		var descriptor = ""
//		
//		for row in 0...8 {
//			if row % 3 == 0 && row > 0 {
//				descriptor += "\n"
//			}
//			
//			for col in 0...8 {
//				if col % 3 == 0 && col > 0 {
//					descriptor += " "
//				}
//				
//				let value = grid[row][col]
//				
//				descriptor += (value > 0) ? String(value) : "-"
//				
//				if col < 8 {
//					descriptor += " "
//				}
//			}
//			
//			if row < 8 {
//				descriptor += "\n"
//			}
//		}
//		
//		return descriptor
//	}
//}


// Private functions
extension Sudoku {
	/// - returns: A caesar cipher of requested size
	private func createCipher(size: Int) -> [Int] {
		var cipher = [Int](count: size, repeatedValue: 0)
		
		for range in (0..<size).reverse() {
			var index = 0, position = random() % (range + 1)
			
			while index <= position {
				if cipher[index] > 0 {
					position = position + 1
				}
				
				index = index + 1
			}
			
			cipher[position] = range
		}
		
		return cipher
	}
	
	/// - parameters:
	///   - Int: row of the 3x3 desired cluster
	///   - Int: column of the 3x3 desired cluster
	/// - returns: The group of values in the specified Cluster
	@warn_unused_result
	private func getCluster(x: Int, _ y: Int) -> [UInt8] {
		var cluster = [UInt8]()
		
		cluster.append(grid[3*x+0][3*y+0])
		cluster.append(grid[3*x+1][3*y+0])
		cluster.append(grid[3*x+2][3*y+0])
		cluster.append(grid[3*x+0][3*y+1])
		cluster.append(grid[3*x+1][3*y+1])
		cluster.append(grid[3*x+2][3*y+1])
		cluster.append(grid[3*x+0][3*y+2])
		cluster.append(grid[3*x+1][3*y+2])
		cluster.append(grid[3*x+2][3*y+2])
		
		return cluster
	}
	
	/// - returns: An array of all valid values for a given empty space in the grid
	/// - note: this func assumes there are no duplicates
	@warn_unused_result
	public func getValidMovesFor(position: (row: Int, col: Int)) -> Set<UInt8> {
		func getValidMovesForGroup(group: [UInt8]) -> Set<UInt8> {
			var valid: Set<UInt8> = [1,2,3,4,5,6,7,8,9]
			
			for value in group where value > 0 {
				valid.remove(value)
			}
			
			return valid
		}
		
		let rowValid = getValidMovesForGroup(grid[position.row])
		let colValid = getValidMovesForGroup(grid.map({$0[position.col]}))
		let clusterValid = getValidMovesForGroup(getCluster(position.row / 3, position.col / 3))
		
		return rowValid.intersect(colValid.intersect(clusterValid))
	}
	
	/// Helper function to check collections for non-zero duplicate values
	private func checkGroup(group: [UInt8]) -> Bool {
		var seen = [Bool](count: 9, repeatedValue: false)
		
		for value in group where value > 0 {
			let index = Int(value - 1)
			
			if seen[index] {
				return true
			}
			
			seen[index] = true
		}
		
		return false
	}
}
