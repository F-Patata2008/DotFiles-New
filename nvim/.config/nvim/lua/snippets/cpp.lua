local ls = require("luasnip")
local s = ls.s
local i = ls.i
local t = ls.t

return {
  s(
    "Patata",
    {
      t({
        "#include <bits/stdc++.h>",
        "using namespace std;",
        "",
        "typedef long long ll;",
        "typedef string str;",
        "#define vec vector",
        "",
        "int main() {",
        "    int t;",
        "    cin >> t;",
        "    while (t--) {",
        "        ",
      }),
      i(0), -- cursor inside while loop
      t({
        "",
        "    }",
        "    return 0;",
        "}",
      }),
    },
    {
      description = "Competitive Programming Template (With test cases)",
    }
  ),

  -- New snippet "Papa" without test cases
  s(
    "Papa",
    {
      t({
        "#include <bits/stdc++.h>",
        "using namespace std;",
        "",
        "typedef long long ll;",
        "typedef string str;",
        "#define vec vector",
        "",
        "int main() {",
        "    ",
      }),
      i(0), -- cursor inside main
      t({
        "",
        "    return 0;",
        "}",
      }),
    },
    {
      description = "Competitive Programming Template (Without test cases)",
    }
  ),
    s(
        "for",
        {
            t({
                "for (int i = 0; i < n; i++) {",
            }),
                i(0),
                t({"}"
            })
        }
    )
}
