import XCTest
@testable import Parse

final class RecursiveParserTests: XCTestCase {
    typealias SexpParser = CharacterParser.Map<Sexp>
    indirect enum Sexp : Equatable {
        case atom(String)
        case list([Sexp])

        static let atom: SexpParser = { .atom(String($0)) }
            <^> CharacterParser.letter.many1

        static var parser: SexpParser {
            let open = CharacterParser.character(in: "(")
            let space = CharacterParser.whitespaceOrNewline
            let close = CharacterParser.character(in: ")")

            let expr = atom <|> .lazy(self.parser)

            let list: SexpParser = curry { .list([$0] + $1) }
                <^> open *> expr <*> (space *> expr).many <* close

            return atom <|> list
        }

        static let parse = parser.parse
    }

    func testAtom() {
        let (result, _) = Sexp.parse("foo")!

        XCTAssertEqual(result, .atom("foo"))
    }

    func testListAtom() {
        let (result, _) = Sexp.parse("(foo)")!

        XCTAssertEqual(result, .list([.atom("foo")]))
    }

    func testAtoms() {
        let (result, _) = Sexp.parse("(foo bar)")!

        XCTAssertEqual(result, .list([.atom("foo"), .atom("bar")]))
    }

    func testNested() {
        let (result, _) = Sexp.parse("((foo (bar)) baz)")!

        XCTAssertEqual(result, .list([.list([.atom("foo"),
                                             .list([.atom("bar")])]),
                                      .atom("baz")]))
    }

    // MARK: - List of all tests
    let allTests = [
        "testAtom": testAtom,
        "testListAtom": testListAtom,
        "testAtoms": testAtoms,
        "testNested": testNested,
    ]
}
