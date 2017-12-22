# Graphs with Adjacency list

**그래프** 는 두개의 객체의 관련성을 찾기 유용한 데이터 구조고, 가장가리 세트와 쌍을 이루는 정점으로 구성됩니다.

아래 그래프를 보면, 원이 꼭지점을 나타내고, 모서리이 객체의 사이를 나타냅니다. 각자 서로 선으로 연결되어 있습니다.

![graph_exam](/images/graph_exam.png)

그래프는 다양한 모습과 크기가 될 수 있습니다.


### Weighted Graphs

비행경로 예로 들어보겠습니다. 아래 이미지는 여러 비행 경로 네트워크를 보여줍니다. 꼭지점은 각 도시를 나타내고, 모서리는 사이에 비행 가능한 경로를 나타냅니다. 이제 각 모서리에 비중을 둘수 있습니다. 아래에서 샌프란 시스코에서 싱가포르로 가는 가장 싼 항공 편을 찾아 보겠습니다.

![graph_weight](/images/graph_weight.png)


### Directed and Undirected Graphs

그래프는 방향을 가질 수 있습니다. 첫번째 그래프는 **directed graph** 입니다, 모서리 마다 방향을 가지고 있습니다. Tokyo에서 Detroit로 비행을 한다고 생각하면 됩니다.

**directed graph** 는 또한 양방향이 될 수도 있습니다. 두개의 정점이 가도 돌아오는 모서리를 가지고 있습니다. 예를 들어 Singapore에서 Hong Kong까지 가고 오고 할수 있는 배행기편이라고 생각하시면 됩니다.

**undirected graph** 는, 방향이 없는 그래프 입니다. 어떤 면에서는 방향이 없는 그래프는, 양방향 그래프 입니다.

![graph_direction](/images/graph_direction.png)

아마 **tree** 와 **linked-list** 데이터 구조를 생각하실수도 있습니다. 그들은 그래프의 보다 간단한 버전 입니다.


## Representing a Graph

그래프를 나타내는 두가지 보편적인 방법이 있습니다. **adjacency matrix** 와 **adjacency list** 입니다. 그래프를 배우기에 앞서, adjacency list를 한번 배워 보겠습니다.


### Adjacency list

가장 간다한 adjacency list는 각 꼭지점 하나의 정보를 저장해둔 그래프 입니다. 각 꼭지점은 인접한 목록이 있습니다.  

![graph_adjacency](/images/graph_adjacency.png)

아래의 **adjacency list** 은 위의 그래프 처럼 표현할수 있습니다.

![graph_adjacencyList](/images/graph_adjacencyList.png)

Singapore가 두개의 모서리로 연결된 거를 볼수 있습니다. 이는 싱가포르에서 Tokyo나 Hong Kong으로 갈 수 있다는 뜻입니다.


### Approach

**adjacency list** 는 여러가지로 나타낼수 있습니다. 몇가지 유명한 접근을 봐보겠습니다.

- **Storing an array of arrays.** 외부 배열은 꼭지점을 나타내고, 인덱스를 줍니다. 내부 배열은 모서리를 가지고 있습니다.

- **Storing an array of linked-lists.** 이 방법으로 접근하면, 배열의 각각의 인덱스는 꼭지접을 나타냅니다. 각각의 배열의 값은 linked-list에 저장됩니다. 이 방법은 빠른 삽입과 삭제가 필요할때 적절합니다.

- **Storing a dictionary of arrays.** 이 방법은 이번 튜토리얼에서 배울겁니다. 각각의 키가 꼭지점을 나타납니다. 그리고 각각의 값이 해당 모서리 배열입니다.


## Implementing the Adjacency list

playground에서 **Vertex.swift** 라는 class를 Source 그룹에 하나 만들어 줍니다.

### Vertices

![graph_vertices](/images/graph_vertices.png)


그래프를 만들때 처음에 vertex가 필요합니다. **Vertex.swift** 라는 struct를 하나 정의해 줍니다.

```Swift
public struct Vertex<T: Hashable> {
  var data: T
}
```

vertex는 **data** 라는 속성을 하나 가지고 있습니다. 이제 꼭지점은 많은 관계를 나타낼 수 있습니다. 사람관계라든지, 비행기 노선이라든지, 거리 주소라든지.

그 다음 꼭지점은 dictionary 값으로 키 값을 만들수 있습니다. 이것은 **Hashable** 프로코톨로 수행할수 있습니다. 아래와 같이 만들어 주세요.

```Swift
extension Vertex: Hashable {
  public var hashValue: Int { // 1
    return "\(data)".hashValue
  }

  static public func ==(lhs: Vertex, rhs: Vertex) -> Bool { // 2
    return lhs.data == rhs.data
  }
}
```

1. **Hashable** 를 수행하기 위해서는 **hashValue** 값을 가지고 있어야 합니다.

2. **Hashable** 은 **Equatable** 을 상속합니다. equal-to 연산자를 추가해야 합니다.


```Swift
extension Vertex: CustomStringConvertible {
  public var description: String {
    return "\(data)"
  }
}
```

**CustomStringConvertible** 프로토콜은 data를 출력할때 도움을 주는 프로토콜입니다.


### Edges

![graph_edges](/images/graph_edges.png)

Source 그룹에 Edge.swift라는 클래스를 하나 추가해 주세요.

**Edge.swift** 는 Enum으로 정의된 클래스 입니다.

```Swift
public enum EdgeType {
case  directed, undirected
}
```

이 enum type의 목표는 방향 그래프인지 무방향 그래프인지를 구별하기 위해 저의해 둡니다.

```Swift
public struct Edge<T: Hashable> {
    public var source: Vertex<T> // 1
    public var destination: Vertex<T>
    public let weight: Double? // 2
}
```

1. 모서리를 구현하는 방법은 여러가지 있습니다. 이 모서리는, 두가지의 꼭지점을 포함하고 있습니다, **source** 와 **destination** 입니다. 그 이유는 그래프가 방향성을 가질 수 있기 때문입니다. 두 개의 정점은 양뱡향으므로 한 쌍점의 정점 사이에 두 개의 가장자리가 필요합니다.

2. 모서리는 어느정도의 가중치를 가질수 있습니다.

```Swift
extension Edge: Hashable {

  public var hashValue: Int {
    return "\(source)\(destination)\(weight)".hashValue
  }

  static public func ==(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
    return lhs.source == rhs.source &&
      lhs.destination == rhs.destination &&
      lhs.weight == rhs.weight
  }
}
```

**Edge** 또한 **Vertex** 와 비슷하게 **hashable** 프로토콜을 수행해야됩니다.


### Graphable Protocol

이제 **vertex** 와 **edge** 를 정의했습니다. 이제 한가지더 할게 남았습니다. graph에 대한 interface를 작성하는 것입니다.

이를 위해 Sources 그룹에 **Graphable.swift** 코드를 작성하겠습니다.

```Swift
protocol Graphable {
    associatedtype Element: Hashable // 1
    var description: CustomStringConvertible { get } // 2

    func createVertex(data: Element) -> Vertex<Element> // 3
    func add(_ type: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?) // 4
    func weight(from source: Vertex<Element>, to destination: Vertex<Element>) -> Double? // 5
    func edge(from source: Vertex<Element>) -> [Edge<Element>]? // 6
}
```

1. 프로토콜에서는 associatedtype의 Element를 요구합니다. associatedtype은 프로토콜에서 제네릭 타입이 요구될때 사용합니다.

2. description 속성은 그래프를 출력할때 사용됩니다. 이것은 debugging 할때도 유용합니다.

3. **createVertex(data:)** 는 꼭지점을 만들때 사용됩니다.

4. **add(_:from:to:weight:)** 는 두개의 꼭지점에 모서리를 추가할때 사용됩니다. 이때 무방향 모서리인지 방향 모서리인지와 비중을 결정할 수 있습니다.

5. **weight(from:to:)** 는 두개의 꼭지점 사이의 모서리에 비중을 줄수 있습니다.

6. **edge(from:)** 꼭지점에 연결된 모든 모서리를 받을 수 있습니다.


### Adjacency List

Sources 그룹아래 **AdjacencyList.swift** 라는 파일을 만들어 둡니다.

```Swift
open class AdjacencyList<T: Hashable> {
  public var adjacencyDict : [Vertex<T>: [Edge<T>]] = [:]
  public init() {}
}
```

**adjacencyDict** 은 그래프의 저장소로 쓸수 있습니다. **adjacencyDict** 은 딕셔너리 값입니다. 키는 **꼭지점** 이고 값은 **모서리** 입니다.

```Swift
extension adjacencyList: Graphable {
  public typealias Element = T
}
```

**AdjacencyList** 또한 제네릭 값입니다. **associatedtype** 값이 **T** 로 지정되었습니다.


## Creating Vertices

 꼭지점을 만들기 위해 아래와 같이 **extension** 에 코드를 작성해주세요.

 ```Swift
 public func createVertex(data: Element) -> Vertex<Element> {
   let vertex = Vertex(data: data)

   if adjacencyDict[vertex]  == nil {
     adjacencyList[vertex] == []
   }

   return vertex
 }
 ```

전달된 데이터로 **꼭지점** 을 만듭니다. 일단 꼭지점이 존재하는지 확인하고, 존재하지 않으면 배열을 초기화 하고 반환합니다.


## Creating Edges

그래프가 방향성 그래프 인지 무방향성 인지 확인합니다.

![graph_creatingEdges](/images/graph_creatingEdges.png)

**init():** 아래 다음과 같은 코드를 작성해 주세요.

```Swift
fileprivate func addDirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?) {
  let edge = Edge(source: source, destination: destination, weight: weight) // 1
  adjacencyDict[source]?.append(edge) // 2
}
```

1. 모서리를 생서합니다.

2. **source** 꼭지점에 모서리를 추가합니다.

```Swift
fileprivate func addUndirectedEdge(vertices: (Vertex<Element>, Vertex<Element>), weight: Double?) {
  let (source, destination) = vertices
  addDirectedEdge(from: source, to: destination, weight: weight)
  addDirectedEdge(from: destination, to: source, weight: weight)
}
```

무방향 그래프일때, 방향 그래프가 양쪽에 추가되는걸로 다룰 수 있습니다. **addDirectedEdge(from:to:weight:)** 를 두번 불러 이를 구현할수 있습니다.

이제 **AdjacencyList** 에 **createVertex(data:)** 를 구현할수 있습니다.

**add(_:from:to:weight)** 에서 방향인지 무방향인지 구분하고 이에 따로 모서리를 추가합니다.


### Retrieving information

이제 비중을 가져오는 방법을 제공하여 **Graphable** 을 마무리 지어보겠습니다.

![graph_retrieving](/images/graph_retrieving.png)

Singapore 에서 Hong Kong으로 가는 비행기는 얼마입니까?

다음과 같은 코드를 만들어 계산해 보겠습니다.

```Swift
public func weight(from source: Vertex<Element>, to destination: Vertex<Element>) -> Double? {
  guard let edges = adjacencyDict[source] else { // 1
    return nil
  }

  for edge in edges { // 2
    if edge.destination == destination { // 3
      return edge.weight
    }
  }

  return nil // 4
}
```

1. **source** 의 모서리를 모두 가지고 옵니다. 없을경우 **nil** 값을 반환합니다.

2. 모든 모서리를 루프를 돌립니다.

3. 모서리의 도착지가 찾는 도착지인지 확인합니다.

4. 없을 겨우 **nil** 값을 반환합니다.

```Swift
public func edges(from source: Vertex<Element>) -> [Edge<Element>]? {
  return adjacencyDict[source]
}
```

**edges(from:)** 는 간단합니다. 지정된 꼭지점을 기반으로 사전에 액세스 하고 모서리 배열을 반환합니다.

퍼즐의 마지막 부분은 인접 목록을 시각화하는 것입니다. **Graphable** 프로토콜을 수행하기 위한 최종 메소드를 작성해야합니다.


## Visualizing the adjacency list

```Swift
public var description: CustomStringConvertible {
  var result = ""
  for (vertex, edges) in adjacencyDict {
    var edgeString = ""
    for (index, edge) in edges.enumerated() {
      if index != edges.count - 1 {
        edgeString.append("\(edge.destination), ")
      } else {
        edgeString.append("\(edge.destination)")
      }
    }
    result.append("\(vertex) ---> [ \(edgeString) ] \n ")
  }
  return result
}
```

**description** 속성은 모든 dictionary 값을 지나면서 인쇄합니다.


## Testing out the Adjacency List

![graph_weight](/images/graph_weight.png)

다음 그래프를 작성해 보겠습니다.

```Swift
import UIKit
import XCPlayground

let adjacencyList = AdjacencyList<String>()

let singapore = adjacencyList.createVertex(data: "Singapore")
let tokyo = adjacencyList.createVertex(data: "Tokyo")
let hongKong = adjacencyList.createVertex(data: "Hong Kong")
let detroit = adjacencyList.createVertex(data: "Detroit")
let sanFrancisco = adjacencyList.createVertex(data: "San Francisco")
let washingtonDC = adjacencyList.createVertex(data: "Washington DC")
let austinTexas = adjacencyList.createVertex(data: "Austin Texas")
let seattle = adjacencyList.createVertex(data: "Seattle")

adjacencyList.add(.undirected, from: singapore, to: hongKong, weight: 300)
adjacencyList.add(.undirected, from: singapore, to: tokyo, weight: 500)
adjacencyList.add(.undirected, from: hongKong, to: tokyo, weight: 250)
adjacencyList.add(.undirected, from: tokyo, to: detroit, weight: 450)
adjacencyList.add(.undirected, from: tokyo, to: washingtonDC, weight: 300)
adjacencyList.add(.undirected, from: hongKong, to: sanFrancisco, weight: 600)
adjacencyList.add(.undirected, from: detroit, to: austinTexas, weight: 50)
adjacencyList.add(.undirected, from: austinTexas, to: washingtonDC, weight: 292)
adjacencyList.add(.undirected, from: sanFrancisco, to: washingtonDC, weight: 337)
adjacencyList.add(.undirected, from: washingtonDC, to: seattle, weight: 277)
adjacencyList.add(.undirected, from: sanFrancisco, to: seattle, weight: 218)
adjacencyList.add(.undirected, from: austinTexas, to: sanFrancisco, weight: 297)

adjacencyList.description
```
