![](img/mgp.jpg)

## Semana Acadêmica Integrada - PUCRS/Escola Politécnica - 2026

Profs. Edson Ifarraguirre Moreno e Marcelo Cohen

---

### O que é o Shell?

O **shell** (termo em inglês para "concha" ou "casca") é um programa que atua como intermediário entre o usuário e o núcleo (*kernel*) do sistema operacional. Trata-se de um **interpretador de comandos**: ele fornece uma interface em modo texto onde digitamos instruções, interpreta o que foi solicitado e aciona o sistema operacional para executar programas, manipular arquivos e gerenciar processos. Exemplos populares de shells incluem o **Bash**, o **Zsh** e o **Fish**.

### O Shell e os Terminais de Antigamente

Para entender o shell, vale a pena olhar para a história da computação:

1. **Os Terminais Físicos (Hardware):** Nas décadas de 1960 e 1970, os computadores (como os *mainframes* e minicomputadores) eram equipamentos volumosos, caros e compartilhados. Os usuários não se sentavam diretamente em frente ao computador. Em vez disso, conectavam-se a ele por meio de **terminais** — dispositivos físicos compostos apenas por um teclado e um mecanismo de saída (inicialmente teletipos com papel, como os *TTY*, e mais tarde telas com fósforo verde/âmbar, como o lendário DEC VT100). O terminal em si não realizava processamento pesado: sua função era apenas enviar os caracteres digitados e exibir as respostas enviadas pelo computador central.

   ![Terminal DEC VT100](img/vt100.jpg)

2. **O Papel do Shell:** No computador central, era necessário haver um programa rodando para receber os caracteres enviados pelo terminal, dar sentido às linhas digitadas e coordenar a execução das tarefas solicitadas: esse programa era o **shell**.

3. **O Cenário Atual:** Hoje em dia, quase não utilizamos mais terminais de hardware. Em seu lugar, usamos **emuladores de terminal** (softwares com janelas gráficas, como o *Terminal* do macOS/Linux, *Alacritty*, *iTerm2* ou *Windows Terminal*). O emulador recria virtualmente o comportamento do terminal físico de antigamente, enquanto o **shell** continua fazendo exatamente o mesmo trabalho de sempre por trás dos panos: interpretar e executar seus comandos.
