section .data
;Canviar Nom i Cognom per les vostres dades.
developer db "Àngel Mariages",0

;Constants que també estan definides en C.
DimMatrix    equ 4
SizeMatrix   equ 16

section .text
;Variables definides en Assemblador.
global developer

;Subrutines d'assemblador que es criden des de C.
global showNumberP1, updateBoardP1, rotateMatrixRP1, copyMatrixP1
global shiftNumbersRP1, addPairsRP1
global readKeyP1, playP1

;Variables definides en C.
extern rowScreen, colScreen, charac, number
extern m, mRotated, number, score, state

;Funcions de C que es criden des de assemblador
extern clearScreen_C, printBoardP1_C, gotoxyP1_C, getchP1_C, printchP1_C
extern insertTileP1_C, printMessageP1_C

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ATENCIÓ: Recordeu que en assemblador les variables i els paràmetres
;;   de tipus 'char' s'han d'assignar a registres de tipus
;;   BYTE (1 byte): al, ah, bl, bh, cl, ch, dl, dh, sil, dil, ..., r15b
;;   les de tipus 'short' s'han d'assignar a registres de tipus
;;   WORD (2 bytes): ax, bx, cx, dx, si, di, ...., r15w
;;   les de tipus 'int' s'han d'assignar a registres de tipus
;;   DWORD (4 bytes): eax, ebx, ecx, edx, esi, edi, ...., r15d
;;   les de tipus 'long' s'han d'assignar a registres de tipus
;;   QWORD (8 bytes): rax, rbx, rcx, rdx, rsi, rdi, ...., r15
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Les subrutines en assemblador que heu d'implementar són:
;;   showNumberP1, updateBoardP1, rotateMatrixRP1,
;;   copyMatrixP1, shiftNumbersLP1, addPairsLP1.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Situar el cursor a la fila indicada per la variable (rowScreen) i a
; la columna indicada per la variable (colScreen) de la pantalla,
; cridant la funció gotoxyP1_C.
;
; Variables globals utilitzades:
; rowScreen: Fila de la pantalla on posicionem el cursor.
; colScreen: Columna de la pantalla on posicionem el cursor.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP1:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call gotoxyP1_C

   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Mostrar un caràcter guardat a la variable (charac) a la pantalla,
; en la posició on està el cursor, cridant la funció printchP1_C
;
; Variables globals utilitzades:
; charac   : Caràcter que volem mostrar.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP1:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   call printchP1_C

   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Llegir una tecla i guarda el caràcter associat a la variable (charac)
; sense mostrar-la per pantalla, cridant la funció getchP1_C.
;
; Variables globals utilitzades:
; charac   : Caràcter que llegim de teclat.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP1:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.
   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push rdi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15
   push rbp

   call getchP1_C

   pop rbp
   pop r15
   pop r14
   pop r13
   pop r12
   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rcx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;
; Convertir el número de la variable (number) de tipus int (DWORD) de 6
; dígits (number <= 999999) a caràcters ASCII que representen el seu valor.
; Si (number) és més gran que 999999 canviarem el valor a 999999.
; S'ha de dividir el valor entre 10, de forma iterativa, fins
; obtenir els 6 dígits.
; A cada iteració, el residu de la divisió que és un valor entre (0-9)
; indica el valor del dígit que s'ha de convertir a ASCII ('0' - '9')
; sumant '0' (48 decimal) per a poder-lo mostrar.
; Quan el quocient sigui 0 mostrarem espais a la part no significativa.
; Per exemple, si number=103 mostrarem "   103" i no "000103".
; S'han de mostrar els dígits (caràcter ASCII) des de la posició
; indicada per les variables (rowScreen) i (colScreen), posició de les
; unitats, cap a l'esquerra.
; Com el primer dígit que obtenim són les unitats, després les desenes,
; ..., per a mostrar el valor s'ha de desplaçar el cursor una posició
; a l'esquerra a cada iteració.
; Per a posicionar el cursor cridar a la subrutina gotoxyP1 i per a
; mostrar els caràcters a la subrutina printchP1.
;
; Variables globals utilitzades:
; number    : Número que volem mostrar.
; rowScreen : Fila per a posicionar el cursor a la pantalla.
; colScreen : Columna per a posicionar el cursor a la pantalla.
; charac    : Caràcter que volem mostrar
;;;;;
showNumberP1:
   push rbp
   push rax
   push rbx
   push rcx
   push rdx
   mov  rbp, rsp

   mov rax, 0
   mov ebx, DWORD[number]; number és 290500

   cmp rbx, 999999
   jg massaGran
   jmp for

   massaGran:
      mov rbx, 999999


   for:
      cmp rax, 6
      jl cert
      jmp fi
   cert:
      mov BYTE[charac], ' '

      cmp rbx, 0
      jg nPositiu
      jmp printChar

      nPositiu:
         mov rdx, rbx; posem a rdx el quocient anteriorment guardat
         mov rcx, 0; resetejem el quocient a 0

         cmp rdx, 9

         jle fiBucle
         bucle:
            sub rdx, 10; residu
            inc rcx ; quocient

            cmp rdx, 10
            jge bucle

         fiBucle:
            mov rbx, rcx; guardem el quocient a rbx
            mov BYTE[charac], dl
            add BYTE[charac], '0'

      printChar:
         call gotoxyP1
         call printchP1
         dec BYTE[colScreen]

         inc rax
      jmp for
   fi:
      mov rsp, rbp
      pop rdx
      pop rcx
      pop rbx
      pop rax
      pop rbp
      ret


;;;;;
; Actualitzar el contingut del Tauler de Joc amb les dades de la matriu
; (m) i els punts del marcador (score) que s'han fet.
; S'ha de recórrer tota la matriu (m), i per a cada element de la matriu
; posicionar el cursor a la pantalla i mostrar el número d'aquella
; posició de la matriu.
; Per recórrer la matriu en assemblador l'índex va de 0 (posició [0][0])
; a 30 (posició [3][3]) amb increments de 2 perquè les dades son de
; tipus short(WORD) 2 bytes.
; Després, mostrar el marcador (score) a la part inferior del tauler,
; fila 18, columna 26 cridant la subrutina showNumberP1.
; Finalment posicionar el cursor a la fila 18, columna 28 cridant la
; subrutina goroxyP1.
;
; Variables globals utilitzades:
; rowScreen : Fila per a posicionar el cursor a la pantalla.
; colScreen : Columna per a posicionar el cursor a la pantalla.
; m         : Matriu 4x4 on guardem els nombres del joc.
; score     : Punts acumulats al marcador fins al moment.
; number    : Número que volem mostrar.
;;;;;
updateBoardP1:
   push rbp
   mov  rbp, rsp

   push rax
   push rbx
   push rcx
   push rdx
   push rsi

   mov rax, 0
   mov rbx, 10

   forUpdate:
      cmp rax, DimMatrix*8
      jl certUpdate
      jmp fiUpdate

   certUpdate:
      mov rdx, 17
      mov rsi, 0

      forUpdate2:
         cmp rsi, DimMatrix*2
         jl certUpdate2
         jmp fiUpdate2

      certUpdate2:
         movzx ecx, WORD[m+rax+rsi]
         mov DWORD[number], ecx
         mov BYTE[rowScreen], bl; rowScreen = rowScreenAux
         mov BYTE[colScreen], dl; colScreen = colScreenAux

         call showNumberP1

         add rdx, 9; colScreenAux + 9
         add rsi, 2; j++
         jmp forUpdate2

      fiUpdate2:
         add rbx, 2; rowScreenAux + 2
         add rax, 8; i++
         jmp forUpdate
   fiUpdate:
      mov rax, [score]

      mov DWORD[number], eax
      mov BYTE[rowScreen], 18
      mov BYTE[colScreen], 26

      call showNumberP1

      mov BYTE[rowScreen], 18
      mov BYTE[colScreen], 28
      call gotoxyP1

      pop rsi
      pop rdx
      pop rcx
      pop rbx
      pop rax

      mov rsp, rbp
      pop rbp
      ret


;;;;;
; Rotar a la dreta la matriu (m), sobre la matriu (mRotated).
; La primera fila passa a ser la quarta columna, la segona fila passa
; a ser la tercera columna, la tercera fila passa a ser la segona
; columna i la quarta fila passa a ser la primer columna.
; A l'enunciat s'explica en més detall com fer la rotació.
; NOTA: NO és el mateix que fer la matriu transposada.
; La matriu (m) no s'ha de modificar,
; els canvis s'han de fer a la matriu (mRotated).
; Per recórrer la matriu en assemblador l'index va de 0 (posició [0][0])
; a 30 (posició [3][3]) amb increments de 2 perquè les dades son de
; tipus short(WORD) 2 bytes.
; Per a accedir a una posició concreta de la matriu des d'assemblador
; cal tindre en compte que l'índex és:(index=(fila*DimMatrix+columna)*2),
; multipliquem per 2 perquè les dades son de tipus short(WORD) 2 bytes.
; Un cop s'ha fet la rotació, copiar la matriu (mRotated) a la matriu (m)
; cridant la subrutina copyMatrixP1.
;
; Variables globals utilitzades:
; m        : Matriu 4x4 on hi han el números del tauler de joc.
; mRotated : Matriu 4x4 per a fer la rotació.
;;;;;
rotateMatrixRP1:
   push rbp
   mov  rbp, rsp

   push rax
   push rbx
   push rcx
   push rdx
   push rsi

   mov rax, 0
   mov rdx, 6

   forRotate:
      cmp rax, DimMatrix*8
      jl certRotate
      jmp fiRotate

      certRotate:
         mov rbx, 0
         mov rsi, 0

         forRotate2:
            cmp rbx, DimMatrix*2
            jl certRotate2
            jmp fiRotate2

         certRotate2:
            mov cx, WORD[m+rax+rbx]
            mov WORD[mRotated+rsi+rdx], cx

            add rbx, 2; j++
            add rsi, 8
            jmp forRotate2
         fiRotate2:
            add rax, 8; i++
            sub rdx, 2
            jmp forRotate


      fiRotate:
         call copyMatrixP1

         pop rsi
         pop rdx
         pop rcx
         pop rbx
         pop rax

         mov rsp, rbp
         pop rbp
         ret


;;;;;
; Copiar els valors de la matriu (mRotated) a la matriu (m).
; La matriu (mRotated) no s'ha de modificar,
; els canvis s'han de fer a la matriu (m).
; Per recórrer la matriu en assemblador l'índex va de 0 (posició [0][0])
; a 30 (posició [3][3]) amb increments de 2 perquè les dades son de
; tipus short(WORD) 2 bytes.
; No es mostrar la matriu.
;
; Variables globals utilitzades:
; m        : matriu 4x4 on hi han el números del tauler de joc.
; mRotated : matriu 4x4 per a fer la rotació.
;;;;;
copyMatrixP1:
   push rbp
   mov  rbp, rsp

   push rax
   push rbx
   push rcx
   push rdx
   push rsi

   mov rax, 0

   forCopy:
      cmp rax, DimMatrix*8
      jl certCopy
      jmp fiCopy

      certCopy:
         mov rbx, 0

         forCopy2:
            cmp rbx, DimMatrix*2
            jl certCopy2
            jmp fiCopy2

         certCopy2:
            mov cx, WORD[mRotated+rax+rbx]
            mov WORD[m+rax+rbx], cx

            add rbx, 2; j++
            jmp forCopy2
         fiCopy2:
            add rax, 8; i++
            jmp forCopy


      fiCopy:
         pop rsi
         pop rdx
         pop rcx
         pop rbx
         pop rax

         mov rsp, rbp
         pop rbp
         ret


;;;;;
; Desplaça a la dreta els números de cada fila de la matriu (m),
; mantenint l'ordre dels números i posant els zeros a l'esquerra.
; Recórrer la matriu per files de dreta a esquerra i de baix a dalt.
; Si es desplaça un número (NO ELS ZEROS), posarem la variable
; (state) a '2'.
; Si una fila de la matriu és: [2,0,4,0] i state = '1', quedarà [0,0,2,4]
; i state = '2'.
; A cada fila, si troba un 0, mira si hi ha un número diferent de zero,
; a la mateixa fila per posar-lo en aquella posició.
; Per recórrer la matriu en assemblador, en aquest cas, l'índex va de la
; posició 30 (posició [3][3]) a la 0 (posició [0][0]) amb decrements de
; 2 perquè les dades son de tipus short(WORD) 2 bytes.
; Per a accedir a una posició concreta de la matriu des d'assemblador
; cal tindre en compte que l'índex és:(index=(fila*DimMatrix+columna)*2),
; multipliquem per 2 perquè les dades son de tipus short(WORD) 2 bytes.
; Els canvis s'han de fer sobre la mateixa matriu.
; No s'ha de mostrar la matriu.
;
; Variables globals utilitzades:
; state    : Estat del joc. ('2': S'han fet moviments).
; m        : Matriu 4x4 on hi han el números del tauler de joc.
;;;;;
shiftNumbersRP1:
   push rbp
   mov  rbp, rsp

   push rax
   push rbx
   push rcx
   push rdx
   push rsi

   mov rax, DimMatrix*8
   sub rax, 8

   forShift:
      cmp rax, 0
      jge certShift
      jmp fiShift

      certShift:
         mov rbx, DimMatrix*2
         sub rbx, 2

         forShift2:
            cmp rbx, 0
            jg certShift2
            jmp fiShift2

         certShift2:
            mov cx, WORD[m+rax+rbx]
            cmp cx, 0
            je equal0
            jmp outEqual

            equal0:
               mov rdx, rbx
               sub rdx, 2

               whileEqual:
                  cmp rdx, 0
                  jl fiWhile

                  mov si, WORD[m+rax+rdx]
                  cmp si, 0
                  jne fiWhile

               certWhile:
                  sub rdx, 2
                  jmp whileEqual
               fiWhile:
                  cmp rdx, -2
                  je kNegativa
                  jmp kPositiva

                  kNegativa:
                     mov rbx, 0
                     jmp outEqual

                  kPositiva:
                     mov WORD[m+rax+rbx], si; m[i][j] = m[i][k];
                     mov WORD[m+rax+rdx], 0; m[i][k] = 0;
                     mov BYTE[state], '2'
                     jmp outEqual

            outEqual:
               sub rbx, 2; j--
               jmp forShift2
         fiShift2:
            sub rax, 8; i--
            jmp forShift


      fiShift:
         pop rsi
         pop rdx
         pop rcx
         pop rbx
         pop rax

         mov rsp, rbp
         pop rbp
         ret


;;;;;
; Aparellar nombres iguals des de la dreta de la matriu (m) i acumular
; els punts al marcador sumant el punts de les parelles que s'hagin fet.
; Recórrer la matriu per files de dreta a esquerra i de baix a dalt.
; Quan es trobi una parella, dos caselles consecutives amb el mateix
; número, ajuntem la parella posant la suma de la parella a la casella
; de la dreta, un 0 a la casella de l'esquerra i
; acumularem aquesta suma (punts que es guanyen).
; Si una fila de la matriu és: [8,4,4,2] i state = 1'', quedarà [8,0,8,2],
; p = p + (4+4) i state = '2'.
; Si al final s'ha ajuntat alguna parella (punts>0), posarem la variable
; (state) a '2' per a indicar que s'ha mogut algun nombre i actualitzarem
; la variable (score) amb els punts obtinguts de fer les parelles.
; Per recórrer la matriu en assemblador, en aquest cas, l'index va de la
; posició 30 (posició [3][3]) a la 0 (posició [0][0]) amb increments de
; 2 perquè les dades son de tipus short(WORD) 2 bytes.
; Per a accedir a una posició concreta de la matriu des d'assemblador
; cal tindre en compte que l'índex és:(index=(fila*DimMatrix+columna)*2),
; multipliquem per 2 perquè les dades son de tipus short(WORD) 2 bytes.
; Els canvis s'han de fer sobre la mateixa matriu.
; No s'ha de mostrar la matriu.
;
; Variables globals utilitzades:
; m        : Matriu 4x4 on hi han el números del tauler de joc.
; score    : Punts acumulats fins el moment.
; state    : Estat del joc. ('2': S'han fet moviments).
;;;;;
addPairsRP1:
   push rbp
   mov  rbp, rsp

   push rax
   push rbx
   push rcx
   push rdx
   push rsi

   mov rax, 0

   mov rsi, DimMatrix*8
   sub rsi, 8

   forPairs:
      cmp rsi, 0
      jge certPairs
      jmp fiPairs

      certPairs:
         mov rbx, DimMatrix*2
         sub rbx, 2

         forPairs2:
            cmp rbx, 0
            jg certPairs2
            jmp fiPairs2

         certPairs2:
            mov cx, WORD[m+rsi+rbx]

            cmp cx, 0
            je fiIfPairs

            mov dx, WORD[m+rsi+rbx-2]
            cmp cx, dx
            jne fiIfPairs

            certIfParis:
               push rax

               mov eax, 2
               mul cx

               mov WORD[m+rsi+rbx], ax
               mov WORD[m+rsi+rbx-2], 0

               movzx rcx, ax
               pop rax
               add rax, rcx

            fiIfPairs:
               sub rbx, 2; j--
               jmp forPairs2
         fiPairs2:
            sub rsi, 8; i--
            jmp forPairs


      fiPairs:
         cmp rax, 0
         jg haFetPunts
         jmp foraPairs

         haFetPunts:
            mov BYTE[state], '2'
            add DWORD[score], eax

         foraPairs:
            pop rsi
            pop rdx
            pop rcx
            pop rbx
            pop rax

            mov rsp, rbp
            pop rbp
            ret


;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Llegir una tecla  (un sol cop, sense fer un bucle) ,cridant
; la subrutina getchP1 que la guarda a la variable (charac).
; Segons la tecla llegida cridarem a les subrutines corresponents.
;    ['i' (amunt),'j'(esquerra),'k' (avall) o 'l'(dreta)]
; Desplaçar els números i fer les parelles segons la direcció triada.
; Segons la tecla premuda, rotar la matriu cridant (rotateMatrixRP1), per
; a poder fer els desplaçaments dels números cap a la dreta
; (shiftNumbersRP1), fer les parelles cap a la dreta (addPairsRP1) i
; tornar a desplaçar els nombres cap a la dreta (shiftNumbersRP1)
; amb les parelles fetes, després seguir rotant cridant (rotateMatrixRP1)
; fins deixar la matriu en la posició inicial.
; Per a la tecla 'l' (dreta) no cal fer rotacions, per a la resta
; s'han de fer 4 rotacions.
;    '<ESC>' (ASCII 27)  posar (state = '0') per a sortir del joc.
; Si no és cap d'aquestes tecles no fer res.
; Els canvis produïts per aquestes subrutines no s'han de mostrar a la
; pantalla, per tant, caldrà actualitzar després el tauler cridant la
; subrutina UpdateBoardP1.
;
; Variables globals utilitzades:
; charac : Caràcter que llegim de teclat.
; state  : Indica l'estat del joc. '0':sortir (ESC premut), '1':jugar
;;;;;
readKeyP1:
   push rbp
   mov  rbp, rsp

   push rax

   call getchP1    ; Llegir una tecla i deixar-la a charac.
   mov  al, BYTE[charac]

   readKeyP1_i:
   cmp al, 'i'      ; amunt
   jne  readKeyP1_j
      call rotateMatrixRP1

      call shiftNumbersRP1
      call addPairsRP1
      call shiftNumbersRP1

      call rotateMatrixRP1
      call rotateMatrixRP1
      call rotateMatrixRP1
      jmp  readKeyP1_End

   readKeyP1_j:
   cmp al, 'j'      ; esquerra
   jne  readKeyP1_k
      call rotateMatrixRP1
      call rotateMatrixRP1

      call shiftNumbersRP1
      call addPairsRP1
      call shiftNumbersRP1

      call rotateMatrixRP1
      call rotateMatrixRP1
      jmp  readKeyP1_End

   readKeyP1_k:
   cmp al, 'k'      ; abajo
   jne  readKeyP1_l
      call rotateMatrixRP1
      call rotateMatrixRP1
      call rotateMatrixRP1

      call shiftNumbersRP1
      call addPairsRP1
      call shiftNumbersRP1

      call rotateMatrixRP1
      jmp  readKeyP1_End

   readKeyP1_l:
   cmp al, 'l'      ; dreta
   jne  readKeyP1_ESC
      call shiftNumbersRP1
      call addPairsRP1
      call shiftNumbersRP1
      jmp  readKeyP1_End

   readKeyP1_ESC:
   cmp al, 27      ; Sortir del programa
   jne  readKeyP1_End
      mov BYTE[state], '0'

   readKeyP1_End:
   pop rax

   mov rsp, rbp
   pop rbp
   ret


;;;;;
; Joc del 2048
; Funció principal del joc
; Permet jugar al joc del 2048 cridant totes les funcionalitats.
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
;
; Pseudo codi:
; Inicialitzar estat del joc, (state='1')
; Esborrar pantalla (cridar la funció clearScreen_C).
; Mostrar el tauler de joc (cridar la funció PrintBoardP1_C).
; Actualitza el contingut del Tauler de Joc i els punts que s'han fet
; (cridar la subrutina updateBoardP1).
; Mentre (state=='1') fer
;   Llegir una tecla (cridar la subrutina readKeyP1). Segons la tecla
;     llegida cridarem a les funcions corresponents.
;     - ['i','j','k' o 'l'] desplaçar els números i fer les parelles
;                           segons la direcció triada.
;     - '<ESC>'  (codi ASCII 27) posar (state = '0') per a sortir.
;   Si hem mogut algun número al fer els desplaçaments o al fer les
;   parelles (state=='2'), generar una nova fitxa (cridant la funció
;   insertTileP1_C) i posar la variable state a '1' (state='1').
;   Actualitza el contingut del Tauler de Joc i els punts que s'han fet
;   (cridar la subrutina updateBoardP1).
; Fi mentre.
; Mostra un missatge a sota del tauler segons el valor de la variable
; (state). (cridar la funció printMessageP1_C).
; Sortir:
; S'acabat el joc.
;
; Variables globals utilitzades:
; state   : indica l'estat del joc. '0':sortir, '1':jugar.
;;;;;
playP1:
   push rbp
   mov  rbp, rsp

   mov BYTE[state], '1'       ;state = '1';  //estat per a començar a jugar

   call clearScreen_C
   call printBoardP1_C
   call updateBoardP1

   playP1_Loop:               ;while  {     //Bucle principal.
   cmp  BYTE[state], '1'     ;(state == '1')
   jne  playP1_End

      call readKeyP1          ;readKeyP1_C();
      cmp BYTE[state], '2'   ;state == '2' //Si s'ha fet algun moviment,
      jne playP1_Next
         call insertTileP1_C  ;insertTileP1_C(); //Afegir fitxa (2)
         mov BYTE[state],'1' ;state = '1';
      playP1_Next
      call updateBoardP1      ;updateBoardP1_C();

   jmp playP1_Loop

   playP1_End:
   call printMessageP1_C      ;printMessageP1_C();
                              ;Mostrar el missatge per a indicar com acaba.
   mov rsp, rbp
   pop rbp
   ret
