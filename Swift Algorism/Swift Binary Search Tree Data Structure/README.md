# Binary Tree Data Structure

*Binary tree* 는 컴퓨터 과학에서 가장 보편적 인 데이터 구조 중 하나입니다. *Red Black Tree* 및 *AVL Tree* 와 같은 고급 tree는 *binary tree* 에서 발전했습니다.

binary tree 자체는 범용 tree에서 발전했습니다. 이것이 무엇인지 모르는 경우, [Swift Tree Data Structure](https://grohong.github.io/raywenderlich/2017/12/03/raywenderlick-SwiftAlgorismTreeDataStructure.html)에서 확인해 보세요.

binary tree는 각 노드가 0, 1 또는 2개의 하위 노드를 갖는 트리입니다. 중요한 점은 2가 최대 값이라는 것입니다. 그래서 binary라는 이름을 가지게 됩니다. 아래에서 모습을 확인해 보겠습니다.

![binary_exam](/images/binary_exam.png)


## Binary Tree Implementation in Swift

다른 트리와 마찬가지로, binary tree도 노드로 구성되어 있습니다. 노드를 표현하는 방법중 하나는 노드 클래스를 만드는 것입니다.(아래는 그 예중 하나입니다.)

```Swift
class Node<T> {
  var value: T
  var leftChild: Node?
  var rightChild: Node?

  init(value: T) {
      self.value = Value
  }
}
```
binary tree에서, 모든 노드는 ```value```값을 갔습니다. 또 ```leftChild```및 ```rightChild```로 구성된 왼쪽, 오른쪽 자식도 갔습니다. 구현할때는 자식이 ```nil```값이 올수도 있기때문에 옵셔널로 구현했습니다.

이것은 전통적인 트리 구성방법입니다. 하지만 오늘은 좀 새로운 방법을 써보겠습니다.


### Value Semantics

Swift의 핵심 아이디어 중 하나는 적절한 경우 참조 유형(class) 대신 값 유형(struct 및 enum)을 사용하는 것입니다. binary tree를 만드는 것은 값 유형을 사용하는 완벽한 경우입니다. 이번 기회에 enum을 자습하는 기회를 가질 수 있습니다.

아래와 같이 ```enum```으로 구현된 이진트리를 추가해 주세요.

```Swift
enum BinaryTree<T> {

}
```
값이 무엇이 올지 모르게 때문에 제네릭 형태로 이진트리를 구현했습니다.


### States

enum형은 하나의 상태로만 존재할 수 있다는 점에서 엄격합니다. 다행히도, 이것은 binary tree 의 아이디어에 적합 합니다. binary tree는 비어있는 노드의 유한 집합이거나 노드의 값과 왼쪽 및 오른쪽 자식에 대한 참조로 구성됩니다.

아래와 같이 코드를 업데이트 해주세요.

```Swift
enum BinaryTree<T> {
  case isEmpty
  case node(BinaryTree, T, BinaryTree)
}
```
만약 다른 프로그래밍 언어를 사용한다면, node case가 조금 어색할 것입니다. Swift의 enum은 값을 직접 참조합니다. 이것은 저장된 속성을 case로 바로 사용할수 있다는 장점이 있습니다.

node(BinaryTree, T, BinaryTree)에서 매개 변수 유형은 각각 왼쪽 자식, 값 및 오른쪽 자식에 해당합니다.

이것은 binary tree를 설계하는데 좋은 방법이지만, 아래와 같은 오류가 뜰 것입니다.

```Recursive enum 'BinaryTree<T>' is not marked 'indirect'```

Xcode에서는 아래와 같은 방식으로 수정을 요청할 것입니다.

```Swift
indirect enum BinaryTree<T> {
  case isEmpty
  case node(BinaryTree, T, BinaryTree)
}
```


### Indirection

Swift의 enum은 값 유형입니다. Swift가 값 유형에 대해 메모리를 할당하려고하면 할당 할 메모리 양을 정확히 알아야합니다. 정의한 enum은 재귀형 입니다. 재귀 값 유형은 결정할 수 없는 크기입니다.

![binary_toon](/images/binary_toon.png)

여기서 문제가 발생하는데, Swift의 enum형은 정확한 크기를 알고 싶어하지만 재귀형을 쓰는 지금 정확한 크기를 알 수 없습니다.

그래서 ```indirection```이라는 정의가 적용됩니다. ```indirection```은 두 값 유형 사이에 간접 계층을 적용합니다. 이 는 값 유형에 대한 참조 의미 체계의 앏은 계층을 도입합니다.

enum형은 이제 해당 값이 아닌 연결된 값을 참조합니다. 참조는 일정한 크기이므로 더 이상 이전 문제가 없습니다.

코드가 컴파일되는 동안 조금 더 간결해질 수 있습니다. 아래와 같이 코드를 바꿔주세요.

```Swift
enum BinaryTree<T> {
  case isEmpty
  indirect case node(BinaryTree, T, BinaryTree)
}
```
이제 ```node```에만 ```indirection```을 걸었습니다.


## Example: Sequence of Arithmetical Operations

binary tree의를 사용하는 모델 중 하나는 계산을 모델링 하는것 입니다. 아래와 같은 식을 모델링 해 주세요.
**(5 * (a - 10)) + (-4 * (3 / b))**

![binary_calculation](/images/binary_calculation.png)

```Swift
// leaf nodes
let node5 = BinaryTree.node(.empty, "5", .empty)
let nodeA = BinaryTree.node(.empty, "a", .empty)
let node10 = BinaryTree.node(.empty, "10", .empty)
let node4 = BinaryTree.node(.empty, "4", .empty)
let node3 = BinaryTree.node(.empty, "3", .empty)
let nodeB = BinaryTree.node(.empty, "b", .empty)

// intermediate nodes on the left
let Aminus10 = BinaryTree.node(nodeA, "-", node10)
let timesLeft = BinaryTree.node(node5, "*", Aminus10)

// intermediate nodes on the right
let minus4 = BinaryTree.node(.empty, "-", node4)
let divide3andB = BinaryTree.node(node3, "/", nodeB)
let timesRight = BinaryTree.node(minus4, "*", divide3andB)

// root node
let tree = BinaryTree.node(timesLeft, "+", timesRight)
```
leaf에서 역으로 코드를 완성시켜야 합니다.


### CustomStringConvertible

콘솔 로킹 없이는 트리의 구조를 확인하기 힘들 수 있습니다. Swift의 CustomStringConvertible를 사용한다면 binary tree를 손쉽게 콘솔에 출력해 볼수 있습니다. 아래와 같이 코드를 업데이트 해주세요.

```Swift
extension BinaryTree: CustomStringConvertible {
  var description: String {
    switch self {
    case let .node(left, value, right):
      return "value: \(value), left = [" + left.description + "], right = [" + right.description + "]"
    case .empty
      return ""
    }
  }
}
```
아래와 같은 콘솔 로그를 확인할 수 있을겁니다.

```
value: +,
    left = [value: *,
        left = [value: 5, left = [], right = []],
        right = [value: -,
            left = [value: a, left = [], right = []],
            right = [value: 10, left = [], right = []]]],
    right = [value: *,
        left = [value: -,
            left = [],
            right = [value: 4, left = [], right = []]],
        right = [value: /,
            left = [value: 3, left = [], right = []],
            right = [value: b, left = [], right = []]]]
```


### Getting The Count

또 다른 유용한 기능은 트리에서 노드 수를 얻을 수 있다는 것입니다. 다음과 같은 코드를 추가해 주세요.

```Swift
var count: Int {
        switch self {
        case let .node(left, _, right):
            return left.count + 1 + right.count
        case .empty:
            return 0
        }
    }
```
함수를 테스트 해보면

```Swift
tree.count //12
```
트리에 노드가 12 개 있기 때문에 사이드 바에 숫자 12가 표시되어야 합니다.

아래에선 가장 많이 사용되고 있는 **Binary Search Tree** 에 대해 알아보겠습니다.


## Binary Search Trees

Binary Search Tree는 트리가 항상 정렬되도록 삽입 및 삭제를 수행하는 특별한 종류의 이진 트리(각 노드에 두 개의 자식이있는 트리)입니다.


### “Always Sorted” Property

여기 binary search tree의 한 예입니다.

![binary_search_tree](/images/binary_search_tree.png)

각 왼쪽 자식 노드가 부모 노드보다 작고 각 오른쪽 자식 노드가 부모 노드보다 큰지 확인하십시오. binary search tree의 핵심 기능입니다.


### Insertion

삽입을 실행할때, 시작노드가 root에서부터 시작해야 됩니다.

- *만약 현재 노드가 비어있을때*, 새로운 노드를 삽입해야 합니다.
- *만약 새로운 값이 더 작을때*, 왼쪽 가지로 이동해야 합니다.
- *만약 새로운 값이 더 클때*, 오른쪽 가지로 이동해야 합니다.

새 값을 삽입 할 수 있는 빈 자리를 찾을 때까지 나무를 따라 길을 가로 지릅니다. 예를 들어 위의 트리에 값 9를 삽입한다고 가정 해보십시오.

1. tree의 root부터 시작합니다.(이번에는 7부터 시작), 그 후에 9랑 비교합니다.
2. 9>7, 그러면 오른쪽 가지로 이동합니다.
3. 9랑 10이랑 비교합니다. 9<10, 왼쪽 가지로 이동합니다.
4. 왼쪽가지는 비어있습니다. 9를 새로운 node로 추가합니다.

그러면 아래와 같은 그림을 볼 수 있습니다.

![binary_search_exam](/images/binary_search_exam.png)

다른 예를 들어보겠습니다. 만약 3을 추가하게 되면 어떻게 될까요?

1. 다시 root의 7부터 비교를 합니다.
2. 3<7, 3은 왼쪽 가지로 이동합니다.
3. 3과 2를 비교합니다. 3>2, 오른쪽 가지로 이동합니다.
4. 3과 5를 비교합니다. 3<5, 왼쪽 가지로 이동합니다.
5. 왼쪽가지는 비어있습니다. 3을 새로운 node로 추가합니다.

![binary_search_exam2](/images/binary_search_exam2.png)

새 요소를 tree에 삽입 할 수 있는 위치는 항상 단 한 곳입니다. 이 장소를 찾는 것은 O(h)정도로 쾌 빠릅니다.(h는 트리의 높이입니다.)


## Challenge: Implementing Insertion

이제 삽입 방법을 알았으니, 기능을 구현해 보겠습니다. 아래와 같은 코드를 추가해 주세요

```Swift
// 1
mutating func naiveInsert(newValue: T) {
  // 2
  guard case .node(var left, let value, var right) = self else {
    // 3
    self = .node(.empty, newValue, .empty)
    return
  }
  // 4

}
```

1. 값 유형은 기본적으로 불변입니다. 값 유형내에서 무언가를 변경하려고하는 메소드를 작성하는 경우, 메소드 앞에 ```mutating``` 키워드를 추가하여 명시적으로 정해야합니다.
2. 현재 node의 왼쪽 자식과 현재 값 및 오른쪽 자식을 ```guard```을 사용하여 표시합니다. 이 노드가 비어있으면 가드가 실패햐여 블록이 됩니다.
3. 블록에서는, ```self``` 는 ```empty```로 정의 되고 새로운 값이 들어갑니다.
4. 더 추가할 부분입니다.

위에서 설명한 알고리즘을 기반으로 섹션 4를 구현하려고 합니다. 이것은 binary search tree를 이해하는 것뿐만 아니라 재귀 기술을 향상시키는 데에도 큰 도움이 됩니다.

하지만 그렇게하기 전에 BinaryTree 속성을 변경해야합니다. 섹션 4에서는 새로운 값과 이전 값을 비교해야하지만 현재 ```binary tree```에서는 이를 수행 할 수 없습니다. 이 문제를 해결하려면 BinaryTree 열거 형을 다음과 같이 업데이트하십시오.

Comparable 프로토콜은 ```<```연산자와 같은 비교 연산자를 사용하여 binary tree를 작성하는데 사용하는 유형을 비교할 수 있음을 보장합니다.

이제, 위의 알고리즘을 기반으로 섹션 4를 구현해보십시오.

- *만약 현재 노드가 비어있으면*, 새로운 노드를 여기에 삽입하세요.
- *만약 새로운 값이 더 작으면*, 왼쪽 가지로 이동하세요.
- *만약 새로운 값이 더 크다면*, 오른쪽 가지로 이동하세요.

섹션 4에 아래와 같은 코드를 추가해 주세요.
```Swift
if newValue < value {
  left.naiveInsert(newValue: newValue)
} else {
  right.naiveInsert(newValue: newValue)
}
```


### Copy on Write

다음과 같이 확인해 보겠습니다.

```Swift
var binaryTree: BinaryTree<Int> = .empty
binaryTree.naiveInsert(newValue: 5) // binaryTree now has a node value with 5
binaryTree.naiveInsert(newValue: 7) // binaryTree is unchanged
binaryTree.naiveInsert(newValue: 9) // binaryTree is unchanged
```

![binary_face](/images/binary_face.png)

tree를 계속 바꿀려고 할 때마다 새 사본이 만들어 집니다. 이 새 복사본은 이전 복사본과 연결되어 있지 않으므로 초기 binary tree가 절대로 새 값으로 업데이트되지 않습니다.

이것은 다른 방법을 써야합니다. 다음과 같은 코드를 추가해 주세요.

```Swift
private func newTreeWithInsertedValue(newValue: T) -> BinaryTree {
  switch self {
    case .empty:
      return .node(.empty, newValue, .empty)

    case let .node(left, value, right):
      if newValue < value {
        return .node(left.newTreeWithInsertedValue(newValue: newValue), value, right)
      } else {
        return .node(left, value, right.newTreeWithInsertedValue(newValue: newValue))
      }
  }
}
```

삽입 된 요소가있는 새 tree를 반환하는 메서드입니다. 코드는 비교적 간단합니다.
1. tree가 비어 있으면 새 값을 여기에 삽입하려고합니다.
2. tree가 비어 있지 않으면 왼쪽 또는 오른쪽 자식에 삽입할지 여부를 결정해야합니다.

BinaryTree 열거 형 내에 다음 메서드를 작성합니다.

```Swift
mutating func insert(newValue: T) {
  self = newTreeWithInsertedValue(newValue: newValue)
}
```

아래와 같이 테스트 해보겠습니다.

```Swift
binaryTree.insert(newValue: 5)
binaryTree.insert(newValue: 7)
binaryTree.insert(newValue: 9)
print(binaryTree)
```

아래와 같이 콘솔에서 확인할 수 있습니다.

```
value: 5,
    left = [],
    right = [value: 7,
        left = [],
        right = [value: 9,
            left = [],
            right = []]]
```


### Insertion Time Complexity

스포일러 섹션에서 설명한 것처럼 삽입 할 때 마다 tree의 새 복사본을 만들어야합니다. 새 복사본을 만들려면 이전 tree의 모든 node를 통과해야 합니다. 시간 복잡성은 O(n)이 됩니다.


## Traversal Algorithms

순회 알고리즘은 tree 관련 작업의 기본입니다. 순회 알고리즘은 트리의 모든 node를 통과합니다. binary tree를 순회하는 세가지 주요 방법이 있습니다.


### In-order Traversal

binary search tree의 순차적 순회는 오름차순으로 node를 통과해야합니다. 순회 하는 방법은 다음과 같습니다

![binary_in-order_traversal](/images/binary_in-order_traversal.png)

위에서부터 시작하여 가능한 왼쪽으로 향합니다. 더 이상 왼쪽으로 갈 수 없다면 현재 node를 방문하여 오른쪽으로 이동하십시오. 이 절차는 모든 node를 탐색 할 때까지 계속 됩니다.

아래와 같은 함수를 추가해 주세요.

```Swift
// @noescape 는 default 값이기 때문에 생략 가능
func traverseInOrder(process: @noescape (T) -> ()) {
  switch self {
  // 1
  case .empty:
    return
  // 2  
  case let .node(left, value, right)
    left.traverseInOrder(process: process)
    process(value)
    right.traverseInOrder(process: process)
  }
}
```

1. 만약 현재 노드가 비어있다면, 아래로 갈 방법이 없기 때문에 return 한다.
2. 만약 현재 노드가 비어있지 않다면, 더 내려갈 수 있다. 왼쪽 노드를 방문하고, 자신을 방문하고, 오른쪽 노드를 방문합니다.

아래와 같은 테스트 케이스르 작성하고 확인해 볼수 있습니다.

```Swift
var tree: BinaryTree<Int> = .empty
tree.insert(newValue: 7)
tree.insert(newValue: 10)
tree.insert(newValue: 2)
tree.insert(newValue: 1)
tree.insert(newValue: 5)
tree.insert(newValue: 9)

tree.traverseInOrder { print($0) }
```

삽입 메소드를 사용하여 binary search tree를 만들었습니다. ```traverseInOrder```는 node를 오름차순으로 통과하여 각 node의 값을 후행 클로저로 전달합니다. 후행 클로저 내부에서 순회 방식에 의해 전달된 값을 인쇄하고 있습니다.

```
1
2
5
7
9
10
```


### Pre-order Traversal

Pre-order traversal는 binary search tree의 현재 노드를 처음 방문하는 동안 노드를 통과하는 것입니다. 여기서 핵심은 자식을 지나가기 전에 과정을 호출하는 것입니다. BinaryTree 안에 다음과 같은 코드를 작성해 주세요.

```Swift
func traversePreOrder(process: @noescape (T) -> ()) {
  switch self {
    case .empty:
      return
    case let .node(left, value, right):
      process(value)
      left.traverseInOrder(process: process)
      right.traverseInOrder(process: process)
  }
}
```


### Post-order Traversal

Post-order traversal은 binary search tree에서 왼쪽 자식과 오른쪽 자식을 돈뒤에 자기 가신을 호출할는 것입니다. BinaryTree 안에 다음과 같은 코드를 작성해 주세요.

```Swift
func traversePostOrder( process: @noescape (T) -> ()) {
  switch self {
  case .empty:
    return
  case let .node(left, value, right):
    left.traversePostOrder(process: process)
    right.traversePostOrder(process: process)
    process(value)
  }
}
```


## Searching

binary search tree는 효육적인 검색을 용이하게 합니다. binary search tree는 부모 노드보다 하위에 남아있는 모든 자식 노드가 있고 모든 부모 노드는 부모 노드와 같거나 큰 자식 노드입니다. 이러한 특징을 이용하여 트래 내에 값이 존재하는지 확인하기 위해 왼쪽 하위 경로 또는 오른쪽 하위 경로를 결정할수 있습니다. 다음과 같은 코드를 작성하세요.

```Swift
func search(searchValue: T) -> BinaryTree? {
    switch  self {
    case .empty:
        return nil
    case let .node(left, value, right):
      // 1
      if searchValue == value {
        return self
      }

      // 2
      if searchValue < value {
        return left.search(searchValue: searchValue)
      } else {
        return right.search(searchValue: searchValue)
      }
    }
}
```

1. 만약 찾는 값과 노드의 값이 같다면, 자기 사진을 반환합니다.
2. 찾는 값이 자신의 값보다 작을 경우 자신의 왼쪽 자식으로 재귀하고, 클경우 오른쪽 자식으로 재귀합니다.
