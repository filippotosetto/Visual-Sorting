//
//  AlgoTests.swift
//  AlgoTests
//
//  Created by Filippo Tosetto on 10/03/2015.
//  Copyright (c) 2015 Conjure. All rights reserved.
//

import UIKit
import XCTest

class AlgoTests: XCTestCase {
    
    var numberOFSwaps = [(Int, Int)]()
    var data = [Int]()
    var dataCopy = [Int]()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testQuickSort() {
        setupArray()

        SortFunction.getSortFunction(SortFunction.QuickSort, data: &data, swaps: &numberOFSwaps)
    
//        dataCopy.sortInPlace(<)
        
        XCTAssertEqual(data, dataCopy, "Pass")
    }
    
    func testHeapSort() {
        setupArray()
        
        SortFunction.getSortFunction(SortFunction.HeapSort, data: &data, swaps: &numberOFSwaps)
        
//        dataCopy.sortInPlace(<)
        
        XCTAssertEqual(data, dataCopy, "Pass")
    }
    
    func testQuickSortExample() {
        
        setupArray()
        
        self.measureBlock() {
            SortFunction.getSortFunction(SortFunction.QuickSort, data: &self.data, swaps: &self.numberOFSwaps)
        }
    }
    
    func testHeapSortExample() {
        
        setupArray()
        
        self.measureBlock() {
            SortFunction.getSortFunction(SortFunction.HeapSort, data: &self.data, swaps: &self.numberOFSwaps)
        }
    }
    
    
    
    func setupArray() {
        data.removeAll(keepCapacity: true)
        dataCopy.removeAll(keepCapacity: true)
        
        for _ in 1...10000 {
            data.append(Int(arc4random() % 99) + 1)
        }
        
        dataCopy = data
    }
    
}
