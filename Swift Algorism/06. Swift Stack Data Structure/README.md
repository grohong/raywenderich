# Stack Data Structure

**Stacks** 는 배열과 비슷한 형태이지만, 기능상 몇가지 한계가 있습니다. 당신은 오직 ```push```를 이용해서만 새로운 항목을 stack에 넣을수 있고, ```pop```을 이용해서 가장 위에있는 항목을 제거할수 있습니다. 그리고 ```peek```을 이용하여 가장 위에 있는 항목을 제거하지 않고 사용할수 있습니다.

이 걸로 무엇을 할 수 있을까요? 다른 알고리즘과 마찬가지로, 당신은 객체를 일시적으로 포인트와 함께 list에 저장하고, 나중에 마지막에 넣은것을 꺼내고 싶을 것입니다. 종종 이러한 객체를 추가하고 제거하는 순서가 중요합니다.

stack을 **LIFO** 를 보장해 줍니다.(last-in first-out order) 항목을 가장 처은 넣은것은 마지막에 꺼낼수 있습니다.


## Stack Operations

Stacks은 몇가지 기능이 한정적입니다. 책을 통해 예를 들어보겠습니다.


### Push

만약 stack에 새로운 항목을 추가할때, ```push```기능을 이용할 것입니다. 책을 하나 더 쌓는다고 생각하면 됩니다.


### Peek

디자인상, stack은 제일 위에 있는 내용말고는 알수없게 합니다. ```peek```은 가장 위에 내용을 볼수 있게 하는 메소드입니다.


### Pop

만약 가장위에 있는 내용을 제거하고 싶다면 ```pop``` 메소드가 있습니다. 가장 위에있는 책을 꺼내버린다고 생각하면 됩니다.


## Swift Stack Implementation

우선, ```playground```에 ```Stack```을 ```struct``` 형태로 만들어 줍니다.

```Swift
struct Stack {
    fileprivate var array: [String] = []
}
```

여기 ```Stack```에 ```array```속성이 하나 있습니다. 이 ```array```에 *push*, *pop*, *peek* 을 구현할 것입니다.


### Push

객체를 stack에 넣는것은 비교적 간단합니다.

```Swift
// 1
mutating func push(_ element: String) {
  // 2
  array.append(element)
}
```

1. ```push```는 ```Stack```의 array 속성을 바꾸기 때문에 ```mutating``` 키워드를 씁니다.
2. push 연산은 새 요소를 배열의 끝 부분에 놓고 시작 부분에 넣지 않습니다. 배열의 시작 부분에 삽입하는 것은 비용이 많이 드는 O(n)연산입니다. 왜냐하면 모든 기존 배열 요소가 메모리에서 애동해야 하기 때문입니다. 끝에 추가하는 것은 O(1)입니다. 배열의 크기에 관계없이 항상 동일한 시간이 걸립니다.


### Pop

Pop도 쉽습니다!

```Swift
// 1
mutating func pop() -> String? {
  // 2
  return array.popLast()
}
```

1. 우선 배열에 값을 없을경우 ```nil```값이 반환되기 때문에 리턴값을 ```String``` 옵셔널로 정의하겠습니다.
2. Swift 배열에서는 마지막 값을 리턴하고 제거해주는 ```popLast```라는 메소드를 이용해 줍니다.


### Peek

마지막으로 ```peek```을 구현해 보겠습니다.

```Swift
func peek() -> String? {
    return array.last
}
```

- 배열의 마지막 값을 보여주기만 하면 간단하게 구현할 수 있습니다.


## Give it a Whirl!

이제, ```Stack```을 테스트 해볼 준비가 됐습니다. 아래와 같이 테스트 코드를 적용해 주세요.

```Swift
// 1
var rwBookStack = Stack()

// 2
rwBookStack.push("3D Games by Tutorials")
// 3
rwBookStack.peek()

// 4
rwBookStack.pop()
// 5
rwBookStack.pop()
```

1. ```rwBookStack```을 ```Stack```으로 정의합니다. 값이 계속 변하기 때문에 ```var```로 정의하겠습니다.
2. stack에 "3D Games by Tutorials"를 넣습니다.
3. ```peek```을 이용하여 값을 확인합니다.
4. ```pop```을 이용하여 값을 꺼내서 확인합니다.
5. 값이 없어젔는지 확이합니다.


## CustomStringConvertible

현재 stack에 있는 요소를 시각화하는 것은 매우 어렵습니다. 다행스럽게도 Swift에는 CustomStringConvertible이라는 프로토콜이 내장되어있어 객체를 문자열로 표현하는 방법을 정의 할 수 있습니다. stack 구현 아래에 ```extenstion```을 이용하여 구현하겠습니다.

```Swift
// 1
extension Stack: CustomStringConvertible {
    // 2
    var description: String {
        // 3
        let topDivider = "---Stack---\n"
        let bottomDivider = "\n----------\n"

        // 4
        let stackElement = array.reversed().joined(separator: "\n")
        // 5
        return topDivider + stackElement + bottomDivider
    }
}
```

1. ```extension```을 이용하여 ```CustomStringConvertible``` 프로토콜을 채택하였습니다.
2. ```CustomStringConvertible```의 필수요소인 ```description```을 정의했습니다.
3. "\n"을 이용하여 stack의 시작과 끝에 줄 넘김을 해줍니다.
4. 스택에 요소를 표시하려면 요소를 배열에 쌓아 올리십시오. 배열의 뒤에 요소를 추가 했으므로 먼저 배열을 뒤집어야 합니다. 그런 다음 ```joined(separator:)```메서드는 배열의 모든 요소를 가져 와서 각 요소 사이의 구분 기호와 함께 연결합니다.
5. 마지막에 stack을 ```String``` 처리해주어 리턴합니다.

아래와 같은 테스트 코드로 확인할 수 있을겁니다.

```Swift
rwBookStack.push("3D Games by Tutorials")
rwBookStack.push("tvOS Apprentice")
rwBookStack.push("iOS Apprentice")
rwBookStack.push("Swift Apprentice")
print(rwBookStack)
```

```
---Stack---
Swift Apprentice
iOS Apprentice
tvOS Apprentice
3D Games by Tutorials
-----------
```


## Generics

지금 까지의 코드는 ```String```밖에 못다루는 stack 코드입니다. 이번에는 generics을 사용하여 다른 타입의 변수도 다룰수 있는 ```Stack```을 구현해 보겠습니다.

```Swift
struct Stack<T> {
  // ...
}
```

이제 ```Stack``` generic 형태에 맞게 고치도록 하겠습니다.

```Swift
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
```

그리고 ```description``` 고치도록 하겠습니다.

```Swift
// previous
let stackElements = array.reversed().joined(separator: "\n")

// now
let stackElements = array.map { "\($0)" }.reversed().joined(separator: "\n")
```

배열이 ```String```이 아니니 ```map```클로저를 이용하여 모두 ```String```으로 변환하고 적용해 주세요.

```
var rwBookStack = Stack<String>()
```

이러면 다른 타입의 객체도 모두 이용할 수 있습니다.
