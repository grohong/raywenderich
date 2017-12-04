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
