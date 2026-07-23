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

  -- Snippet "Papa" sin test cases
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
    "Segment-Tree",
    {
      t({
        "struct SegmentTree {",
        "    int n;",
        "    vec<ll> Tree;",
        "",
        "    SegmentTree(vec<ll>& a) {",
        "        n = a.size();",
        "        Tree.resize(4 * n);",
        "        build(a, 0, 0, n - 1);",
        "    }",
        "",
        "    void build(vec<ll>& a, int nodo, int izq, int der) {",
        "        if (izq == der) {",
        "            Tree[nodo] = a[izq];",
        "            return;",
        "        }",
        "        int mid = izq + (der - izq) / 2;",
        "        build(a, 2 * nodo + 1, izq, mid);",
        "        build(a, 2 * nodo + 2, mid + 1, der);",
        "        Tree[nodo] = min(Tree[2 * nodo + 1], Tree[2 * nodo + 2]);",
        "    }",
        "",
        "    ll query(int nodo, int izq, int der, int l, int r) {",
        "        if (r < izq || l > der) return LLONG_MAX;",
        "        if (l <= izq && der <= r) return Tree[nodo];",
        "        int mid = izq + (der - izq) / 2;",
        "        return min(query(2 * nodo + 1, izq, mid, l, r),",
        "                   query(2 * nodo + 2, mid + 1, der, l, r));",
        "    }",
        "};",
      }),
    },
    {
      description = "Segment Tree (Min Query)",
    }
  ),

  s(
  "kmp",
  {
    t({
      "vector<ll> prefix_function(const string &s) {",
      "    int n = s.size();",
      "    vector<ll> pi(n, 0);",
      "    for (int i = 1; i < n; i++) {",
      "        int j = pi[ i - 1 ];",
      "        while (j > 0 && s[ i ] != s[ j ])",
      "            j = pi[ j - 1 ];",
      "        if (s[ i ] == s[ j ])",
      "            j++;",
      "        pi[ i ] = j;",
      "    }",
      "    return pi;",
      "}",
    }),
  },
  {
    description = "KMP Prefix Function",
  }
),

  s(
    "for",
    {
      t("for (int i = 0; i < n; i++) {"),
      i(0),
      t("}"),
    },
    {
      description = "For loop template",
    }
  ),
}
