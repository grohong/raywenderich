# Trie Data Structure

Trie는 문자가 각 node에 저장되는 n-tree입니다. 가장 인기있는 tree 종류일 뿐아니라 영어의 접두사 일치에 용이하게 쓰이는 데이터 구조 중 하나입니다.

![trie](/images/trie.png)

Trie는 특정 상황에 매우 유용합니다. Trie는 영어를 저장하는 데 큰 토움이 될뿐만 아니라 다음과 같은 이점이있는 해시 테이블을 대체 할 수 있습니다.

값을 찾는 것은 일반적으로 최악의 경우보다 시간 복잡성이 더 큽니다. 해시 테이블과 달리 Trie는 키 충돌을 걱정할 필요가 없습니다. 요소에 대한 고유 한 경로를 보장하기 위해 해시 알고리즘이 필요하지 않습니다. 트리 구조는 사전 순으로 정렬 할 수 있습니다.

이번에는 Trie의 영어 저장 애플리케이션을 중점을 두어 설명합니다.


## Trie Implementation

tree와 비슷하게, Trie도 node로 구성되어 있습니다. 이번 구현할 것은  ```TrieNode```클래스와 ```Trie```클래스로 구성될 것입니다. 각각의 TrieNode는 단어의 문자를 나타낼 것입니다. 예를들어, "cute"라는 단어는 **c -> u -> t -> e** 라는 node로 이루어 질 것입니다. ```Trie``` 클래스는 삽입 로직과 node의 참조를 나타낼 것입니다.


### TrieNode

아래와 같이 ```TrieNode``` 클래스를 작성해 보겠습니다.

```swift
class TrieNode<T: Hashable> {
  var value: T?
  weak var parent: TrieNode?
  var children: [T: TrieNode] = [:]

  init(value: T? = nil, parent: TrieNode? = nil) {
      self.value = value
      self.parent = parent
  }
}
```

값(제니릭)을 저장하고 부모 및 자식에 대한 참조를가집니다. 두 가지 지적해야 할 점이 있습니다.
- 부모 속성은 약한 참조주기를 방지합니다.(weak) ```Trie```에서 제거 작업을 수행하려면 부모에 대한 참조가 필요합니다.
- ```TrieNode```에 저장된 값은 HasTable 프로토콜을 준수해야합니다. 이는 사전에 값을 키로 사용하기 때문이며 Swift 사전의 키는 Hashable 준수해야합니다. Hashable을 준수하는 값에 대해 Character를 사용하므로 사용자기 설정됩니다.

이제 ```Node``` 클래스에 add 메소드를 추가해 보겠습니다.

```swift
func add(child: T) {
    //1
    guard children[child] else { return }

    //2
    children[child] = TrieNode(value: child, parent: self)
}
```

1. children 배열안에 child가 없다는걸 확인합니다. 만약 있다면 바로 return 해버립니다.
2. 새로운 값을 위해 새로운 node를 만듭니다. 그리고 children 딕셔너리에 추가합니다.

이렇게 tree의 공통적인 node 객체를 얻을수 있습니다. 앞으로 Trie에 구성 요소를 더 추가해 보겠습니다.


### Trie

```Trie``` 클래스는 node를 관리할 것입니다. 아래와 같이 작성해 주세요.

```swift
class Trie {
  fileprivate let root: TrieNode<Character>

  init() {
    root = TrieNode<Character>()
  }
}
```

이것은 당신의 Trie의 기초를 설정합니다. Trie의 루트 node에 대한 참조를 유지하는 루트 속성을 선언합니다. 영어에 대한 Trie를 구현하고 있으므로 Character 유형의 node를 사용하게 됩니다. init 메소드는 빈 TrieNode로 루트 속성을 간단히 초기화 합니다.

### Typealiasing

Trie tree를 더 하기전에 ```Trie``` 클래스를 아래와 같이 업데이트 해주세요.

```Swift
class Trie {
  typealias Node = TrieNode<Character>
  fileprivate let root: node

  init() {
      root = Node()
  }
}
```

node에 **typealias** 를 추가했습니다. 이렇게 한다면 ```TrieNode```는 유형을 node로 참조 할 수 있습니다. 추가로 구문을 줄이면 코드를 더욱 강력하게 만들 수 있습니다. node가 캐릭터가 아닌 다른 것을 표현하기를 원한다면, **tpyealias** 만 변경해주면 그 타입이 다른 것들에도 적용될 것입니다.


## Insertion

삽입 방법을 구현할 때, Trie는 항상 기존 node를 재사용하여 시퀀스를 완료하려고하기 때문에 효율적이라는 것을 기억하십시오.

![trie yoda](/images/trie_yoda.png)

예를 들어, 두 단어 "Cut"와 "Cute"는 4 개의 node를 사용하여 표현되어야합니다. 두 단어가 동일한 "Cut"접두어를 공유하기 때문입니다.

아래와 같이 ```Trie``` 클래스에 추가해 주세요.

```Swift
extension Trie {
  func insert(word: String) {
    //1
    guard !word.isEmpty else { return }

    //2
    var currentNode = root

    //3
    let characters = Array(word.lowercased().characters)
    var currentIndex = 0

    // ... more to come!
  }
}
```

1. ```String```이 비었는지 확인합니다. 만약 비없다면 ```return```을 반환하여 삽입하지 않습니다.
2. ```root``` node에 대한 참조를 만듭니다. 이것을 사용하여 Trie node를 반복합니다.
3. Trie의 단어는 node의 체인으로 표현되며 각 node는 단어의 문자를 나타냅니다(ex, "cute"는 c -> u -> t -> e). 문자 단위로 문자를 삽입하므로 단어를 배열로 바꾸면 삽입하는 동안 문자를 쉽게 추적 할 수 있습니다.

이제 조각 준비가 완료되었으므로 포인터 계산을 수행 할 준비가되었습니다! 다음과 같이```insert``` 연산자를 추가해 주세요.

```Swift
while current < characters.count {
  //1
  let character = characters[currentIndex]

  //2
  if let child = currentNode.children[character] {
    currentNode = child
  } else {
    //3
    currentNode.add(child: character)
    currentNode = currentNode.children[charcacter]!
  }

  //4
  currentIndex += 1

  // more to come!
}
```

1. 문자열에서 인덱스를 이용해 문자를 하나씩 가지고 옵니다.
2. 만약 현재 node에서 children에 해당 문자열이 있는지 없는지 알아봅니다. 만약 있을경우 그 child node을 해당노드로 합니다.
3. 없을경우에는 현재 node에 문자열을 가지고 있는 node를 만들고 child로 추가한뒤, 현재노드를 해당 child노드로 바꿔 줍니다.
4. 문자열 인덱스를 1 추가하고 반복해 줍니다.


### Terminating Nodes

이 시점에서, ```insert```메소드는 삽입하고자 하는 단어를 정확하게 통과 할 것이고 필요에 따라 새로운 node를 생성 할 것입니다. 그래도 뭔가 알았을 수도 있습니다. 예를 들어 "cute"라는 단어를 삽입 한 경우 "cut"이 삽입되었는지 여부를 어떻게 알 수 있을까요?

![trie_cute](/images/trie_cute.png)

일종에 표시가 없다면 확신 할 수 없습니다. 다시 ```TrieNode```클래스로 이동하여 새로운 속성을 추가해 주세요.

```Swift
var isTerminating = false
```

속성 ```isTerminating```은 단어의 끝을 나타내는 역할을합니다. 앞의 예에서 ```Trie```에 "cute"라는 단어를 넣으면 ```isTerminating```을 다음과 같이 사용하고자합니다.

![trie_terminating_cute](/images/trie_terminating_cute.png)

"cute"의 마지막 문자에 표시을 해줍니다, 이 표시는는 문자가 끝났다는 의미입니다. 만약 "cut"을 ```Trie```에 삽입한다면 이것은 "t"에 끝났다는 표시를 할 것입니다.

![trie_terminating_cut](/images/trie_terminating_cut.png)
