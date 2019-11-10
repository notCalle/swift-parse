//
//  CharacterParser.swift
//  
//
//  Created by Calle Englund on 2019-11-10.
//

import Foundation

/// Alias for a parser from substrings to characters
///
/// Includes parser proxies for all predefined `CharacterSet`s, for example:
///
///     let word = CharacterParser.letter.many1.map{String($0)}
///     let (cats, _) = word.parse("cats and dogs")
///
/// - See also:
/// [CharacterSet](https://developer.apple.com/documentation/foundation/characterset)
public typealias CharacterParser = Parser<Character, Substring>

extension CharacterParser {
    /// Returns a CharacterParser that matches a Character, for which the given closure returns true.
    ///
    /// This example uses `character(matching:)` to test that a string starts with a `1`.
    ///
    ///     let one = CharacterParser.character { $0 == "1" }
    ///     let (result, _) = one.parse("1") // result == "1"
    ///
    /// - Parameter condition: a closure `(Character)->Bool`, returning `true` if a
    ///             character matches
    /// - Returns: a `CharacterParser` that matches with a closure
    public static func character(matching condition: @escaping (Character) -> Bool)
        -> CharacterParser
    {
        return CharacterParser { input in
            guard let char = input.first, condition(char) else { return nil }

            return (char, input.dropFirst(1))
        }
    }

    /// Returns a CharacterParser that matches the given character
    ///
    /// This example uses `character(_:)` to test that a string starts with a `1`.
    ///
    ///     let one = CharacterParser.character("1")
    ///     let (result, _) = one.parse("1") // result == "1"
    ///
    /// - Parameter match: the `Character` to match with
    /// - Returns: a `CharacterParser` that matches the given character
    public static func character(_ match: Character) -> CharacterParser {
        return .character(matching: { $0 == match})
    }
}

// MARK: - Character set proxies

extension CharacterSet {
    /// Returns a Boolean value that indicates whether a unicode scalar, matching the
    /// given character element ,exists in the character set.
    /// - Parameter member: An element whose unicode scalar representation to look for in the set
    /// - Returns: `true` if `member` has a unicode scalar in the set; otherwise, `false`
    public func contains(_ member: Character) -> Bool {
        let scalars = String(member).unicodeScalars
        guard let scalar = scalars.first else { return false }

        return contains(scalar)
    }
}

extension CharacterParser {
    /// Returns a CharacterParser that matches a Character, that has a unicode scalar member
    /// in the given CharacterSet.
    ///
    /// This example uses `character(in:)` to test that a string starts with a digit.
    ///
    ///     let digit = CharacterParser.character(in: .digit)
    ///     let (result, _) = digit.parse("1") // result == "1"
    ///
    /// - Parameter characterSet: CharacterSet to match with
    /// - Returns: a `CharacterParser` that matches with a CharacterSet
    /// - See also:
    /// [CharacterSet](https://developer.apple.com/documentation/foundation/characterset)
    public static func character(in characterSet: CharacterSet) -> CharacterParser {
        .character(matching: characterSet.contains)
    }

    /// Returns a CharacterParser that matches alphanumeric characters, Unicode General
    /// Categories L*, M*, and N*.
    public static let alphanumeric: CharacterParser =
        .character(in: .alphanumerics)
    /// Returns a CharacterParser that matches capitalized letters, Unicode General Category Lt
    public static let capitalizedLetter: CharacterParser =
        .character(in: .capitalizedLetters)
    /// Returns a CharacterParser that matches control characters, Unicode General Category Cc and Cf
    public static let control: CharacterParser =
        .character(in: .controlCharacters)
    /// Returns a CharacterParser that matches characters in the category Decimal Numbers
    public static let digit: CharacterParser =
        .character(in: .decimalDigits)
    /// Returns a CharacterParser that matches Unicode characters that can be decomposed
    public static let decomposable: CharacterParser =
        .character(in: .decomposables)
    /// Returns a CharacterParser that matches undefined Unicode characters
    public static let illegal: CharacterParser =
        .character(in: .illegalCharacters)
    /// Returns a CharacterParser that matches letters, Unicode General Category L* & M*
    public static let letter: CharacterParser =
        .character(in: .letters)
    /// Returns a CharacterParser that matches lowercase letters, Unicode General Category Ll
    public static let lowercaseLetter: CharacterParser =
        .character(in: .lowercaseLetters)
    /// Returns a CharacterParser that matches line-ending characters
    public static let newline: CharacterParser =
        .character(in: .newlines)
    /// Returns a CharacterParser that matches characters in Unicode General Category M*
    public static let nonBase: CharacterParser =
        .character(in: .nonBaseCharacters)
    /// Returns a CharacterParser that matches punctuation characters, Unicode General Category P*
    public static let punctuation: CharacterParser =
        .character(in: .punctuationCharacters)
    /// Returns a CharacterParser that matches symbols, Unicode General Category S*
    public static let symbol: CharacterParser =
        .character(in: .symbols)
    /// Returns a CharacterParser that matches uppercase letters, Unicode General Category Lu, Lt
    public static let uppercaseLetter: CharacterParser =
        .character(in: .uppercaseLetters)
    /// Returns a CharacterParser that matches whitespace, Unicode General Category Zs, and
    /// the `TAB` control character.
    public static let whitespace: CharacterParser =
        .character(in: .whitespaces)
    /// Returns a CharacterParser that matches `.whitespace` or `.newline`
    public static let whitespaceOrNewline: CharacterParser =
        .character(in: .whitespacesAndNewlines)
    /// Returns a CharacterParser that matches a valid URL fragment component
    public static let urlFragment: CharacterParser =
        .character(in: .urlFragmentAllowed)
    /// Returns a CharacterParser that matches a valid URL host subcomponent
    public static let urlHost: CharacterParser =
        .character(in: .urlHostAllowed)
    /// Returns a CharacterParser that matches a valid URL password subcomponent
    public static let urlPassword: CharacterParser =
        .character(in: .urlPasswordAllowed)
    /// Returns a CharacterParser that matches a valid URL path component
    public static let urlPath: CharacterParser =
        .character(in: .urlPathAllowed)
    /// Returns a CharacterParser that matches a valid URL query component
    public static let urlQuery: CharacterParser =
        .character(in: .urlQueryAllowed)
    /// Returns a CharacterParser that matches a valid URL user subcomponent
    public static let urlUser: CharacterParser =
        .character(in: .urlUserAllowed)
}

// MARK: - String character set proxy

extension CharacterParser {
    /// Returns a CharacterParser that matches a Character, that exists in the given String.
    ///
    /// This example uses `character(in:)` to test that a string starts with a valid sign.
    ///
    ///     let sign = CharacterParser.character(in: "+-")
    ///     let (result, _) = sign.parse("-1") // result == "-"
    ///
    /// - Parameter string: String to match with
    /// - Returns: a `CharacterParser` that matches with a String
    public static func character(in string: String) -> CharacterParser {
        .character(in: CharacterSet(charactersIn: string))
    }
}
