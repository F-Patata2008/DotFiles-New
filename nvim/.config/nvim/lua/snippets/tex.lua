local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  -- Snippet 1: Basic LaTeX article in Spanish
  s("Documento", fmt([[
\documentclass[11pt]{{article}}
\usepackage[spanish]{{babel}}
\usepackage{{amsmath}}  % Math
\usepackage{{amssymb}}  % Symbols
\usepackage{{graphicx}} % Images
\graphicspath{{ {{./images/}}}}
\usepackage[utf8]{{inputenc}}
\usepackage[T1]{{fontenc}}
\usepackage[margin=1in]{{geometry}}

\title{{{}}}
\author{{{}}}
\date{{\today}}

\begin{{document}}

\maketitle

{}

\end{{document}}
  ]], {
    i(1, "Tu Título"),
    i(2, "Tu Nombre"),
    i(0, "Empieza a escribir aquí..."),
  })),
}
