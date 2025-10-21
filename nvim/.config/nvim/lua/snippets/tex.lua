local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

-- ===== HELPER FUNCTIONS (reusable for multiple snippets) =====

-- Function to create the symbolic link to the central images folder.
-- It only runs if an 'images' directory or link doesn't already exist.
local function create_symlink()
  os.execute("test -e images || ln -s ~/Apunte/images/ ./images")
  return "" -- This function inserts no text
end

-- Function to create an empty bibliography file.
-- It only runs if 'bibliografia.bib' doesn't already exist.
local function create_bib_file()
  os.execute("test -e bibliografia.bib || touch bibliografia.bib")
  return "" -- This function inserts no text
end


-- ===== SNIPPETS =====

return {
  -- Snippet 1: Your original "Documento" snippet (modified from our last conversation)
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
    i(1, "Tu Título"), -- Reuses node 1
    i(2, "Felipe Colli Olea"), -- Reuses node 2
    i(0, "Empieza a escribir aquí..."),
    f(create_symlink), -- Automatically create symlink
  })),

  -- Snippet 2: The new, powerful "Informe" snippet
  s("Informe", fmt([[
\documentclass[12pt, letterpaper]{{article}}

% ----- PAQUETES BÁSICOS Y DE IDIOMA -----
\usepackage[utf8]{{inputenc}}
\usepackage[T1]{{fontenc}}
\usepackage[spanish]{{babel}}
\usepackage{{graphicx}}

% ----- PAQUETES DE FORMATO Y GEOMETRÍA -----
\usepackage{{geometry}}
\usepackage{{setspace}}
\usepackage{{enumitem}}
\usepackage{{microtype}}
\graphicspath{{ {{./images/}}, {{~/Apunte/images/}} }}

% ----- PAQUETE DE CITAS Y BIBLIOGRAFÍA (MODIFICADO) -----
\usepackage{{csquotes}} % Recomendado por biblatex
\usepackage[style=verbose-trad1, bibstyle=numeric, backend=biber]{{biblatex}}
\addbibresource{{bibliografia.bib}} % Llama a tu archivo de bibliografía

% ----- CONFIGURACIÓN DE LA PÁGINA -----
\geometry{{
    letterpaper,
    left=2.5cm,
    right=2.5cm,
    top=2.5cm,
    bottom=3cm
}}
\setstretch{{1.5}}

% ----- PAQUETES Y CONFIGURACIÓN DE PIE DE PÁGINA E HIPERVÍNCULOS -----
\usepackage{{fancyhdr}}
\usepackage{{hyperref}}
\hypersetup{{
    colorlinks=true,
    linkcolor=black,
    urlcolor=blue,
    pdftitle={{{}}},
    pdfauthor={{Felipe Colli Olea, {}, {}, {}, {}}},
    pdfsubject={{{}}}
}}

% --- INICIO DEL DOCUMENTO ---
\begin{{document}}

% --- CONFIGURACIÓN DEL PIE DE PÁGINA ---
\pagestyle{{fancy}}
\fancyhf{{}}
\fancyfoot[C]{{\footnotesize {}}}
\fancyfoot[R]{{\thepage}}
\renewcommand{{\headrulewidth}}{{0pt}}

% --- PORTADA ---
\begin{{titlepage}}
	\centering
	\includegraphics[width=2cm]{{IN.png}}\\[1.5cm]
	\textsc{{\LARGE  Instituto Nacional General José Miguel Carrera}}\\[0.5cm]
	\textsc{{\Large Departamento de Filosofía}}\\[1cm]
	\rule{{\textwidth}}{{1.5pt}}\vspace{{0.4cm}}
	{{ \Huge \bfseries {} }}\\[0.4cm]
	\rule{{\textwidth}}{{1.5pt}}\\[1cm]
	{{ \Large \textit{{{}}} }}\\[2cm]
	\begin{{minipage}}{{0.45\textwidth}}
		\begin{{flushleft}} \large
			\textbf{{Autores:}}\\
			Felipe Colli Olea\\
			{}\\
			{}\\
			{}\\
			{}
		\end{{flushleft}}
	\end{{minipage}}
	\hfill
	\begin{{minipage}}{{0.45\textwidth}}
		\begin{{flushright}} \large
			\textbf{{Profesora:}}\\
			{}
		\end{{flushright}}
	\end{{minipage}}
	\vfill
	{{ \large Santiago, Chile \\[0.5cm] \today }}
\end{{titlepage}}

\newpage
\tableofcontents
\newpage

% --- CUERPO DEL ENSAYO ---

\section*{{Introducción}}
\thispagestyle{{fancy}}
% ... (texto pre-escrito) ...
{}

\newpage
\section*{{Desarrollo}}

\subsection*{{China: Un Pacto de Prosperidad a Cambio de Lealtad}}
% ... (texto pre-escrito) ...

\subsection*{{Vietnam: Renovación Económica bajo Control Político}}
% ... (texto pre-escrito) ...

\subsection*{{Kerala: Comunismo Democrático y Desarrollo Social}}
% ... (texto pre-escrito) ...

\subsection*{{Experiencias cercanas al comunismo en las regiones de China, Vietnam y Kerala}}
% ... (texto pre-escrito) ...

\newpage
\section*{{Conclusión}}
% ... (texto pre-escrito) ...

\newpage
\printbibliography[title=Bibliografía]

\end{{document}}
{}
]], {
    -- Nodes for the metadata and title page
    i(1, "Título del Informe"),      -- pdftitle
    i(2, "Rodrigo Martinez"),      -- pdfauthor
    i(3, "Nicolás Aguilera"),      -- pdfauthor
    i(4, "Lautaro Palma"),         -- pdfauthor
    i(5, "Isaias Vivanco"),         -- pdfauthor
    i(6, "Asignatura"),             -- pdfsubject and footer
    i(6),                          -- Re-use for footer
    i(1),                          -- Re-use for main title on cover
    i(6),                          -- Re-use for subtitle on cover

    -- Nodes for the author list on the cover (re-uses author names)
    i(2),
    i(3),
    i(4),
    i(5),

    -- Node for the professor's name
    i(7, "Nombre de la Profesora"),

    -- Final cursor position
    i(0, "% Empieza a escribir aquí..."),

    -- Function nodes to run automatically
    f(create_symlink),
    f(create_bib_file),
  })),
}
