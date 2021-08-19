//
//  main.swift
//  topological
//
//  Created by shunnamiki on 2021/08/18.
//

import Foundation


public final class Queue<E> : Sequence {
    /// beginning of queue
    private var first: Node<E>? = nil
    /// end of queue
    private var last: Node<E>? = nil
    /// size of the queue
    private(set) var count: Int = 0
    
    /// helper linked list node class
    fileprivate class Node<E> {
        fileprivate var item: E
        fileprivate var next: Node<E>?
        fileprivate init(item: E, next: Node<E>? = nil) {
            self.item = item
            self.next = next
        }
    }
    
    /// Initializes an empty queue.
    public init() {}
    
    /// Returns true if this queue is empty.
    public func isEmpty() -> Bool {
        return first == nil
    }
    
    /// Returns the item least recently added to this queue.
    public func peek() -> E? {
        return first?.item
    }
    
    /// Adds the item to this queue
    /// - Parameter item: the item to add
    public func enqueue(item: E) {
        let oldLast = last
        last = Node<E>(item: item)
        if isEmpty() { first = last }
        else { oldLast?.next = last }
        count += 1
    }
    
    /// Removes and returns the item on this queue that was least recently added.
    public func dequeue() -> E? {
        if let item = first?.item {
            first = first?.next
            count -= 1
            // to avoid loitering
            if isEmpty() { last = nil }
            return item
        }
        return nil
    }
    
    /// QueueIterator that iterates over the items in FIFO order.
    public struct QueueIterator<E> : IteratorProtocol {
        private var current: Node<E>?
        
        fileprivate init(_ first: Node<E>?) {
            self.current = first
        }
        
        public mutating func next() -> E? {
            if let item = current?.item {
                current = current?.next
                return item
            }
            return nil
        }
        
        public typealias Element = E
    }
    
    /// Returns an iterator that iterates over the items in this Queue in FIFO order.
    public __consuming func makeIterator() -> QueueIterator<E> {
        return QueueIterator<E>(first)
    }
}

extension Queue: CustomStringConvertible {
    public var description: String {
        return self.reduce(into: "") { $0 += "\($1) " }
    }
}

class Solution {
    func findOrder(_ numCourses: Int, _ prerequisites: [[Int]]) -> [Int] {
        
        //
        var adj = [[Int]](repeating: [], count: numCourses)
        var indegrees = [Int](repeating: 0, count: numCourses)
        var list = [Int]();
        for set in prerequisites {
            let from = set[1]
            let to = set[0]
            adj[from].append(to)
            indegrees[to] += 1
        }
        
        let q = Queue<Int>()
        
        // initial queue
        for i in 0..<indegrees.count {
            if indegrees[i] == 0 {
                q.enqueue(item: i)
            }
        }

        // loop
        while !q.isEmpty() {
            let current = q.dequeue()!
            list.append(current)
            for next in adj[current] {
                indegrees[next] -= 1
                if indegrees[next] == 0 {
                    q.enqueue(item: next)
                }
            }
        }
        
        let canFinish = indegrees.allSatisfy { $0 == 0 }
        
        return canFinish ? list : []
    }
}


let s = Solution()
let r = s.canFinish(4, [[1,0],[2,0],[3,1],[3,2]])
print("RESUT:", r)
