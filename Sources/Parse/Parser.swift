//
//  Parser.swift
//  
//
//  Created by Calle Englund on 2019-11-09.
//

import Foundation
import Runes

public struct Parser<Result, Input: Collection> {
    public typealias Remainder = Input.SubSequence

    public let parse: (Remainder) -> (Result, Remainder)?
}

// MARK: - Wildcard parser

extension Parser where Result == Input.Element {
    /// Returns a Parser that matches any Input Element
    public static var any: Parser {
        return Parser { input in
            guard let item = input.first else { return nil }

            return (item, input.dropFirst(1))
        }
    }
}

// MARK: - Parser combinators

extension Parser {
    public typealias Map<T> = Parser<T, Input>
    public typealias Many = Map<[Result]>
    public typealias Optional = Map<Result?>

    /// Returns a new Parser that matches any repetition of itself
    public var many: Many {
        return Many { input in
            var result: [Result] = []
            var remainder = input
            while let (partial, newRemainder) = self.parse(remainder) {
                result.append(partial)
                remainder = newRemainder
            }
            return (result, remainder)
        }
    }

    /// Returns a new Parser that matches at least one repetition of itself
    public var many1: Many {
        return curry { [$0] + $1 } <^> self <*> self.many
    }

    /// Returns a new Parser that matches zero repetitions of iself
    public var none: Many {
        return Many { input in
            if let (_, _) = self.parse(input) { return nil }

            return ([], input)
        }
    }

    public static func not(_ parser: Parser) -> Optional {
        return Optional { input in
            if let (_, _) = parser.parse(input) { return nil }

            return (nil, input)
        }
    }

    /// Returns a new Parser that matches zero, or one repetition of iself
    public var optional: Optional {
        return Optional { input in
            guard let (result, remainder) = self.parse(input)
                else { return (nil, input) }

            return (result, remainder)
        }
    }

    /// Returns a new Parser that transforms its parse Result
    ///
    /// A parser that parses a sequence of digits into an Int:
    ///
    ///     CharacterParser.character(.digit).many1.map { Int(String($0))! }
    ///
    /// - Parameter transform: closure that transforms the parse result.
    /// - Returns: a `Parser` that transforms its `Result` into `T`
    public func map<T>(_ transform: @escaping (Result) -> T) -> Map<T> {
        return Map<T> { input in
            guard let (result, remainder) = self.parse(input) else { return nil }

            return (transform(result), remainder)
        }
    }

    /// Returns a new Parser that matches the concatenation with another Parser
    ///
    /// - Parameter other: the concatenated parser
    /// - Returns: a `Parser` that concatenates two parsers
    public func followed<T>(by other: Map<T>) -> Map<(Result, T)> {
        return Map<(Result, T)> { input in
            guard let (res1, input) = self.parse(input) else { return nil }
            guard let (res2, remainder) = other.parse(input) else { return nil }

            return ((res1, res2), remainder)
        }
    }

    /// Returns a new Parser that tries another Parser if this one fails
    ///
    /// - Parameter other: the alternative parser
    /// - Returns: a `Parser` that  tries another it it fails
    public func or(_ other: Parser) -> Parser {
        return Parser { input in
            return self.parse(input) ?? other.parse(input)
        }
    }
}

// MARK: - Currying

public func curry<A,B,R>(_ f: @escaping (A,B)->R) -> (A)->(B)->R {
    return { a in { b in f(a,b) }}
}

public func curry<A,B,C,R>(_ f: @escaping (A,B,C)->R) -> (A)->(B)->(C)->R {
    return { a in { b in { c in f(a,b,c) }}}
}

public func curry<A,B,C,D,R>(_ f: @escaping (A,B,C,D)->R) -> (A)->(B)->(C)->(D)->R {
    return { a in { b in { c in { d in f(a,b,c,d) }}}}
}

// MARK: - Parser runes

infix operator <^>: RunesApplicativePrecedence
public func <^> <A,B,I>(lhs: @escaping (A)->B, rhs: Parser<A,I>) -> Parser<B,I> {
    rhs.map(lhs)
}

infix operator <*>: RunesApplicativePrecedence
public func <*> <A,B,I>(lhs: Parser<(A)->B,I>, rhs: Parser<A,I>) -> Parser<B,I> {
    lhs.followed(by: rhs).map { (f, x) in f(x) }
}

infix operator <*: RunesApplicativeSequencePrecedence
public func <* <A,B,I>(lhs: Parser<A,I>, rhs: Parser<B,I>) -> Parser<A,I> {
    {a in {_ in a}} <^> lhs <*> rhs
}

infix operator *>: RunesApplicativeSequencePrecedence
public func *> <A,B,I>(lhs: Parser<A,I>, rhs: Parser<B,I>) -> Parser<B,I> {
    {_ in {b in b}} <^> lhs <*> rhs
}

infix operator <|>: RunesAlternativePrecedence
public func <|> <A,I>(lhs: Parser<A,I>, rhs: Parser<A,I>) -> Parser<A,I> {
    lhs.or(rhs)
}

postfix operator <?
public postfix func <? <A,I>(lhs: Parser<A,I>) -> Parser<A?,I> {
    lhs.optional
}
