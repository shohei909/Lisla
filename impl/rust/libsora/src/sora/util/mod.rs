pub fn is_blacklisted_whitespace(character: char) -> bool {
    match character {
        '\u{000B}' |
        '\u{000C}' |
        '\u{0085}' |
        '\u{00A0}' |
        '\u{1680}' |
        '\u{2000}'...'\u{200A}' |
        '\u{2028}' |
        '\u{2029}' |
        '\u{202F}' |
        '\u{205F}' |
        '\u{3000}' => true,
        _ => false,
    }
}

pub fn is_whitespace(character: char) -> bool {
    match character {
        ' ' | '\t' => true,
        _ => false,
    }
}
