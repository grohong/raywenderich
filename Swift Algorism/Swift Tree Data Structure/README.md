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


## Challenge: Beverage City

위에 만든 Node 클래스를 가지고 아래와 같은 tree를 만들어 봅시다!

![tree_challenge](/images/tree_challenge.png)

```swift
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
```

### Printing Trees

콘솔 로깅없이 큰 tree 구조를 확인하는 것은 어려울 수 있습니다. tree 구조를 정의한 다음 tree를 인쇄하여 콘솔에 결과를 기록해 봅시다.

```swift
print(beverages)
```
Command-Shift-Y를 이용하면 콘솔을 확인할수 있습니다.

```console
__lldb_expr_8.Node
```

불행히도 컴팡일러는 사용자 정의 Swfit 객체를 인쇄하기 힘듭니다. 컴파일러를 돕기위해 CustomStringConvertible 프로토콜을 채택하도록 해야 합니다. 아래와 같이 코드를 작성해 주세요.

```swift
//1
extension Node: CustomStringConvertible {
    //2
    var description: String {
        //3
        var text = "\(value)"

        //4
        if !children.isEmpty {
            text += "{" + children.map {$0.description}.joined(separator: ", ") + "} "
        }

        return text
    }
}
```

1. Node클래스가 CustomStringConvertible을 채택하게는 extension을 작성합니다. CustomStringConvertible은 ```description```의 내용을 보여주는 프로토콜 입니다.

2. ```description```을 정의합니다. 이는 **computed property** 로 읽기만 가능하며 return 값으로 ```String```형만 반환 합니다.

3. ```text```를 정의하고, 이 안에 node의 값들을 ```String```값을 적용합니다.

4. 덧붙여서, node안에 자식들이 있을수 있기 때문에 이를 판단하고 있을 경우 children 배열의 값을을 클로저로 가지고와 ```text```에 추가합니다.

그러면 다음과 같은 결과가 콘솔에 보일것입니다.

```console
beverages{hot{tea{black, green, chai} , coffee, cocoa} , cold{soda{gingerAle, bitterLemon} , milk} }
```

### Search

여기에 표시된 범용 tree는 계층 적 데이터를 설명하는 데 유용하지만 실제로 어떤 유형의 추가 기능이 필요한지에 따라 응용 프로그램에 따라 다릅니다. 예를 들어, Node 클래스를 사용하여 tree에 특정 값이 포함되어 있는지 확인할 수 있습니다. 이 범용 tree에 대한 검색 알고리즘을 용이하게 하려면 다음과 같은 코드를 추가해 주세요.

```swift
extension Node {
    //1
    func search(value: String) -> Node? {
        //2
        if value == self.value {
            return self
        }
        //3
        for child in children {
            if let found = child.search(value: value) {
                return found
            }
        }
        //4
        return nil
    }
}
```

1. ```search```라는 함수를 정의합니다. 이는 해당 node와 node 자식중에 찾는 값이 있으면 Node로 리턴하고 없다면 ```nil```값을 리턴합니다.

2. 만약 찬는 node가 해당 node라면 자기 자신을 리턴합니다.

3. root node에서 값을 찾을때 자식 배열에서 값을 찾고 재귀를 이용하여 자식 node에서도 해당값이 없는지 찾아봅니다.

4. 자식에도 값이 없다면 ```nil```을 반환합니다.

해당 코드를 적어서 결과를 확인해 봅시다.

```swift
beverages.search(value: "cocoa") //"cocoa" node를 리턴합니다.
beverages.search(value: "chai") //"chai" node를 리턴합니다.
beverages.search(value: "bubbly") //nil를 리턴합니다.
```

## What About Different Types?

지금까지 ```String```값을 저장하는 범용 tree를 구현하는 방법을 배웠습니다. tree를 콘솔에 인쇄하는 좋은 방법을 정의하고 Node클래스에 검색 기능을 만들어 봤습니다. tree는 계층 적 구조의 문자열을 배치하는 좋은 방법이지만, 대신 ```Integer```를 저장하려는 경우 어떻게 해야될까요?

```swift
class Node {
  var value: Int

  // ...
}
```

위와같이 바꾸면 ```Integer```값을 받을수 있지만 전에 있던 ```String```값은 모두 잃어버리게 될것입니다. 가장이상적인 방법은 ```Int```, ```Double```, ```Float``` 또는 자신 만의 사용자 정의 클래스 등 모든 유형의 객체를 수용 할 수있는 Node 클래스를 작성하는 것이 좋습니다. 그렇기 위해서는 **generics** 를 써야 합니다!

### Generics

generics의 아이디어는 알고리즘과 데이터 구조로부터 형식 요구 사항을 추상화하는 것입니다. 이렇게하면 아이디어를 일반화하고 재사용 할 수 있습니다. 객체가 tree (또는 다른 데이터 구조)에서 잘 작동하는지 여부는 그것이 ```Int```인지 ```String```인지에 관계없이 오히려 더 내재적이어야합니다. tree와 관련하여, 계층 구조에서 잘 작동하는 모든 유형은 tree에서 사용하기에 적합한 후보입니다. 아래와 같이 Node 클래스를 바꿔보겠습니다.

 ```swift
//1
class Node<T> {
  //2
  var value: T
  weak var parent: Node?
  //3
  var children: [Node] = []

  //4
  init(value: T) {
    self.value = value
  }

  //5
  func add(child: Node) {
    children.append(child)
    child.parent = self
  }
}
 ```

 1. Node 클래스의 선언을 변경하여 제네릭 형식 ```T```를 취했습니다. ```T```를 둘러싼 <>구문은 컴파일러에게 제네릭을 사용할 의도가 있음을 경고하는 것입니다.

 2. 목표는 Node 클래스가 모든 유형의 값을 받아들이도록 허용하므로 값 속성을 ```Int``` 또는 ```String```이 아닌 ```T``` 유형으로 제한합니다.

 3. children 또한 ```T```배열로 만듭니다.

 4. 이제 생성자를 통해 값을 받을때 ```T```형식으로 받습니다.

 5. ```add(child:)``` 메소드를 업데이트하여 현재 ```Node``` 유형과 일치하는 모든 유형의 ```Node``` 객체를 가져 왔습니다.

그다음 ```search``` 메소드를 다음과 같이 작성해주세요.

```swift
//1
extension Node where T: Equatable {
  //2
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
```

1. 이 확장에 대한 제약 조건을 도입하여 모든 유형이 검색 방법을 활용하기 전에 ```Equatable```이어야합니다.

2. 값 매개 변수를 제네릭 형식으로 업데이트했습니다.

이제 코드를 컴파일해야하므로 이 코드를 테스트 해봅시다! 하단에 아래 코드를 적용하여 작동하는지 봅시다.

```swift
let number = Node(value: 5)
```

위 코드가 오류가 나지 않고 작동하는 것을 확인할 수 있습니다.
