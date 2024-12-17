import Parsing

struct MapParser<TileType: CaseIterable>: Parser
where TileType: RawRepresentable, TileType.RawValue == String {
    var body: some Parser<Substring, [[TileType]]> {
        Many {
            Many {
                TileType.parser()
            }
        } separator: {
            "\n"
        } terminator: {
            Optionally { "\n" }
        }
    }
}
