//
//  ViewController.swift
//  Grid
//
//  Created by xjiang on 2016-09-27.
//  Copyright © 2016 xjiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private let itemsPerRow = 9
    private let sectionInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    @IBOutlet weak var collectionView: UICollectionView!
    var data = DataModel(numItemsPerRow: 9, initialization: 1)
    var rowOfSelectedCell: Int = -1
    var columnOfSelectedCell: Int = -1
    @IBOutlet weak var bigLabel: UILabel!
    var isOnlySelected: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //give an initial puzzle
        data.getPuzzle()
        collectionView.reloadData()
        bigLabel.text = ""
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // how many items you want to show in its grid
    func collectionView(collectionView: UICollectionView,  numberOfItemsInSection section: Int) -> Int {
        return itemsPerRow*itemsPerRow
    }
    
    // create data
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DataCell", forIndexPath: indexPath) as! SudokuCollectionViewCell
        
        var x, y : Int
        (x, y) = getlocation(indexPath)
        if (x/3 == 0 && y/3 == 1) ||
        (x/3 == 2 && y/3 == 1) ||
        (x/3 == 1 && y/3 == 0) ||
            (x/3 == 1 && y/3 == 2){
            cell.backgroundColor = UIColor(red: 230/255, green: 175/255, blue: 46/255, alpha: 1.0)
        }
        else{
            cell.backgroundColor = UIColor(red: 190/255, green: 183/255, blue: 164/255, alpha: 1.0)
        }
        
        
        var row, column : Int
        (row, column) = getlocation(indexPath)

        if data.get_display_state(row, column: column) {
            cell.label.text = String(data.get_num(row, column: column))
        }
        else{
            cell.label.text = ""
        }
        cell.label.textColor = UIColor(red: 173/255, green: 52/255, blue: 62/255, alpha: 1.0) /* #ffffff */


        return cell
    }
    
    
    // specify cell size
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let paddingSpace = Int(sectionInsets.left) * itemsPerRow * 2
        let availableWidth = view.frame.width - CGFloat(paddingSpace)
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //reset all cells' color

////////////////////////////////////////////////////////////////////////////////////
    // selection behaviour
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        resetCellColor()
        // You can use indexPath to get "cell number x", or get the cell like:
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SudokuCollectionViewCell
        //change the color of the selected cell
        if isOnlySelected {
            cell.backgroundColor = UIColor.whiteColor()
            isOnlySelected = !isOnlySelected
        }else{
            //collectionView.reloadData()
            cell.backgroundColor = UIColor.whiteColor()
            isOnlySelected = !isOnlySelected
        }
        
        var row, column : Int
        (row, column) = getlocation(indexPath)
        
        rowOfSelectedCell = row
        columnOfSelectedCell = column
    }
    
    func resetCellColor() {
        for x in 0...8 {
            for y in 0...8 {
                let index = NSIndexPath.init(forRow: x*itemsPerRow + y, inSection: 0)
                let thisCell = collectionView.cellForItemAtIndexPath(index) as! SudokuCollectionViewCell
                if (x/3 == 0 && y/3 == 1) ||
                    (x/3 == 2 && y/3 == 1) ||
                    (x/3 == 1 && y/3 == 0) ||
                    (x/3 == 1 && y/3 == 2){
                    thisCell.backgroundColor = UIColor(red: 230/255, green: 175/255, blue: 46/255, alpha: 1.0)
                }
                else{
                    thisCell.backgroundColor = UIColor(red: 190/255, green: 183/255, blue: 164/255, alpha: 1.0)
                }
            }
        }
    }
    
    func isToAct(buttonValue: Int) -> Bool{
        if rowOfSelectedCell == -1 && columnOfSelectedCell == -1 {
            return false
        }
        if data.cells[rowOfSelectedCell][columnOfSelectedCell].isClue == true {
            return false
        }
        let temp: Int = data.get_num(rowOfSelectedCell, column: columnOfSelectedCell)
        data.set_num(rowOfSelectedCell, column: columnOfSelectedCell, value: buttonValue)
        if data.isValidNum(rowOfSelectedCell, column: columnOfSelectedCell) == false{
            data.set_num(rowOfSelectedCell, column: columnOfSelectedCell, value: temp)
            return false
        }
        isOnlySelected = false
        return true
    }
    
    //check whether the puzzel is filled up, i.e. no empty cell
    func isFilledUp() -> Bool {
        for i in 0...8 {
            for j in 0...8 {
                if data.cells[i][j].display == false {
                    return false
                }
            }
        }
        return true
    }
    
    func afterAssignValue() {
        data.set_display_state(rowOfSelectedCell, column: columnOfSelectedCell, value: true)
        collectionView.reloadData() // update view
        rowOfSelectedCell = -1
        columnOfSelectedCell = -1
        
        if isFilledUp() {
//            for i in 0...8 {
//                for j in 0...8 {
//                    data.cells[i][j].isClue = true
//                }
//            }
            bigLabel.text = "You Win!"
        }
        isOnlySelected = true
    }
    
    @IBAction func sendValue1(sender: UIButton) {
        if isToAct(1) {
            afterAssignValue()
        }
    }
    
    @IBAction func sendValue2(sender: UIButton) {
        if isToAct(2) {
            afterAssignValue()
        }
    }
    
    @IBAction func sendValue3(sender: UIButton) {
        if isToAct(3) {
            afterAssignValue()
        }
    }
    
    @IBAction func sendValue4(sender: UIButton) {
        if isToAct(4) {
            afterAssignValue()
        }
    }
    
    @IBAction func sendValue5(sender: UIButton) {
        if isToAct(5) {
            afterAssignValue()
        }
    }
    
    @IBAction func sendValue6(sender: UIButton) {
        if isToAct(6) {
            afterAssignValue()
        }
    }
    
    @IBAction func sendValue7(sender: UIButton) {
        if isToAct(7) {
            afterAssignValue()
        }
    }
    
    @IBAction func sendValue8(sender: UIButton) {
        if isToAct(8) {
            afterAssignValue()
        }
    }
    
    @IBAction func sendValue9(sender: UIButton) {
        if isToAct(9) {
            afterAssignValue()
        }
    }
    
////////////////////////////////////////////////////////////////////////////////////
    @IBAction func givePuzzle(sender: UIButton) {
        data.getPuzzle()
        collectionView.reloadData()
    }
////////////////////////////////////////////////////////////////////////////////////
    func getlocation(indexPath: NSIndexPath) -> (row: Int, column: Int) {
        let row: Int = indexPath.row / itemsPerRow
        let column: Int = indexPath.row % itemsPerRow
        return (row, column)
    }


}

