//
//  ViewController.swift
//  Grid
//
//  Created by xjiang on 2016-09-27.
//  Copyright © 2016 xjiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private let sectionInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    @IBOutlet weak var collectionView: UICollectionView!
    var data = DataModel(numItemsPerRow: 9, initialization: 1)
    var row_out: Int = 0
    var column_out: Int = 0

    private let itemsPerRow = 9
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        cell.backgroundColor = UIColor.orangeColor()
        
        var row, column : Int
        (row, column) = getlocation(indexPath)

        if data.get_num(row, column: column) == -1 {
            cell.label.text = ""
        }
        else{
            cell.label.text = String(data.get_num(row, column: column))
        }
        
        
        return cell
    }
    
    
    // specify cell size
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let paddingSpace = Int(sectionInsets.left) * itemsPerRow * 2
        let availableWidth = view.frame.width - CGFloat(paddingSpace)
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
////////////////////////////////////////////////////////////////////////////////////
    // selection behaviour
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // You can use indexPath to get "cell number x", or get the cell like:
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SudokuCollectionViewCell
        
        //change the color of the selected cell
        cell.backgroundColor = UIColor.cyanColor()
        
        var row, column : Int
        (row, column) = getlocation(indexPath)
        
        row_out = row
        column_out = column
    }
    
    @IBAction func sendValue1(sender: UIButton) {
        data.set_num(row_out, column: column_out, value: 1) // update model
        collectionView.reloadData() // update view
    }
    
    @IBAction func sendValue2(sender: UIButton) {
        data.set_num(row_out, column: column_out, value: 2) // update model
        collectionView.reloadData() // update view
    }
    
    @IBAction func sendValue3(sender: UIButton) {
        data.set_num(row_out, column: column_out, value: 3) // update model
        collectionView.reloadData() // update view
    }
    
    @IBAction func sendValue4(sender: UIButton) {
        data.set_num(row_out, column: column_out, value: 4) // update model
        collectionView.reloadData() // update view
    }
    
    @IBAction func sendValue5(sender: UIButton) {
        data.set_num(row_out, column: column_out, value: 5) // update model
        collectionView.reloadData() // update view
    }
    
    @IBAction func sendValue6(sender: UIButton) {
        data.set_num(row_out, column: column_out, value: 6) // update model
        collectionView.reloadData() // update view
    }
    
    @IBAction func sendValue7(sender: UIButton) {
        data.set_num(row_out, column: column_out, value: 7) // update model
        collectionView.reloadData() // update view
    }
    
    @IBAction func sendValue8(sender: UIButton) {
        data.set_num(row_out, column: column_out, value: 8) // update model
        collectionView.reloadData() // update view
    }
    
    @IBAction func sendValue9(sender: UIButton) {
        data.set_num(row_out, column: column_out, value: 9) // update model
        collectionView.reloadData() // update view
    }
////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////  fill empty cells  ///////////////////////////////
    @IBAction func fillEmptyCells(sender: UIButton) {
        data.assign_num_random()//fill empty cells
        var each_row = [Int](count: 9, repeatedValue: 0)
        //var each_row_sorted: [Int] = []
        for row_num in data.nums.indices{
            for column_num in data.nums.indices{
                each_row[column_num] = data.get_num(row_num, column: column_num)
            }
            each_row.sortInPlace(<)
            for column_num in data.nums.indices{
                data.set_num(row_num, column: column_num, value: each_row[column_num])
            }
        }
        collectionView.reloadData()//update view
    }
    
////////////////////////////////////////////////////////////////////////////////////
    func getlocation(indexPath: NSIndexPath) -> (row: Int, column: Int) {
        let row: Int = indexPath.row / itemsPerRow
        let column: Int = indexPath.row % itemsPerRow
        return (row, column)
    }


}

