local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

-- Function to create the symbolic link.
-- It will only run if an 'images' directory or link doesn't already exist.
local function create_symlink()
  -- The command to be executed.
  -- It checks if 'images' exists, and if not, creates the symlink.
  local cmd = "test -e images || ln -s ~/Apunte/images/ ./images"
  -- Execute the command silently.
  os.execute(cmd)
  -- This function should not insert any text, so return an empty string.
  return ""
end

return {
  s("Documento", fmt([[
\documentclass[11pt]{{article}}
\usepackage[spanish]{{babel}}
\usepackage{{amsmath}}  % Math
\usepackage{{amssymb}}  % Symbols
\usepackage{{graphicx}} % Images
% Updated graphicspath to search local './images/' first, then the central library.
\graphicspath{{ {{./images/}}, {{~/Apunte/images/}} }}
\usepackage[utf8]{{inputenc}}
\usepackage[T1]{{fontenc}}
\usepackage[margin=1in]{{geometry}}
\usepackage{{fancyhdr}} % Para el pie de página personalizado
\usepackage{{hyperref}} % Para metadatos y enlaces en el PDF

% ----- CONFIGURACIÓN DE AUTORÍA Y PIE DE PÁGINA -----
\hypersetup{{
    pdftitle={{{}}},
    pdfauthor={{{}}},
    colorlinks=true,
    linkcolor=black,
    urlcolor=cyan
}}

% Configuración del pie de página con fancyhdr
\pagestyle{{fancy}}
\fancyhf{{}} % Limpia la cabecera y el pie de página actuales
\fancyfoot[C]{{\footnotesize Felipe Colli, Todos los Derechos Reservados}} % Tu texto en el centro
\fancyfoot[R]{{\thepage}} % Número de página a la derecha
\renewcommand{{\headrulewidth}}{{0pt}} % Elimina la línea de la cabecera

\title{{{}}}
\author{{{}}}
\date{{\today}}

\begin{{document}}

\maketitle
\thispagestyle{{fancy}} % Aplica el estilo de pie de página a la primera página también

{}

\end{{document}}
{}
]], {
    -- Nodos para fmt, en orden de aparición en el texto de arriba:
    i(1, "Tu Título"),      -- 1. Usado para pdftitle
    i(2, "Felipe Colli Olea"),      -- 2. Usado para pdfauthor
    i(1, "Tu Título"),      -- 3. Usado para \title (reutiliza el nodo 1)
    i(2, "Felipe Colli Olea"),      -- 4. Usado para \author (reutiliza el nodo 2)
    i(0, "Empieza a escribir aquí..."), -- 5. Posición final del cursor
    f(create_symlink) -- 6. This is the new node that runs our function
  })),
}
