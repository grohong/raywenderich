# Tree Data Structure

 가장 쉽게 tree data structure을 이해하려면 아래 그림을 참고하세요.

 ![tree_exam](/images/tree_exam.png)

위에 그림은 5levels의 tree구조입니다. **root** 는 level0이고, tree 아래쪽으로 이동할수록 level이 하나씩 증가합니다.

tree는 다음과 같은 문제를 풀때 효과적입니다.

- 객체 간의 계층 관계를 나타낼 때
- 빠르고 효율적인 검색을 할 때
- 정렬 된 데이터 목록을 제공할 때
- 텍스트 필드에서 접두사의 일치를 찾아낼 때

### 용어정리
처음으로 tree에서 사용하게 될 용어를 정리해 보겠습니다.

#### root

**root** 는 tree의 level0 부분의 node를 뜻합니다. tree data structure에 들어가는 부분에서 찾아볼수 있습니다.

![tree_root](/images/tree_root.png)


#### node

**node** 는 tree의 한블럭을 뜻합니다. node에 포함 된 데이터는 만들고있는 tree의 유형에 따라 다릅니다. root 또한 node입니다.

![tree_node](/images/tree_node.png)


### Leaf

node는 tree의 끝 node를 뜻합니다. 자식이 없는 node를 뜻하기도 합니다.

![tree_leaf](/images/tree_leaf.png)


## Tree Implementation in Swift

이 섹션에서는 범용 tree를 구현합니다. 이것은 어떤 종류의 제한도없는 tree를 말하는 멋진 방법입니다.(각 node가 얼마나 많은 자식을 가질 수 있는지, node의 순서와 같은) tree는 node로 구성되어 있다는 것을 기억하십시오. 시작하기 위해 기본 node 클래스를 작성해 보겠습니다.

```swift
class Node {

}
```

### Value

node는 관련 값이 없으면 쓸모가 없습니다. 단순화를 위해 이 tree를 틀수화 하여 문자열 데이터를 관리합니다. 현재 node 구현을 다음과 같이 작성하세요.

```swift
class Node {
  var value: String

  init(value: String) {
      self.value = value
  }
}
```

```value```를 ```String```으로 정의했습니다. 또한 생성자에서 이를 정의했습니다  

### Children

추가로, 각각의 node는 자식 리스트를 필요로 합니다.
다음과 같이 정의해 주세요

```swift
class Node {
  var value: String
  var Children: [Node] = []

  init(value: String) {
      self.value = value
  }
}
```
각각의 자식은 1level의 node를 뜻하고 있습니다.


### Parent

때로는 각 node가 상위 node에 대한 링크를 갖는 것이 편리합니다. 자식 node는 주어진 node 아래의 node입니다. 부모는 위의 node입니다. node는 한 개의 상위 항목 만 가질 수 있지만 여러 개의 하위 항목을 가질 수 있습니다. Node 클래스의 구현을 다음과 같이 작성하세요.

```swift
class Node {
  var value: String
  var Children: [Node] = []
  weak var parent: Node? //add the parent property

  init(value: String) {
      self.value = value
  }
}
```
여기서 부모는 옵셔널로 작성합니다.(root와 같이 부모가 없는 node가 존재하기 때문에) 또한 ```weak``` 를 이용하여 parent의 순환 참조를 방지합니다.


### Insertion

tree의 삽입 기능을 사용하기 위해서 ```add(child:)```라는 메소드를 Node클래스에 적용할 것입니다. 아래와 같이 코드를 작성해 주세요.

```swift
class Node {
  var value: String
  var Children: [Node] = []
  weak var parent: Node? //add the parent property

  init(value: String) {
      self.value = value
  }

  func add(child: Node) {
    childen.append(child)
    child.parent = self
  }
}
```

보다 잘 이해하기 위해서 playground에서 ```add(child:)``` 함수를 적용해 보겠습니다. 아래와 같은 코드를 클래스 밖에서 작성해 보겠습니다.

```swift
let beverages = Node(value: "beverages")

let hotBeverages = Node(value: "hot")
let coldBeverages = Node(value: "cold")

beverages.add(child: hotBeverages)
beverages.add(child: coldBeverages)
```

이 구조는 아래 그림과 같이 적용되었습니다.

![tree_beverage](/images/tree_beverage.png)
