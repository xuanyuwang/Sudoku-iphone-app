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
    var buttonNumber: Int = 0
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
        
        var row, column : Int
        (row, column) = getlocation(indexPath)

        
        cell.label.text = String(data.get_num(row, column: column))
        
        return cell
    }
    
    
    // specify cell size
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let paddingSpace = Int(sectionInsets.left) * itemsPerRow * 2
        let availableWidth = view.frame.width - CGFloat(paddingSpace)
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    @IBAction func sendValue5(sender: UIButton, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //buttonNumber = 5
        data.set_num(row_out, column: column_out, value: 5) // update model
        collectionView.reloadData() // update view
    }
    
    // selection behaviour
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // You can use indexPath to get "cell number x", or get the cell like:
        //let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SudokuCollectionViewCell
        
        var row, column : Int
        (row, column) = getlocation(indexPath)
        
        row_out = row
        column_out = column
        
        //data.set_num(row, column: column, value: buttonNumber) // update model
        
        
        //collectionView.reloadData() // update view
    }
    
    func getlocation(indexPath: NSIndexPath) -> (row: Int, column: Int) {
        let row: Int = indexPath.row / itemsPerRow
        let column: Int = indexPath.row % itemsPerRow
        return (row, column)
    }


}

