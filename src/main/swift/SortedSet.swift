//
//  SortedSet.swift
//  autosave
//
//  Created by Asia Michelle Serrano on 8/4/25.
//

import Foundation

enum RBColor {
    case red
    case black
}

final class RBNode<Element: Comparable> {
    var element: Element
    var color: RBColor
    var left: RBNode?
    var right: RBNode?
    weak var parent: RBNode?
    
    init(_ element: Element, color: RBColor = .red) {
        self.element = element
        self.color = color
    }
}

final class RedBlackTree<Element: Comparable>: ObservableObject {
    
    @Published private(set) var root: RBNode<Element>?
    
    // MARK: - Public Insert
    func insert(_ element: Element) {
        let newNode = RBNode(element)
        bstInsert(newNode)
        fixInsert(newNode)
        self.root = root
    }
    
    // MARK: - Lookup
    func contains(_ element: Element) -> Bool {
        var node = root
        while let current = node {
            if element < current.element {
                node = current.left
            } else if element > current.element {
                node = current.right
            } else {
                return true
            }
        }
        return false
    }
    
    // MARK: - In-order Traversal
    func inOrderElements() -> [Element] {
        var result: [Element] = []
        
        func traverse(_ node: RBNode<Element>?) {
            guard let node = node else { return }
            traverse(node.left)
            result.append(node.element)
            traverse(node.right)
        }
        
        traverse(root)
        return result
    }
}

private extension RedBlackTree {
    
    func bstInsert(_ node: RBNode<Element>) {
        var y: RBNode<Element>? = nil
        var x = root
        
        while let current = x {
            y = current
            if node.element < current.element {
                x = current.left
            } else if node.element > current.element {
                x = current.right
            } else {
                x = nil
            }
        }
        
        node.parent = y
        if y == nil {
            root = node
        } else if node.element < y!.element {
            y!.left = node
        } else if node.element > y!.element {
            y!.right = node
        }
        
        node.left = nil
        node.right = nil
        node.color = .red
    }
    
    func fixInsert(_ node: RBNode<Element>) {
        var z = node
        
        while z.parent?.color == .red {
            if z.parent === z.parent?.parent?.left {
                let y = z.parent?.parent?.right
                if y?.color == .red {
                    // Case 1
                    z.parent?.color = .black
                    y?.color = .black
                    z.parent?.parent?.color = .red
                    z = z.parent!.parent!
                } else {
                    if z === z.parent?.right {
                        // Case 2
                        z = z.parent!
                        leftRotate(z)
                    }
                    // Case 3
                    z.parent?.color = .black
                    z.parent?.parent?.color = .red
                    if let grandparent = z.parent?.parent {
                        rightRotate(grandparent)
                    }
                }
            } else {
                // Symmetric to above
                let y = z.parent?.parent?.left
                if y?.color == .red {
                    z.parent?.color = .black
                    y?.color = .black
                    z.parent?.parent?.color = .red
                    z = z.parent!.parent!
                } else {
                    if z === z.parent?.left {
                        z = z.parent!
                        rightRotate(z)
                    }
                    z.parent?.color = .black
                    z.parent?.parent?.color = .red
                    if let grandparent = z.parent?.parent {
                        leftRotate(grandparent)
                    }
                }
            }
        }
        root?.color = .black
    }
    
    func leftRotate(_ x: RBNode<Element>) {
        guard let y = x.right else { return }
        x.right = y.left
        if y.left != nil {
            y.left?.parent = x
        }
        y.parent = x.parent
        if x.parent == nil {
            root = y
        } else if x === x.parent?.left {
            x.parent?.left = y
        } else {
            x.parent?.right = y
        }
        y.left = x
        x.parent = y
    }
    
    func rightRotate(_ x: RBNode<Element>) {
        guard let y = x.left else { return }
        x.left = y.right
        if y.right != nil {
            y.right?.parent = x
        }
        y.parent = x.parent
        if x.parent == nil {
            root = y
        } else if x === x.parent?.right {
            x.parent?.right = y
        } else {
            x.parent?.left = y
        }
        y.right = x
        x.parent = y
    }
    
}

// LINE BREAK

public struct SortedSet<Element>: Hashable, RandomAccessCollection, Collection where Element: Hashable & Comparable {
    
    private var set: ElementSet
    private var array: ElementArray
    
    public init() {
        self.set = .init()
        self.array = .init()
    }
    
    public init(_ collection: ElementCollection) {
        self.set = .init(collection)
        self.array = collection.sorted()
    }
    
}

private extension SortedSet {
    
    enum Action: Enumerable {
        case insert, remove
    }
    
    mutating func mutate(_ element: Element, _ action: Action) -> Void {
        switch action {
        case .insert:
            self.set.insert(element)
        case .remove:
            self.set.remove(element)
        }
        self.array = self.set.sorted()
    }
    
}

public extension SortedSet {
    
    typealias ElementCollection = any Collection<Element>
    typealias ElementArray = [Element]
    typealias ElementSet = Set<Element>
    typealias Index = ElementArray.Index
    
    subscript(index: Index) -> Element {
        get { return array[index] }
    }
    
    var startIndex: Index {
        array.startIndex
    }
    
    var endIndex: Index {
        array.endIndex
    }
    
    func index(after i: Index) -> Index {
        array.index(after: i)
    }
    
    mutating func remove(_ index: Index) {
        self.mutate(self[index], .remove)
    }
    
    mutating func remove(_ element: Element) -> Void {
        self.mutate(element, .remove)
    }
    
    mutating func insert(_ element: Element) -> Void {
        self.mutate(element, .insert)
    }
    
}
