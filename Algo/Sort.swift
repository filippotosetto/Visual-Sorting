//
//  quickSort.swift
//  Algo
//
//  Created by Filippo Tosetto on 17/03/2015.
//  Copyright (c) 2015 Conjure. All rights reserved.
//

import Foundation

typealias Swap = (Int, Int)
typealias Swaps = [Swap]

func execute(functionName: SortFunctionType, data: [Int]) -> Swaps {
    
    var swaps = Swaps()
    
    switch functionName {
    case .QuickSort:
        swaps = sortData(QuickSort(data: data, swaps: swaps))
    case .InsertionSort:
        swaps = sortData(InsertionSort(data: data, swaps: swaps))
    case .HeapSort:
        swaps = sortData(HeapSort(data: data, swaps: swaps))
    case .MergeSort:
        swaps = sortData(MergeSort(data: data, swaps: swaps))
    }
    
    return swaps
}

func sortData<S: SortProtocol where S.DataType == Int>(var sortProtocol: S) -> Swaps {
    sortProtocol.sortData()
    return sortProtocol.swaps
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
    var swaps: Swaps { get set }
    
    mutating func sortData()
}


// MARK:
// MARK: Quick Sort
protocol QuickSortProtocol { }

extension SortProtocol where Self : QuickSortProtocol {

    // http://en.wikipedia.org/wiki/Quicksort
    mutating func sortData() {
        quickSortInPlace(&data, start: 0, end: data.count - 1, swaps: &swaps)
    }
    
    private func quickSortInPlace<T: Comparable>(inout data: [T], start: Int, end: Int, inout swaps: Swaps) {

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
                        swap(&data[left], &data[right])
                    }
                    left += 1
                    right -= 1
                }
            }
            
            quickSortInPlace(&data, start: start, end: right, swaps: &swaps)
            quickSortInPlace(&data, start: left, end: end, swaps: &swaps)
        }
    }
}

struct QuickSort : SortProtocol, QuickSortProtocol {
    var data: [Int]
    var swaps: Swaps
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
                    swaps += [(j, j-1)]
                    
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
    var swaps: Swaps
}


//MARK:
//MARK: Heap Sort
protocol HeapSortProtocol {}

extension SortProtocol where Self : HeapSortProtocol {
    
    // REF: http://en.wikipedia.org/wiki/Heapsort
    
    mutating func sortData() {

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
    private func heapify<T: Comparable>(inout data: [T], count: Int, inout swaps: Swaps){
        
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
    private func siftDown<T: Comparable>(inout data: [T], start: Int, end: Int, inout swaps: Swaps){
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

}

struct HeapSort : SortProtocol, HeapSortProtocol {
    var data: [Int]
    var swaps: Swaps
}



// MARK:
// MARK: Merge Sort
protocol MergeSortProtocol { }

extension SortProtocol where Self : MergeSortProtocol {

    // REF: http://en.wikipedia.org/wiki/In-place_algorithm
    mutating func sortData() {
        mergeSort(&data, low: 0, high: data.count-1, swaps: &swaps)
    }

    func mergeSort<T: Comparable>(inout data: [T], low: Int, high: Int, inout swaps: Swaps){

        if (low < high) {
            // find the midpoint of the current subarray
            let midle = (low + high)/2
            
            // sort the first half
            mergeSort(&data, low: low, high: midle, swaps: &swaps)
            
            // sort the second half
            mergeSort(&data, low: midle+1,high: high, swaps: &swaps)
            
            // merge the halves
            merge(&data,low: low, high: high, swaps: &swaps)
        }
    }

    private func merge<T: Comparable>(inout data: [T], low: Int, high: Int, inout swaps: Swaps) {
        
        var temp = data
        
        let mid = (low + high) / 2
        var index1 = 0
        var index2 = low
        var index3 = mid + 1
        
        while (index2 <= mid && index3 <= high) {
            if (data[index2] < data[index3]) {
                temp[index1] = data[index2]
                index1++
                index2++
                
                if index1 != index2 && index1 < data.count && index2 < data.count {
                    swaps += [(index1, index2)]
                }
            } else {
                temp[index1] = data[index3]
                index1++
                index3++
                
                if index1 != index3 && index1 < data.count && index3 < data.count {
                    swaps += [(index1, index3)]
                }
            }
        }
                
        while (index2 <= mid) {
            temp[index1] = data[index2]
            index1++
            index2++
            
            if index1 != index2 && index1 < data.count && index2 < data.count {
                swaps += [(index1, index2)]
            }
        }
        
        while (index3 <= high) {
            temp[index1] = data[index3]
            index1++
            index3++
            
            if index1 != index3 && index1 < data.count && index3 < data.count {
                swaps += [(index1, index3)]
            }
        }
        
        for (var i = low, j = 0; i <= high; i++, j++) {
            data[i] = temp[j]
            
            if i != j {
//                swaps += [(i, j)]
            }
        }
        
//        print(swaps)

//        // create a new array; we'll copy this back once it's sorted
//        int[] temp = copy(list);
//        
//        // Set the midpoint and the end points for each of the subarrays
//        int mid = (low + high)/2;
//        int index1 = 0;
//        int index2 = low;
//        int index3 = mid + 1;
//        
//        // Go through the two subarrays and compare, item by item,
//        // placing the items in the proper order in the new array
//        while (index2 <= mid && index3 <= high) {
//            compCount++;
//            if (list[index2] < list[index3]) {
//                swapCount++;
//                temp[index1] = list[index2];
//                index1++;
//                index2++;
//                //print(temp);
//            } else {
//                temp[index1] = list[index3];
//                swapCount++;
//                index1++;
//                index3++;
//                //	print(temp);
//            }
//        }
//        
//        // if there are any items left over in the first subarray, add them to
//        // the new array
//        while (index2 <= mid) {
//            temp[index1] = list[index2];
//            swapCount++;
//            index1++;
//            index2++;
//            //print(temp);
//        }
//        
//        // if there are any items left over in the second subarray, add them
//        // to the new array
//        while (index3 <= high) {
//            temp[index1] = list[index3];
//            swapCount++;
//            index1++;
//            index3++;
//            //print(temp);
//        }
//        
//        // load temp array's contents back into original array
//        for (int i=low, j=0; i<=high; i++, j++) {
//            list[i] = temp[j];
//            swapCount++;
//        }
    }
}


struct MergeSort : SortProtocol, MergeSortProtocol {
    var data: [Int]
    var swaps: Swaps
}


