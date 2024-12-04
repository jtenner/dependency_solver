import gleam/list
import gleam/int
import gleam/io
import gleam/order.{type Order}
import gleam/result
import gleamy/map.{type Map}
import gleamy/set.{type Set}
import primes

pub opaque type DependencyGraph(element) {
  DependencyGraph(
    running_index: Int,
    index_by_node: Map(element, Int),
    index_by_id: Map(Int, element),
    dependencies: Map(Int, Int),
    dependents: Map(Int, Int),
  )
}

pub fn dependency_graph_new(
  compare: fn(element, element) -> Order,
) -> DependencyGraph(element) {
  DependencyGraph(
    running_index: 0,
    index_by_node: map.new(compare),
    index_by_id: map.new(int.compare),
    dependencies: map.new(int.compare),
    dependents: map.new(int.compare),
  )
}

pub fn dependency_graph_add(graph: DependencyGraph(element), node: element) {
  let DependencyGraph(running_index, index_by_node, index_by_id, ..) = graph

  case map.has_key(index_by_node, node) {
    True -> graph
    False -> {
      let new_index = running_index + 1
      let prime_index = primes.get_prime(running_index)
      let index_by_node = map.insert(index_by_node, node, prime_index)
      let index_by_id = map.insert(index_by_id, prime_index, node)
      DependencyGraph(
        ..graph,
        running_index: new_index,
        index_by_node: index_by_node,
        index_by_id: index_by_id,
      )
    }
  }
}

fn add_to_index(index: Map(Int, Int), key: Int, element: Int) {
  case map.get(index, key) {
    Ok(value) if value % element == 0 -> index
    Ok(value) -> map.insert(index, key, value * element)
    Error(_) -> map.insert(index, key, element)
  }
}

fn add_edge(graph: DependencyGraph(element), from: element, to: element) {
  let assert Ok(from_id) = map.get(graph.index_by_node, from)
  let assert Ok(to_id) = map.get(graph.index_by_node, to)
  DependencyGraph(
    ..graph,
    dependencies: add_to_index(graph.dependencies, from_id, to_id),
    dependents: add_to_index(graph.dependents, to_id, from_id),
  )
}

pub fn dependency_graph_add_dependency(
  graph: DependencyGraph(element),
  element to: element,
  depends_on from: element,
) {
    graph
    |> dependency_graph_add(from)
    |> dependency_graph_add(to)
    |> add_edge(from, to)
}

pub type SolveGroup(element) {
  SolveGroupKindSingle(element)
  SolveGroupKindRecursive(Set(element))
}

pub type SolvedList(element) = List(SolveGroup(element))

type DependencyGroup {
  DependencyGroup(
    elements: Int,
  )
}

pub type RecursiveGroup(element) {
  RecursiveGroup(
    elements: List(element)
  )
}

// instuructions to solve
// 1. start with first item
// 2. traverse dependencies and add each one to "seen" int
// 3. add each dependency to the "path" int
// 4. if first item found anywhere, add the "path" to the "cycles" list

// nodes: List(#(element, Int))
// edge_dependencies: Map(Int, Int)
// path: Int
// seen: Int
// cycles: List(Int)

fn add_to_set(the_set: Int, element: Int) {
  case the_set {
    0 -> element
    n if n % element == 0 -> the_set
    n -> n * element
  }
}

fn do_get_graph_cycles(nodes: List(#(element, Int)), edge_dependencies: Map(Int, Int), cycles: List(Int)) {
  let cycles = case nodes {
    [] -> []
    [node] -> [node.1]
    [] -> 
  }
}


pub fn solve_dependency_order(graph: DependencyGraph(element)) {
  let DependencyGraph(
    running_index,
    index_by_node,
    index_by_id,
    dependencies,
    dependents,
  ) = graph

  let nodes = map.to_list(graph.index_by_node)
  use cycles <- try(get_graph_cycles(nodes, dependencies))

}

pub fn main() {
  todo
}
