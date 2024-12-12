import Collections
import Foundation
import Parsing

struct Day12: Solvable {
    let map: [[Character]]

    init(input: String) {
        self.map = input.split(separator: "\n").map { $0.map { $0 } }
    }

    func computeRegions() -> [OrderedSet<Point>] {
        var seen = Set<Point>()
        var regions = [OrderedSet<Point>]()
        for (point, plot) in map.points() {
            guard seen.insert(point).inserted else { continue }

            var region = OrderedSet<Point>([point])
            var queue = Deque<Point>()
            let neighbors: (Point) -> [Point] = { around in
                Direction.allCardinal.map { around &+ $0.vector }.filter {
                    map.containsPoint($0) && map[$0] == plot
                }
            }
            var area = 1
            var perimeter = 4
            for neighbor in neighbors(point) {
                queue.append(neighbor)
                seen.insert(neighbor)
                region.append(neighbor)
                perimeter -= 1
            }

            while !queue.isEmpty {
                let currentPoint = queue.removeFirst()
                let currentNeighbors = neighbors(currentPoint)
                area += 1
                perimeter += (4 - currentNeighbors.count)
                for neighbor in currentNeighbors {
                    if seen.insert(neighbor).inserted {
                        queue.append(neighbor)
                    }
                    region.append(neighbor)
                }
            }

            regions.append(region)
        }

        return regions
    }

    func solvePart1() async -> Int {
        let regions = computeRegions()
        return regions.reduce(0) { totalPrice, region in
            let area = region.count
            let perimeter = region.reduce(0) { (sum, point) in
                let neighbors = Direction.allCardinal.map { point &+ $0.vector }.filter {
                    region.contains($0)
                }
                return sum + (4 - neighbors.count)
            }
            return totalPrice + area * perimeter
        }
    }

    func calculateSides(forRegion region: OrderedSet<Point>)
        -> Int
    {
        var checkedCorners = Set<PointF>()
        return region.map { point in
            let corners = Direction.allDiagonal.map {
                (
                    $0,
                    map.pointsSurrounding(point, corner: $0)
                        .filter { region.contains($0) }
                )
            }
            return corners.map { (direction, corner) in
                switch corner.count {
                case 1: return 1  // Exterior
                case 2:
                    let delta = corner[0] &- corner[1]
                    if delta.equivalentDirection().isDiagonal {
                        return 1  // Exterior
                    } else {
                        return 0  // They are next to each other - no corner
                    }
                case 3: return checkedCorners.insert(point.corner(in: direction)).inserted ? 1 : 0  // Exterior - only count once
                case 4: return 0  // Interior - surrounded by others of the region
                default:
                    fatalError("Invalid number of corners for \(corner)")
                }
            }.reduce(0, +)
        }.reduce(0, +)
    }

    func solvePart2() async -> Int {
        let regions = computeRegions()
        return regions.reduce(0) { totalPrice, region in
            let area = region.count
            let sides = calculateSides(forRegion: region)
            return totalPrice + area * sides
        }
    }
}
