//: Playground - noun: a place where people can play

struct Stack<T> {
    fileprivate var array: [T] = []
    
    mutating func push(_ element: T) {
        array.append(element)
    }
    
    mutating func pop() -> T? {
        return array.popLast()
    }
    
    func peek() -> T? {
        return array.last
    }
}

extension Stack: CustomStringConvertible {
    var description: String {
        
        let topDivider = "---Stack---\n"
        let bottomDivider = "\n----------\n"
        
        let stackElement = array.map {"\($0)"}.reversed().joined(separator: "\n")
        
        return topDivider + stackElement + bottomDivider
    }
}

var rwBookStack = Stack<String>()

rwBookStack.push("3D Games by Tutorials")
rwBookStack.peek()
rwBookStack.pop()
rwBookStack.pop()

rwBookStack.push("3D Games by Tutorials")
rwBookStack.push("tvOS Apprentice")
rwBookStack.push("iOS Apprentice")
rwBookStack.push("Swift Apprentice")
print(rwBookStack)

