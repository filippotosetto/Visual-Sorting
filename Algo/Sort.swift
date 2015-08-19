//
//  quickSort.swift
//  Algo
//
//  Created by Filippo Tosetto on 17/03/2015.
//  Copyright (c) 2015 Conjure. All rights reserved.
//

import Foundation

enum SortFunction: String {

    case HeapSort = "Heap Sort"
    case QuickSort = "Quick Sort"
    case InsertionSort = "Insertion Sort"
    
    static func getSortFunction(functionName: SortFunction, inout data: [Int], inout swaps: [(Int, Int)]) -> () {
        switch functionName {
        case .HeapSort:
            return heapSort(&data, swaps: &swaps)
        case .QuickSort:
            return quickSortInPlace(&data, swaps: &swaps)
        case .InsertionSort:
            return insertionSort(&data, swaps: &swaps)
        }
    }
}


// ref: http://en.wikipedia.org/wiki/In-place_algorithm
// MARK: Merge Sort

func mergeSort<T: Comparable>(inout array: [T]){
    if array.count <= 1{
        return
    }
    
    // Split lists into equal sized sublists
    let middle = array.count / 2
    
    var left = [T]()
    var right = [T]()
    
    for x in 0..<middle{
        left.append(array[x])
    }
    
    for y in middle..<array.count{
        right.append(array[y])
    }
    
    // Recursively sort sublists
    mergeSort(&left)
    mergeSort(&right)
    
    // Merge the sorted sublists
    array = merge(&left,right: &right)
}

private func merge<T: Comparable>(inout left: [T], inout right:[T])-> [T]{
    
    var result = [T]()
    
    // Merge taking lowest value first seen
    while (!left.isEmpty && !right.isEmpty){
        if left[0] <= right[0]{
            result.append(left[0])
            left.removeAtIndex(0)
        }else{
            result.append(right[0])
            right.removeAtIndex(0)
        }
    }
    
    // Handle remaining elements
    while !left.isEmpty{
        result.append(left[0])
        left.removeAtIndex(0)
    }
    while !right.isEmpty{
        result.append(right[0])
        right.removeAtIndex(0)
    }
    
    return result
}

// MARK: Quick Sort
// http://en.wikipedia.org/wiki/Quicksort

// Three ways quick sort
func quickSort<T: Comparable>(inout data: [T]){
    if data.count > 1{
        var less = [T]()
        var equal = [T]()
        var greater = [T]()
        
        let pivot = data[1]
        for x in data{
            if x < pivot{
                less.append(x)
            }else if x == pivot{
                equal.append(x)
            }else{
                greater.append(x)
            }
        }
        quickSort(&less)
        quickSort(&greater)
        
        data = less + equal + greater
    }
}

// Quick sort in place
func quickSortInPlace<T: Comparable>(inout data: [T], inout swaps: [(Int, Int)]) {

    quickSortInPlace(&data, start: 0, end: data.count - 1, swaps: &swaps)
}

private func quickSortInPlace<T: Comparable>(inout data: [T], start: Int, end: Int, inout swaps: [(Int, Int)]) {
    
    if start >= end {
        return
    }
    
    if data.count > 1 {
        let pivot = data[(start + end) / 2]
        var left: Int = start
        var right: Int = end
        
        while left <= right {
            while data[left] < pivot {
                left += 1
            }
            while data[right] > pivot {
                right -= 1
            }
            
            if left <= right {
                if left != right {
                    swaps += [(left, right)]
                    swap(&data, from: left, to: right)
                }
                left += 1
                right -= 1
            }
        }
        
        quickSortInPlace(&data, start: start, end: right, swaps: &swaps)
        quickSortInPlace(&data, start: left, end: end, swaps: &swaps)
    }
}

private func swap<T>(inout data: [T], from: Int, to: Int) {
    let tmp = data[from]
    data[from] = data[to]
    data[to] = tmp
}


// MARK: Heap Sort
// Reference: http://en.wikipedia.org/wiki/Heapsort

func heapSort<T: Comparable>(inout data: [T],  inout swaps: [(Int, Int)]){
    
    // build max heap
    heapify(&data, count: data.count, swaps: &swaps)
    
    var end = data.count-1
    
    while end > 0{
        swaps += [(0, end)]
        
        swap(&data[0], &data[end])
        // heap size -1
        end--
        
        // restore heap property
        siftDown(&data,start: 0,end: end, swaps: &swaps)
    }
    
}

// put elements of array in heap order
private func heapify<T: Comparable>(inout data: [T], count: Int, inout swaps: [(Int, Int)]){
    
    // start is assigned the index in 'a' of the last parent node
    // the last element in a 0-based array is at index count-1
    // find parent of last element
    var start = Int(floor(Double(count-2)/2))
    
    while start >= 0{
        // sift down the node at index 'start' to the proper place such that all nodes below the start index are in heap order
        siftDown(&data, start: start, end: count-1, swaps: &swaps)
        // Go to next partent node
        start--
    }
}

// Repair the heap whose root element is at index 'start', assuming the heaps rooted at its children are valid
private func siftDown<T: Comparable>(inout data: [T], start: Int, end: Int, inout swaps: [(Int, Int)]){
    var root = start
    
    // While root has at least one child
    while (root * 2 + 1) <= end{
        let child = root * 2 + 1 // Left child
        var swapChild = root     // Child to swap with
        
        if data[swapChild] < data[child]{
            swapChild = child
        }
        
        // If right child exists and is greater
        if child+1 <= end && data[swapChild] < data[child+1]{
            swapChild = child+1
        }
        
        if swapChild == root{
            // Root holds the largest element, assume the heaps rooted children are valid
            // We are done
            return
        } else{
            swaps += [(root, swapChild)]
            
            swap(&data[root],&data[swapChild])
            root = swapChild // repeat to cont. sifting down the child
        }
        
    }
}


// MARK Insertion Sort
// REF: http://en.wikipedia.org/wiki/Insertion_sort

public func insertionSort<T: Comparable>(inout data: [T], inout swaps: [(Int, Int)]) {
    if data.count > 1 {
        for i in 1..<data.count {
            let x = data[i]
            var j = i
            while j > 0 && data[j-1] > x {
                swaps += [(j, j-1)]
                
                data[j] = data[j-1]
                j--
            }
            data[j] = x
        }
    }
}


