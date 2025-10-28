package main

import "core:fmt"
import "core:slice"
import "core:unicode"

Token :: struct {
    kind: string,
    value: string,
}

is_whitespace :: proc(c: rune) -> bool {
    return c == ' ' || c == '\t' || c == '\n' || c == '\r'
}
// Helper: convert rune to string
rune_to_string :: proc(r: rune) -> string {
    buf: [4]u8
    n := utf8.encode_rune(buf[:], r)
    return string(buf[:n])
}

is_punctuation :: proc(c: rune) -> bool {
    punctuations : []rune =  { '.',',', ';', '(', ')', '{', '}', '[', ']', '+', '-', '*', '/', '=', '<', '>' }
    for p in punctuations {
        if c == p {
            return true
        }
    }
    return false
}

tokenize :: proc(input: string) -> []Token {
    tokens: []Token = make([]Token, 0)
    start := 0
    i := 0
    length := len(input)

    for i < length {
        c := rune(input[i])

        if is_whitespace(c) {
            i += 1
            start = i
            continue
        }

        if is_punctuation(c) {
            tok := Token{kind = "punctuation", value = string(c)}
            append(&tokens, tok)
            i += 1
            start = i
            continue
        }

        // Otherwise, parse an identifier or number
        start = i
        for i < length {
            c = rune(input[i])
            if is_whitespace(c) || is_punctuation(c) {
                break
            }
            i += 1
        }
        tokens = append(tokens, Token{kind = "identifier", value = input[start:i]})
        start = i
    }

    return tokens
}

main :: proc() {
    input := "var x = 42 + y;"
    tokens := tokenize(input)
    for t in tokens {
        fmt.println("Kind: ", t.kind, ", Value: '", t.value, "'")
    }
}
