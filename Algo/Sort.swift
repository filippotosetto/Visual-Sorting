//
//  quickSort.swift
//  Algo
//
//  Created by Filippo Tosetto on 17/03/2015.
//  Copyright (c) 2015 Conjure. All rights reserved.
//

import Foundation

typealias Step = (Int, Int)
typealias Steps = [Step]

func execute(functionName: SortFunctionType, data: [Int]) -> Steps {
    
    var steps = Steps()
    
    switch functionName {
    case .QuickSort:
        steps = sortData(QuickSort(data: data, steps: steps))
    case .InsertionSort:
        steps = sortData(InsertionSort(data: data, steps: steps))
    case .HeapSort:
        steps = sortData(HeapSort(data: data, steps: steps))
    case .MergeSort:
        steps = sortData(MergeSort(data: data, steps: steps))
    }
    
    return steps
}

func sortData<S: SortProtocol where S.DataType == Int>(var sortProtocol: S) -> Steps {
    sortProtocol.sortData()
    return sortProtocol.steps
}

enum SortFunctionType: String {
    case HeapSort = "Heap Sort"
    case QuickSort = "Quick Sort"
    case InsertionSort = "Insertion Sort"
    case MergeSort = "Merge Sort"
}



protocol SortProtocol {
    
    typealias DataType: Comparable
    var data: [DataType] { get set }
    var steps: Steps { get set }
    
    mutating func sortData()
}


// MARK:
// MARK: Quick Sort
protocol QuickSortProtocol { }

extension SortProtocol where Self : QuickSortProtocol {

    // http://en.wikipedia.org/wiki/Quicksort
    mutating func sortData() {
        quickSortInPlace(&data, start: 0, end: data.count - 1, steps: &steps)
    }
    
    private func quickSortInPlace<T: Comparable>(inout data: [T], start: Int, end: Int, inout steps: Steps) {

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
                        steps += [(left, right)]
                        swap(&data[left], &data[right])
                    }
                    left += 1
                    right -= 1
                }
            }
            
            quickSortInPlace(&data, start: start, end: right, steps: &steps)
            quickSortInPlace(&data, start: left, end: end, steps: &steps)
        }
    }
}

struct QuickSort : SortProtocol, QuickSortProtocol {
    var data: [Int]
    var steps: Steps
}


// MARK:
// MARK: Insertion Sort
protocol InsertionSortProtocol { }

extension SortProtocol where Self : InsertionSortProtocol {
    
    // REF: http://en.wikipedia.org/wiki/Insertion_sort
    
    mutating func sortData() {
        if data.count > 1 {
            for i in 1..<data.count {
                let x = data[i]
                var j = i
                while j > 0 && data[j-1] > x {
                    steps += [(j, j-1)]
                    
                    data[j] = data[j-1]
                    j--
                }
                data[j] = x
            }
        }
    }
}

struct InsertionSort : SortProtocol, InsertionSortProtocol {
    var data: [Int]
    var steps: Steps
}


//MARK:
//MARK: Heap Sort
protocol HeapSortProtocol {}

extension SortProtocol where Self : HeapSortProtocol {
    
    // REF: http://en.wikipedia.org/wiki/Heapsort
    
    mutating func sortData() {

        // build max heap
        heapify(&data, count: data.count, steps: &steps)
        
        var end = data.count-1
        
        while end > 0{
            steps += [(0, end)]
            
            swap(&data[0], &data[end])
            // heap size -1
            end--
            
            // restore heap property
            siftDown(&data,start: 0,end: end, steps: &steps)
        }
        
    }
    
    // put elements of array in heap order
    private func heapify<T: Comparable>(inout data: [T], count: Int, inout steps: Steps){
        
        // start is assigned the index in 'a' of the last parent node
        // the last element in a 0-based array is at index count-1
        // find parent of last element
        var start = Int(floor(Double(count-2)/2))
        
        while start >= 0{
            // sift down the node at index 'start' to the proper place such that all nodes below the start index are in heap order
            siftDown(&data, start: start, end: count-1, steps: &steps)
            // Go to next partent node
            start--
        }
    }
    
    // Repair the heap whose root element is at index 'start', assuming the heaps rooted at its children are valid
    private func siftDown<T: Comparable>(inout data: [T], start: Int, end: Int, inout steps: Steps){
        var root = start
        
        // While root has at least one child
        while (root * 2 + 1) <= end{
            let child = root * 2 + 1 // Left child
            var stepChild = root     // Child to swap with
            
            if data[stepChild] < data[child]{
                stepChild = child
            }
            
            // If right child exists and is greater
            if child+1 <= end && data[stepChild] < data[child+1]{
                stepChild = child+1
            }
            
            if stepChild == root{
                // Root holds the largest element, assume the heaps rooted children are valid
                // We are done
                return
            } else{
                steps += [(root, stepChild)]
                
                swap(&data[root],&data[stepChild])
                root = stepChild // repeat to cont. sifting down the child
            }
            
        }
    }

}

struct HeapSort : SortProtocol, HeapSortProtocol {
    var data: [Int]
    var steps: Steps
}



// MARK:
// MARK: Merge Sort
protocol MergeSortProtocol { }

extension SortProtocol where Self : MergeSortProtocol {

    // REF: http://en.wikipedia.org/wiki/In-place_algorithm
    mutating func sortData() {
        if data.count > 0 {
            mergeSort(&data, low: 0, high: data.count - 1, steps: &steps)
        }
    }

    func mergeSort<T: Comparable>(inout data: [T], low: Int, high: Int, inout steps: Steps){

        if(high - low == 0){//only one element.
            //no swap
            return
        }
        else if(high - low == 1){//only two elements and swaps them
            if(data[low] >= data[high]) {
                swap(&data[low], &data[high])
                steps += [(low, high)]
                return
            }
        }
        else{
            let midle = (low + high)/2
            
            mergeSort(&data, low: low, high: midle, steps: &steps)//sort the left side
            mergeSort(&data, low: midle+1, high: high, steps: &steps)//sort the right side
            
            merge(&data, low: low, high: high, mid: midle, steps: &steps)//combines them
        }
    }

    private func merge<T: Comparable>(inout data: [T], low: Int, high: Int, mid: Int, inout steps: Steps) {
        var i = low
        while(i <= mid){
            if( data[i] > data[mid+1]){
                swap(&data[i], &data[mid+1])
                steps += [(i, mid+1)]
                push(&data, s: mid+1, e: high, steps: &steps)
            }
            i++;
        }
    }
    
    private func push<T: Comparable>(inout data: [T], s: Int, e: Int, inout steps: Steps){
        for(var i = s; i<e ; i++){
            if(data[i]>data[i+1]) {
                swap(&data[i], &data[i+1])
                steps += [(i, i+1)]
            }
        }
    }
}


struct MergeSort : SortProtocol, MergeSortProtocol {
    var data: [Int]
    var steps: Steps
}


