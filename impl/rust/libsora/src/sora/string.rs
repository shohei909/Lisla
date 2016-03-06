// ===============================================================================
// String Util
// ===============================================================================

pub trait Trim {
    fn trim(self) -> String;
}

impl Trim for Vec<(String, i64)> {
    #[inline]
    fn trim(self) -> String {
        let mut string = String::new();

        for (line, _) in self {
            string.push_str(&line);
        }

        string
    }
}
