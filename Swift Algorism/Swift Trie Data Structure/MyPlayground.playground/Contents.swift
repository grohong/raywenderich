//: Playground - noun: a place where people can play

class TrieNode<T: Hashable> {
    var value: T?
    weak var parent: TrieNode?
    var children: [T: TrieNode] = [:]
    var isTerminating = false

    
    init(value: T? = nil, parent: TrieNode? = nil) {
        self.value = value
        self.parent = parent
    }
    
    func add(child: T) {
        guard children[child] == nil else { return }
        
        children[child] = TrieNode(value: child, parent: self)
    }
}

class Trie {
    typealias Node = TrieNode<Character>
    fileprivate let root: Node
    
    init() {
        root = Node()
    }
}

extension Trie {
    func insert(word: String) {
        guard !word.isEmpty else { return }
        
        var currentNode = root
        
        let characters = Array(word.lowercased().characters)
        var currentIndex = 0
        
        while currentIndex < characters.count {
            let character = characters[currentIndex]
            
            if let child = currentNode.children[character] {
                currentNode = child
            } else {
                currentNode.add(child: character)
                currentNode = currentNode.children[character]!
            }
            
            if currentIndex == characters.count-1 {
                currentNode.isTerminating = true
            }
            
            currentIndex += 1
        }
    }
    
    func contains(word: String) -> Bool {
        guard !word.isEmpty else { return false }
        var currentNode = root
        
        let characters = Array(word.lowercased().characters)
        var currentIndex = 0
        
        while currentIndex < characters.count, let child = currentNode.children[characters[currentIndex]] {
            currentIndex += 1
            currentNode = child
        }
        
        if currentIndex == characters.count && currentNode.isTerminating {
            return true
        } else {
            return false
        }
    }
}



let trie = Trie()

trie.insert(word: "cute")
trie.contains(word: "cute")

trie.contains(word: "cut")
trie.insert(word: "cut")
trie.contains(word: "cut")
