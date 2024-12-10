import Collections
import Parsing

private struct Day10Parser: Parser {
    var body: some Parser<Substring, [[Int]]> {
        Many {
            Many {
                OneOf {
                    Digits(1)
                    ".".map { _ in 99 }
                }
            }
        } separator: {
            "\n"
        }
    }
}

private struct TrailPosition<T: SetLike> {
    let point: Point
    let trailhead: Point
    let visitedForTrailhead: T
}

struct Day10: Solvable {
    let map: [[Int]]
    let trailheads: [Point]

    init(input: String) {
        self.map = try! Day10Parser().parse(input)
        self.trailheads = map.points().filter { $0.1 == 0 }.map { $0.0 }
    }

    private func destinations<T: SetLike>(for trailheads: [Point], makeVisited: () -> T) -> [Point:
        [Point]]
    where T.Element == Point {
        var queue = Deque<TrailPosition<T>>()
        queue.append(
            contentsOf: self.trailheads.map { pos in
                TrailPosition(point: pos, trailhead: pos, visitedForTrailhead: makeVisited())
            })
        var destinationsByTrailhead = Dictionary(
            uniqueKeysWithValues: self.trailheads.map { ($0, [Point]()) })

        while !queue.isEmpty {
            let pos = queue.removeFirst()
            var visited = pos.visitedForTrailhead
            let point = pos.point
            let trailhead = pos.trailhead

            guard visited.insert(point).inserted else { continue }
            guard let height = self.map[point] else { continue }

            if height == 9 {
                destinationsByTrailhead[trailhead, default: []].append(point)
                continue
            }

            queue.append(
                contentsOf: Direction.allCardinal.map { $0.vector &+ point }.filter {
                    map[$0] == .some(height + 1)
                }.map {
                    TrailPosition(point: $0, trailhead: trailhead, visitedForTrailhead: visited)
                })
        }
        return destinationsByTrailhead
    }

    func solvePart1() async -> Int {
        return destinations(for: self.trailheads, makeVisited: { Box(Set([])) }).values.map {
            $0.count
        }
        .reduce(0, +)
    }

    func solvePart2() async -> Int {
        return destinations(for: self.trailheads, makeVisited: { Set([]) }).values.map {
            $0.count
        }.reduce(0, +)
    }
}
