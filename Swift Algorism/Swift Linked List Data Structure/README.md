# Linked List Data Structure

링크드 리스트는 연속적인 데이터 형태입니다. 여기서 각각의 데이터는 node입니다.

링크드 리스트는 2가지의 종류가 있습니다.

**Singly Linked Lists** 는 각각의 node가 다음node와 한방향으로 참조하는 형태 입니다.

![singly_linked_lists](/images/singly_linked_lists.png)

**Doubly Linked Lists** 는 각각의 node가 전 node와 다음 node로 두방향으로 참조하는 형태 입니다.

![doubly_linked_lists](/images/doubly_linked_lists.png)

리스트의 처음과 끝을 표시해 두어야 합니다. 보통 이곳을 가르키는 포인터를 **head**, **tail** 이라고 합니다.

![linked_head,tail](/images/linked_head,tail.png)


## Linked List Implementation in Swift 3

이제 Linked List를 구현해 보겠습니다. 링크드 리스트는 node로 구현되어 있기때문에 처음에는 간단한 node 클래스를 먼저 구현해 보겠습니다.

```Swift
public class Node {

}
```


### Value

node에는 연관된 값이 필요합니다. 중괄호 사이에 다음을 추가해 주세요.

```Swift
public class Node {
  var value: String

  init(value: String) {
    self.value = value
  }
}
```

속성 중 ```value```는 ```String```으로 정의했습니다. 만약 앱에서 쓸때 원하는 타입으로 재정의 할 수 있습니다.

생성자에서는 ```value```를 정의해 주었습니다.


### Next

각각의 node는 다음 node로 갈 포인터가 필요합니다.

이를 위해 새로운 속성을 추가하겠습니다.

```Swift
var next: Node?
```

속성중 ```next```는 ```Node```로 정의했습니다. ```next```는 현재 node가 마지막 node일수도 있기 때문에 옵셔널로 정의했습니다.


### Previous

만약 doubly-linked lists를 구현하게 된다면 previous 포인터도 필요할 것입니다. 이를 위해 previous 속성도 추가하겠습니다.

```Swift
weak var previous: Node?
```


### Linked Lists

이제 node를 만들었으므로 목록 시작 및 끝 위치를 추적해야합니다. 이렇게 하려면 이 새로운 ```LinkedList``` 클래스를 추가해 주세요.

```Swift
public class LinkedList {
  fileprivate var head: Node?
  private var tail: Node?

  public var isEmpty: Bool {
    return head == nil
  }

  public var first: Node? {
    return head
  }

  public var last: Node? {
    return tail
  }
}
```

이 클래스는 목록 시작 및 끝 위치를 추적합니다. 또한 여러 가지 다른 도우미 기능을 제공합니다.


### Append

새로운 node를 추가하기 위해서 ```append(value:)```메소드를 추가할 것입니다.

```Swift
public func append(value: String) {
  // 1
  let newNode = Node(value: value)
  // 2
  if let tailNode = tail {
    newNode.previous = tailNode
    tailNode.next = newNode
  } else {
    // 3
    head = newNode
  }

  tail = newNode
}
```

1. 값을 포함하는 새 ```Node```를 작성하십시오. ```Node``` 클래스의 목적은 링크 된 각 항목이 이전 및 다음 node를 가리킬 수 있다는 점입니다.

2. ```tailNode```가 nil이 아니라면 이미 연결된 목록에 뭔가가 있음을 의미합니다. 이 경우 새 항목을 이전 항목 인 목록의 꼬리를 가리 키도록 구성하십시오. 마찬가지로 새 node를 다음 항목으로 가리 키도록 목록의 마지막 항목을 구성합니다.

3. 마지막으로, 꼬리를 새 항목으로 적용하세요.


### Printing Your Linked List

한번 ```LinkedList```를 사용해 보겠습니다. 다음과 같이 코드를 추가해 주세요.

```Swift
let dogBreeds = LinkedList()
dogBreeds.append(value: "Labrador")
dogBreeds.append(value: "Bulldog")
dogBreeds.append(value: "Beagle")
dogBreeds.append(value: "Husky")

print(dogBreeds)
```

그러면 콘솔창에 이러한 정보가 뜰 것입니다.


```
__lldb_expr_86.LinkedList
```

이 LinkedList를 ```String``` 형태로 출력하기 위해서 ```CustomStringConvertible```이용하겠습니다.

```Swift
// 1
extension LinkedList: CustomStringConvertible {
  // 2
  public var description: String {
    // 3
    var text = "["
    var node = linked_head
    // 4
    while node != nil {
      text += "\(node!.value)"
      node = node!.next
      if node != nil { text += ", " }
    }
    // 5
    return text + "]"
  }
}
```

1. ```LinkedList``` 클래스에 ```CustomStringConvertible```을 추가해 줍니다.
2. ```description``` 속성을 추가하여 ```String```값으로 출력할 내용을 정의합니다.
3. ```text```를 생성하여 ```String```값을 만들어 줍니다.
4. node가 끝날때 까지 반복하면서 node가 가지고 있는 ```value```값을 추가해 줍니다.
5. 마지막에 ```"]"``` 추가하여 ```String```형을 완성해줍니다.

이제 출력을 해보겠습니다.

```
[Labrador, Bulldog, Beagle, Husky]
```


### Accessing Nodes

링크 된 목록은 이전 및 다음 node를 통해 순서대로 node를 이동할 때 가장 효율적으로 작동하지만 인덱스로 항목에 액세스 하는 것이 편리 할 때도 있습니다.

이렇게하려면 클래스에 ```nodeAt(index:)``` 메소드를 선언해야합니다. 이 클래스는 지정된 인덱스의 node를 리턴합니다.

```Swift
public func nodeAt(index: Int) -> Node? {
  // 1
  if index >= 0 {
    var node = head
    var i = currentIndex
    // 2
    while node != nil {
        if i == 0 { return node }
        i -= 1
        node = node!.next
    }
  }
  // 3
  return nil
}
```

1. ```index```가 음수일 경우 ```nil```값을 리턴합니다.
2. ```index```만큼 루프를 돌면서 해당 node로 이동합니다.
3. node수 보다 클 경유 ```nil```이 리턴됩니다.


### Removing All Nodes

모든 node를 지우는 일은 쉽습니다. ```head```와 ```tail```을 ```nil```로 정의하면 됩니다.

```Swift
public func removeAll() {
  head = nil
  tail = nil
}
```


### Removing Individual Nodes

1. *첫번째 node를 지울때.* ```head```와 ```previous```의 포인터를 업데이트 해줍니다.

![linked_remove1](/images/linked_remove1.png)

2. *중간의 node를 지울때.* ```previous```와 ```next```의 포인터를 업데이트 해줍니다.

![linked_remove2](/images/linked_remove2.png)

3. *마지막 node를 지울때.*```next```와 ```tail```의 포인터를 업데이트 해줍니다.

![linked_remove3](/images/linked_remove3.png)

```Swift
public func remove(node: Node) -> String {
  let prev = node.previous
  let next = node.next

  if let prev = prev {
    prev.next = next // 1
  } else {
    head = next // 2
  }
  next?.previous = prev // 3

  if next == nil {
    tail = prev // 4
  }

  // 5
  node.previous = nil
  node.next = nil

  // 6
  return node.value
}
```

1. 만약 첫번째 node가 아닐경우, ```next``` 포인터를 업데이트 합니다.
2. 만약 첫번째 node일 경우, ```head``` 포이터를 업데이트 합니다.
3. 다음node의 ```previous```를 전 node로 업데이트 합니다.
4. 만약 끝node라면, ```tail```을 업데이트 합니다.
5. 현재 node의 전과 끝을 ```nil```로 초기화 합니다.
6. 제거된 node를 리턴합니다.


### Generics

이 때까지의 linked list는 모두 ```String```값을 다루었습니다. 하지만 이번에는 generics을 추상화 하는 방법을 이용하여 다른 값들도 다룰수 있는 linked list로 업데이트 해보겠습니다.

```Swift
// 1
public class Node<T> {
    // 2
    var value: T
    var next: Node<T>?
    weak var previous: Node<T>?

    // 3
    init(value: T) {
        self.value = value
    }
}
```

1. ```Node```를 generic 타입인 ```T```로 정의 합니다.
2. 이번 목표는 node의 값이 generic이기 때문에 value 값도 ```T```로 정의 합니다.
3. 생성자에서 값을 ```T``` 형태로 받아와 초기화 합니다.

이제 ```Node```를 사용하는 ```LinkedList```를 generic 형태로 업데이트 해보겠 습니다.

```Swift
// 1. LinkedList안에서 T를 정의해 줍니다/
public class LinkedList<T> {
    // 2. head와 tail의 Node에서 T를 다루기 때문에 정의해줍니다.
    fileprivate var head: Node<T>?
    private var tail: Node<T>?

    public var isEmpty: Bool {
        return head == nil
    }

    // 3.
    public var first: Node<T>? {
        return head
    }

    // 4.
    public var last: Node<T>? {
        return tail
    }

    // 5.
    public func append(value: T) {
        let newNode = Node(value: value)

        if let tailNode = tail {
            newNode.previous = tailNode
            tailNode.next = newNode
        } else {
            head = newNode
        }

        tail = newNode
    }

    // 6.
    public func nodeAt(index: Int) -> Node<T>? {
        if index >= 0 {
            var node = head
            var i = index

            while node != nil {
                if i == 0 { return node }
                i -= 1
                node = node!.next
            }
        }

        return nil
    }

    public func removeAll() {
        head = nil
        tail = nil
    }

    // 7.
    public func remove(node: Node<T>) -> T {
        let prev = node.previous
        let next = node.next

        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        next?.previous = prev

        if next == nil {
            tail = prev
        }

        node.previous = nil
        node.next = nil

        return node.value
    }
}
```

이렇게 고쳤을 경우 ```String```값 뿐만 아니라 다른 타입의 값도 다룰수 있는것을 확인할 수 있습니다.

```
let dogBreeds = LinkedList<String>()
dogBreeds.append(value: "Labrador")
dogBreeds.append(value: "Bulldog")
dogBreeds.append(value: "Beagle")
dogBreeds.append(value: "Husky")

let numbers = LinkedList<Int>()
numbers.append(value: 5)
numbers.append(value: 10)
numbers.append(value: 15)
```
