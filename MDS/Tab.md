# 📱 CHECKLIST MAESTRO: GALAXY TAB S10 FE (Engineering Edition)

Como el PC es un "talvez seguro" pero la Tablet es una **certeza**, vamos a configurarla para que sea tu **estación de trabajo principal** en caso de que el Legion se demore.

## 1. Primera Capa: Limpieza y Optimización (Debloat) 🧹
Samsung llena las tablets de basura. Como no queremos que el Exynos sufra:
*   **Shizuku + Canta:** Instala **Shizuku** (vía ADB o modo desarrollador) y luego **Canta**.
*   **Misión:** Desinstala (u oculta) todo lo que no uses: Bixby, Facebook, LinkedIn, Microsoft Office (usa versiones web o alternativas), y las 50 apps de sistema que solo trackean datos.
*   **RAM Plus:** Desactívalo. En Android, usar el almacenamiento como RAM (swap) suele ralentizar el sistema en vez de ayudar, y tú ya tienes 6GB u 8GB físicos que bastan.

## 2. Capa de Conectividad (El puente al Server) 📡
Dado que no tienes wifi fijo, la tablet tiene que ser parte de tu red local virtual.
*   **Tailscale:** Instalar sí o sí. Así podrás entrar por SSH a tu server i3 desde la tablet en el bus o en la U.
*   **Syncthing:** Configura una carpeta compartida entre tu Lenovo E41, el Server y la Tablet.
    *   *Uso:* Sacas una foto a la pizarra $\to$ aparece en el PC. Haces un PDF de un apunte $\to$ aparece en el server.

## 3. El Entorno "Hacker" (Termux) 💻🐍
Esto es lo que te separa de los iPad Kids.
*   **Setup:** Instala Termux desde **F-Droid**.
*   **Instala:** `pkg install neovim git python clang make openssh`.
*   **Workflow:** Puedes codear tus tareas de *Intro a la Progra* (Python) o de *C++* directamente en la tablet con Neovim.
*   **Extra:** Instala **Termux:X11** si algún día quieres correr alguna app de Linux con interfaz gráfica en la tablet.

## 4. Capa Académica (Plan Común Beauchef) 📝📐
*   **Samsung Notes:** Para escribir a mano es la mejor por latencia.
    *   *Tip:* Activa el modo "Solo lectura" cuando estudies para no mover cosas por error.
*   **Flexcil o Xodo:** Si vas a leer libros de 800 páginas (el *Stewart* de Cálculo o el *Halliday* de Física). Permiten anotar sobre el PDF de forma mucho más fluida.
*   **Anki:** Para memorizar conceptos de Química o Biología (que son tus puntos bajos).
*   **Calculadora:** Instala **HiPER Scientific Calculator**. Es la más completa y se ve como una calculadora de ingeniería real.

## 5. Integración con el Mouse G502 🖱️
*   Como tienes el G502, busca un **Adaptador USB-C a USB-A (OTG)** o un Hub pequeño.
*   **DeX Mode:** Cuando conectes el mouse y un teclado, activa DeX. La S10 FE se convierte en un PC. Para editar tus documentos de LaTeX en Overleaf o Google Docs, es mucho mejor que la interfaz de tablet.

---
