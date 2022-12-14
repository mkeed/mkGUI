pub const KeyCode = enum { A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z, Home, Insert, Delete, End, PgUp, PgDn, F0, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, F13, F14, F15, F16, F17, F18, F19, F20, Up, Down, Left, Right, At, LeftBracket, Backslash, RightBracket, Caret, Backtick, Ins, Del, Win, Apps, Space, Exclamation, DoubleQuote, SingleQuote, Hash, Dollar, Percent, Ambersand, OpenParen, CloseParen, Asterisk, Comma, Hyphen, Dot, ForwardSlash, Zero, One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Colon, SemiColon, LeftAngle, RightAngle, Equal, QuestionMark, OpenBracket, CloseBracket, OpenBrace, CloseBrace, Pipe, Tilde, Add, Minus, Underscore, Esc, Enter, Tab };

pub const KeyboardEvent = struct {
    ctrl: bool = false,
    shift: bool = false,
    alt: bool = false,
    key: KeyCode,
};
