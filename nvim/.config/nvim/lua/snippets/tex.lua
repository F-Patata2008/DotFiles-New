local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

-- ===== HELPER FUNCTIONS (reusable for multiple snippets) =====

-- Function to create the symbolic link to the central images folder.
local function create_symlink()
  os.execute("test -e images || ln -s ~/Apunte/images/ ./images")
  return "" -- This function inserts no text
end

-- Function to create an empty bibliography file.
local function create_bib_file()
  os.execute("test -e bibliografia.bib || touch bibliografia.bib")
  return "" -- This function inserts no text
end

-- NEW: A single function to call both setup functions.
-- This solves the "Unused argument" error.
local function setup_project_files()
  create_symlink()
  create_bib_file()
  return ""
end


-- ===== SNIPPETS =====

return {
  -- Snippet 1: Your original "Documento" snippet (corrected)
  s("Documento", fmt([[
\documentclass[11pt]{{article}}
\usepackage[spanish]{{babel}}
\usepackage{{amsmath}}
\usepackage{{amssymb}}
\usepackage{{graphicx}}
\graphicspath{{ {{./images/}}, {{~/Apunte/images/}} }}
\usepackage[utf8]{{inputenc}}
\usepackage[T1]{{fontenc}}
\usepackage[margin=1in]{{geometry}}
\usepackage{{fancyhdr}}
\usepackage{{hyperref}}

\hypersetup{{
    pdftitle={{{}}},
    pdfauthor={{{}}},
    colorlinks=true,
    linkcolor=black,
    urlcolor=cyan
}}

\pagestyle{{fancy}}
\fancyhf{{}}
\fancyfoot[C]{{\footnotesize Felipe Colli, Todos los Derechos Reservados}}
\fancyfoot[R]{{\thepage}}
\renewcommand{{\headrulewidth}}{{0pt}}

\title{{{}}}
\author{{{}}}
\date{{\today}}

\begin{{document}}

\maketitle
\thispagestyle{{fancy}}

{}

\end{{document}}
{}
]], {
    i(1, "Tu Título"),
    i(2, "Felipe Colli Olea"),
    i(1), -- Reuses node 1
    i(2), -- Reuses node 2
    i(0, "Empieza a escribir aquí..."),
    f(create_symlink), -- Only one function, so it's fine here
  })),


}
