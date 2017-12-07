# Queue Data Structure

큐 리스트는 새로운 항목을 뒤쪽으로 삽입하고, 앞에서 항목을 제거할수 있는 구조입니다. 이렇게하면 대기열에 포함 된 첫 번째 항목도 대기열에서 제외 된 첫 번째 항목입니다.

왜 이걸 필요할까요? 많은 알고리즘에서 어던 시점에 임시 목록에 항목을 추가 한 다음 나중에 이 목록에서 다시 꺼내기를 원합니다. 종종 이러한 홍목을 추가하고 제거하는 순서가 중요합니다.

이 점에서 큐는 **FIFO** 를 보장해 줍니다.(fist-in, first-out) 이것은 스택의 **LIFO** 와 비슷합니다.(last-in, first-out)


### An example

큐를 가장 이해하기 쉬운 방법은 어떻게 쓰는지 한 번 보는것입니다.

```
queue.enqueue(10)
```

큐에다가 10을 넣습니다. 그 다음 숫자를 넣겠습니다.

```
queue.enqueue(3)
```

이제 큐에는 [10, 3]이 있습니다. 다음 숫자를 넣겠습니다.

```
queue.enqueue(57)
```

이제 큐에는 [10, 3, 57]이 있습니다. 이제 큐에 내용을 하나씩 빼보겠습니다.

```
queue.dequeue()
```

큐에서는 10이 나올것이고, 큐는 [3, 57]이 남습니다.

```
queue.dequeue()
```

큐에서는 3이 나올것이고, 이제 큐네는 57이 남습니다.


## Queue Implementation

이제는 일반적으로 사용하는 ```Int``` 값을 사용하는 ```Queue```를 구현해 보겠습니다.

```Swift
public struct Queue {

}
```

그리고 저번에 구현했던 ```LinkedList``` 클래스를 사용하겠습니다.


### Enqueue

큐에서 필요한 ```enqueue```를 구현해보겠습니다. 먼저 ```LinkedList```를 하나 만들고 시작하겠습니다.

```Swift
// 1
fileprivate var list = LinkedList<Int>()

// 2
public mutating func enqueue(_ element: Int) {
  list.append(element)
}
```

1. 큐에서 사용할 ```LinkedList```를 변수로 하나 생성해 둡니다.
2. ```enqueue```메소드를 하나 추가합니다. 이 메소드는 ```LinkedList```을 변화 시키기 때문에 ```mutating``` 키워드를 앞에 추가해 줍니다.


### dequeue

이번에는 ```dequeue``` 메소드 입니다.

```Swift
// 1
public mutating func dequeue() -> Int? {
  // 2
  guard !list.isEmpty, let element = list.first else { return nil }

  list.remove(element)

  return element.value
}
```

1. ```dequeue``` 메소드를 추가합니다. 이 메소드 또한 ```list```안의 값을 바꾸기 때문에 ```mutating``` 키워드를 앞에 추가하고, ```list```가 비어있다면 ```nil```값이 나올수 있기때문에 ```Int```옵셔널로 반환합니다.
2. ```guard```를 이용하여 ```list```가 비어있는지 확인후, ```list```의 첫번째 값을 가지고와서, 제거하고 리턴해줍니다.


### Peek

큐의 값을 제거하지 않고 가지고 오기위해 ```peek```메소드를 구현할 것입니다.

```Swift
public func peek() -> Int? {
    return list.first?.value
}
```
- 값을 변견하지 않기때문에 일반적인 함수에 값이 있을경우만 나올수 있게 옵셔널을 반환합니다.


### IsEmpty

값이 있는지 비었는지 확인하기 위해 ```isEmpty``` 함수를 구현합니다.

```Swift
public var isEmpty: Bool {
  return list.isEmpty
}
```


### Printing Your Queue

이제 ```Queue```에 속성을 넣어보고, 출력해 보겠습니다.

```Swift
var queue = Queue()

queue.enqueue(10)
queue.enqueue(3)
queue.enqueue(57)

print(queue)
```

```
Queue
```

아래와 같은 결과가 나오는걸 볼 수 있습니다.

좀 더 자세한 값을 보기 위해서 ```CustomStringConvertible```을 이용하여 ```String```으로 출력해 보겠습니다.

```Swift
// 1
extension Queue: CustomStringConvertible {
  // 2
  public var description: String {
    // 3
    return list.description
  }
}
```

1. ```Queue```의 값을 ```String```으로 출력하기 위해 ```CustomStringConvertible```을 상속받습니다.
2. 출력할 ```String```을 ```description``` 속성으로 정의합니다.
3. ```list```의 ```String```값을 가지고 옵니다.

 ```
"[10, 3, 57]"
 ```


## Generic Swift Queue Implementation

이제 ```Queue```에서 ```String```값 뿐만 아니라 다른 값을 쓸 수 있도록, generic을 이용해 추상화 해보겠습니다.

```Swift
public struct Queue<T> {
    fileprivate var list = LinkedList<T>()

    public mutating func enqueue(_ element: T) {
        list.append(value: element)
    }

    public mutating func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else { return nil }

        list.remove(node: element)

        return element.value
    }

    public func peek() -> T? {
        return list.first?.value
    }

    public var isEmpty: Bool {
        return list.isEmpty
    }
}

extension Queue: CustomStringConvertible {
    public var description: String {
        return list.description
    }
}
```

이제 ```String```값이 들어가는 것을 확인할 수 있습니다.

```Swift
var queue2 = Queue<String>()
queue2.enqueue("mad")
queue2.enqueue("lad")
if let first = queue2.dequeue() {
  print(first)
}
print(queue2)
```

```
mad
[lad]
```
