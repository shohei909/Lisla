
#[macro_export]
macro_rules! array_tree {
    ($x:expr) => {
        $crate::tag::WithTag {
            data: $crate::tree::ArrayTree::Leaf(
                $crate::leaf::StringLeaf {
                    string : $x.to_string()
                }
            ),
            tag: $crate::tag::Tag::empty(),
        }
    }
}
