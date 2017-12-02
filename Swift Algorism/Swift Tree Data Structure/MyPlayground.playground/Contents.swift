//: Playground - noun: a place where people can play

class Node<T> {
    var value: T
    var children: [Node] = []
    weak var parent: Node?
    
    init(value: T) {
        self.value = value
    }
    
    func add(child: Node) {
        children.append(child)
        child.parent = self
    }
}

extension Node: CustomStringConvertible {
    var description: String {
        var text = "\(value)"
        
        if !children.isEmpty {
            text += "{" + children.map {$0.description}.joined(separator: ", ") + "} "
        }
        
        return text
    }
}

//extension Node {
//    func search(value: T) -> Node? {
//        if value == self.value {
//            return self
//        }
//
//        for child in children {
//            if let found = child.search(value: value) {
//                return found
//            }
//        }
//
//        return nil
//    }
//}

extension Node where T: Equatable {
    func search(value: T) -> Node? {
        if value == self.value {
            return self
        }
        
        for child in children {
            if let found = child.search(value: value) {
                return found
            }
        }
        
        return nil
    }
}


let beverages = Node(value: "beverages")

let hotBeverages = Node(value: "hot")
let coldBeverages = Node(value: "cold")


beverages.add(child: hotBeverages)
beverages.add(child: coldBeverages)

// level1
let teaBeverages = Node(value: "tea")
let coffeeBeverages = Node(value: "coffee")
let cocoaBeverages = Node(value: "cocoa")

hotBeverages.add(child: teaBeverages)
hotBeverages.add(child: coffeeBeverages)
hotBeverages.add(child: cocoaBeverages)

let sodaBeverages = Node(value: "soda")
let milkBeverages = Node(value: "milk")

coldBeverages.add(child: sodaBeverages)
coldBeverages.add(child: milkBeverages)

// level2
let blackBeverages = Node(value: "black")
let greenBeverages = Node(value: "green")
let chaiBeverages = Node(value: "chai")

teaBeverages.add(child: blackBeverages)
teaBeverages.add(child: greenBeverages)
teaBeverages.add(child: chaiBeverages)

let gingerAleBeverages = Node(value: "gingerAle")
let bitterLemonBeverages = Node(value: "bitterLemon")

sodaBeverages.add(child: gingerAleBeverages)
sodaBeverages.add(child: bitterLemonBeverages)

print(beverages)

beverages.search(value: "cocoa")
beverages.search(value: "chai")
beverages.search(value: "bubbly")

let number = Node(value: 5)
