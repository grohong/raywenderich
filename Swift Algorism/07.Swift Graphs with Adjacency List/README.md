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
