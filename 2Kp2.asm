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
global showNumberP2, updateBoardP2, rotateMatrixRP2, copyMatrixP2,
global shiftNumbersRP2, addPairsRP2
global readKeyP2, checkEndP2, playP2

;Variables definides en C.
extern m, mRotated, mAux, mUndo, state

;Funcions de C que es criden des de assemblador
extern clearScreen_C,  gotoxyP2_C, getchP2_C, printchP2_C
extern printBoardP2_C, printMessageP2_C, insertTileP2_C

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
;; Les subrutines en assemblador que heu de modificar per a
;; implementar el pas de paràmetres són:
;;   showNumberP2, updateBoardP2, rotateMatrixRP2, copyMatrixP2,
;;   shiftNumbersRP2, addPairsRP2
;; La subrutina nova que s'han d'implementar és:
;;   checkEndP2
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Situar el cursor en una fila i una columna de la pantalla
; en funció de la fila (edi) i de la columna (esi) rebuts com
; a paràmetre cridant a la funció gotoxyP2_C.
;
; Variables globals utilitzades:
; Cap
;
; Paràmetres d'entrada :
; rdi(edi): (rowScreen) Fila
; rsi(esi): (colScreen) Columna;
;
; Paràmetres de sortida:
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxyP2:
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

   ; Quan cridem la funció gotoxyP2_C(int rowScreen, int colScreen) des d'assemblador
   ; el primer paràmetre (rowScreen) s'ha de passar pel registre rdi(edi), i
   ; el segon  paràmetre (colScreen) s'ha de passar pel registre rsi(esi)
   call gotoxyP2_C

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Mostrar un caràcter (dil) a la pantalla, rebut com a paràmetre,
; en la posició on està el cursor cridant la funció printchP2_C.
;
; Variables globals utilitzades:
; Cap
;
; Paràmetres d'entrada :
; rdi(dil): (c) Caràcter que volem mostrar
;
; Paràmetres de sortida:
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printchP2:
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

   ; Quan cridem la funció printchP2_C(char c) des d'assemblador,
   ; el paràmetre (c) s'ha de passar pel registre rdi(dil).
   call printchP2_C

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Llegir una tecla i retornar el caràcter associat (al) sense
; mostrar-lo per pantalla, cridant la funció getchP2_C
;
; Variables globals utilitzades:
; Cap
;
; Paràmetres d'entrada :
; Cap
;
; Paràmetres de sortida:
; rax(al): (c) Caràcter que llegim de teclat
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getchP2:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.

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

   mov rax, 0
   ; Cridem la funció getchP2_C des d'assemblador,
   ; retorna sobre el registre rax(al) el caràcter llegit
   call getchP2_C

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

   mov rsp, rbp
   pop rbp
   ret


;;;;;
; Convertir el número rebut com a paràmetre (edx) de tipus int(DWORD)
; de 6 dígits (número <= 999999), a caràcters ASCII que representen
; el seu valor. Si el número és més gran que 999999 canviarem el valor a 999999.
; S'ha de dividir el valor entre 10, de forma iterativa,
; fins obtenir els 6 dígits.
; A cada iteració, el residu de la divisió que és un valor entre (0-9)
; indica el valor del dígit que s'ha de convertir a ASCII ('0' - '9')
; sumant '0' (48 decimal) per a poder-lo mostrar.
; Quan el quocient sigui 0 mostrarem espais a la part no significativa.
; Per exemple, si number=103 mostrarem "   103" i no "000103".
; S'han de mostrar els dígits (caràcters ASCII) des de la posició
; indicada per la fila (edi) i la columna (esi) rebuts com a paràmetre,
; posició de les unitats, cap a l'esquerra.
; Com el primer dígit que obtenim són les unitats, després les desenes,
; ..., per a mostrar el valor s'ha de desplaçar el cursor una posició
; a l'esquerra a cada iteració.
; Per a posicionar el cursor cridar a la subrutina gotoxyP2 i per a
; mostrar els caràcters a la subrutina printchP2 implementant
; correctament el pas de paràmetres.
;
; Variables globals utilitzades:
; Cap.
;
; Paràmetres d'entrada :
; rdi (edi): Fila on el volem mostrar a la pantalla.
; rsi (esi): Columna on el volem mostrar a la pantalla.
; rdx (edx): Número que volem mostrar a la pantalla.
;
; Paràmetres de sortida:
; Cap.
;;;;;
showNumberP2:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.

   push rax
   push rbx
   push rcx
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   mov rax, 0

   cmp rdx, 999999
   jg massaGran
   jmp for

   massaGran:
      mov rdx, 999999

  for:
      cmp rax, 6
      jl cert
      jmp fi
   cert:
      call gotoxyP2
      push rdi

      mov dil, ' '

      cmp rdx, 0
      jg nPositiu
      jmp printChar

      nPositiu:
         mov rbx, rdx; posem a rbx el quocient anteriorment guardat
         mov rcx, 0; resetejem el quocient a 0

         cmp rbx, 9

         jle fiBucle
         bucle:
            sub rbx, 10; residu
            inc rcx ; quocient

            cmp rbx, 10
            jge bucle

         fiBucle:
            mov rdx, rcx; guardem el quocient a rdx

            mov dil, bl
            add dil, '0'

      printChar:
         call printchP2

         pop rdi
         dec rsi

         inc rax
         jmp for
   fi:
      pop r15
      pop r14
      pop r13
      pop r12
      pop r11
      pop r10
      pop r9
      pop r8
      pop rcx
      pop rbx
      pop rax

      mov rsp, rbp
      pop rbp
      ret


;;;;;
; Actualitzar el contingut del Tauler de Joc amb les dades de la matriu
; (m) de 4x4 valors de tipus short (WORD) i els punts del marcador
; (score) que s'han fet.
; S'ha de recórrer tota la matriu (m), i per a cada element de la matriu
; posicionar el cursor a la pantalla i mostrar el nombre
; d'aquella posició de la matriu.
; Després, mostrar el marcador que rebem com a parametre (edi)
; a la part inferior del tauler,fila 18, columna 26 cridant la
; subrutina showNumberP2.
; Finalment posicionar el cursor a la fila 18, columna 28 cridant la
; subrutina gotoxyP2.
;
; Variables globals utilitzades:
; m        : matriu 4x4 on hi han els nombres del tauler de joc.
;
; Paràmetres d'entrada :
; rdi (edi): punts acumulats fins al moment.
;
; Paràmetres de sortida:
; Cap.
;;;;;
updateBoardP2:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.

   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

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

         push rdi
         push rsi
         push rdx

         mov edi, ebx ; fila
         mov esi, edx  ; columna
         mov edx, ecx ; numero

         call showNumberP2

         pop rdx
         pop rsi
         pop rdi


         add rdx, 9; colScreenAux + 9
         add rsi, 2; j++
         jmp forUpdate2

      fiUpdate2:
         add rbx, 2; rowScreenAux + 2
         add rax, 8; i++
         jmp forUpdate
   fiUpdate:
      push rax ; auxiliar
      push rdi ; fila
      push rsi ; columna
      push rdx ; numero

      mov eax, edi
      mov edi, 18
      mov esi, 26
      mov edx, eax

      call showNumberP2

      mov edi, 18
      mov esi, 28
      call gotoxyP2

      pop rax
      pop rdx
      pop rsi
      pop rdi

      pop r15
      pop r14
      pop r13
      pop r12
      pop r11
      pop r10
      pop r9
      pop r8
      pop rsi
      pop rdx
      pop rcx
      pop rbx
      pop rax

      mov rsp, rbp
      pop rbp
      ret


;;;;;
; Rotar a la dreta la matriu, rebuda com a paràmetre (rdi), sobre
; la matriu (mRotated).
; La primera fila passa a ser la quarta columna, la segona fila passa
; a ser la tercera columna, la tercera fila passa a ser la segona
; columna i la quarta fila passa a ser la primer columna.
; A l'enunciat s'explica en més detall com fer la rotació.
; NOTA: NO és el mateix que fer la matriu transposada.
; La matriu rebuda com a paràmetre no s'ha de modificar,
; els canvis s'han de fer a la matriu (mRotated).
; Per recorrer la matriu en assemblador l'index va de 0 (posició [0][0])
; a 30 (posició [3][3]) amb increments de 2 perquè les dades son de
; tipus short(WORD) 2 bytes.
; Per a accedir a una posició concreta de la matriu des d'assemblador
; cal tindre en compte que l'índex és:(index=(fila*DimMatrix+columna)*2),
; multipliquem per 2 perquè les dades son de tipus short(WORD) 2 bytes.
; Un cop s'ha fet la rotació, copiar la matriu (mRotated) a la matriu
; rebuda com a paràmetre cridant la subrutina copyMatrixP2.
; No s'ha de mostrar la matriu.
;
; Variables globals utilitzades:
; mRotated : Matriu on guardem els nombres ja rotats
;
; Paràmetres d'entrada :
; rdi      : Adreça de la matriu que volem rotar.
;
; Paràmetres de sortida:
; Cap.
;;;;;
rotateMatrixRP2:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.

   push rax
   push rbx
   push rcx
   push rdx
   push rsi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

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
            push rax ; màxim dos regstres en la computació d'addreçes
            add rax,rbx

            mov cx, [edi+eax]
            mov WORD[mRotated+rsi+rdx], cx

            pop rax ; retornem el valor original de rax

            add rbx, 2; j++
            add rsi, 8
            jmp forRotate2
         fiRotate2:
            add rax, 8; i++
            sub rdx, 2
            jmp forRotate


      fiRotate:
         ; destinació ja es edi -> m
         mov esi, mRotated ; origen
         call copyMatrixP2

         pop r15
         pop r14
         pop r13
         pop r12
         pop r11
         pop r10
         pop r9
         pop r8
         pop rsi
         pop rdx
         pop rcx
         pop rbx
         pop rax

         mov rsp, rbp
         pop rbp
         ret


;;;;;
; Copia la matriu, que rebem com a paràmetre (rsi), a la matriu
; destinació, que rebem com a primer paràmetre (rdi).
; La matriu origen no s'ha de modificar,
; els canvis s'han de fer a la matriu destinació.
; Això permetrà copiar dues matrius després d'una rotació
; i gestionar l'opció '(u)Undo' del joc.
; Per recorrer la matriu en assemblador l'índex va de 0 (posició [0][0])
; a 30 (posició [3][3]) amb increments de 2 perquè les dades son de
; tipus short(WORD) 2 bytes.
; No s'ha de mostrar la matriu.
;
; Variables globals utilitzades:
; Cap.
;
; Paràmetres d'entrada :
; rdi : Adreça de la matriu destinació.
; rsi : Adreça de la matriu origen.
;
; Paràmetres de sortida:
; Cap.
;;;;;
copyMatrixP2:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.

   push rax
   push rbx
   push rcx
   push rdx
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

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
            push rax ; guardem rax

            add rax, rbx

            mov cx, WORD[esi+eax]
            mov WORD[edi+eax], cx

            pop rax; tornem el valor de rax

            add rbx, 2; j++
            jmp forCopy2
         fiCopy2:
            add rax, 8; i++
            jmp forCopy

      fiCopy:
         pop r15
         pop r14
         pop r13
         pop r12
         pop r11
         pop r10
         pop r9
         pop r8
         pop rdx
         pop rcx
         pop rbx
         pop rax

         mov rsp, rbp
         pop rbp
         ret


;;;;;
; Desplaça a la dreta els nombres de cada fila de la matriu rebuda
; com a paràmetre (rdi), mantenint l'ordre dels nombres i posant
; els zeros a l'esquerra.
; Recórrer la matriu per files de dreta a esquerra de baix a dalt.
; Si es desplaça un nombre (NO ELS ZEROS), s'han de comptar els
; desplaçaments.
; Retornarem el número de desplaçaments fets sobre (eax).
; Si una fila de la matriu és: [2,0,4,0] i (shift=0),
; quedarà [0,0,2,4] i (shift=2).
; A cada fila, si troba un 0, mira si hi ha un número defiernt de zero,
; a la mateiza fila per posar-lo en aquella posició.
; Per recorrer la matriu en assemblador, en aquest cas, l'index va de la
; posició 30 (posició [3][3]) a la 0 (posició [0][0]) amb decrements de
; 2 perquè les dades son de tipus short(WORD) 2 bytes.
; Per a accedir a una posició concreta de la matriu des d'assemblador
; cal tindre en compte que l'índex és:(index=(fila*DimMatrix+columna)*2),
; multipliquem per 2 perquè les dades son de tipus short(WORD) 2 bytes.
; Els canvis s'han de fer sobre la mateixa matriu.
; No s'ha de mostrar la matriu.
;
; Variables globals utilitzades:
; Cap.
;
; Paràmetres d'entrada :
; rdi : Adreça de la matriu que volem desplaçar els nombres.
;
; Paràmetres de sortida:
; rax(eax) : Número de desplaçaments fets.
;;;;;
shiftNumbersRP2:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.

   push rbx
   push rcx
   push rdx
   push rsi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

   mov rax, DimMatrix*8
   sub rax, 8
   mov r8, 0 ; farem servir r8 per a sumar els desplaçaments fets, al final mourem el valor de r8 a rax

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
            push rax ; guardem rax
            add rax, rbx

            mov cx, [edi+eax]

            pop rax ; tornem el valor de rax

            cmp cx, 0
            je equal0
            jmp outEqual

            equal0:
               mov rdx, rbx
               sub rdx, 2

               whileEqual:
                  cmp rdx, 0
                  jl fiWhile

                  push rax ; guardem rax

                  add rax, rdx

                  mov si, [edi+eax]

                  pop rax ; tornem el valor de rax

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
                     push rax ; guardem rax

                     add rax, rbx

                     mov WORD[edi+eax], si; m[i][j] = m[i][k];

                     pop rax ; tornem el valor de rax

                     push rax ; guardem el valor de rax

                     add rax, rdx

                     mov WORD[edi+eax], 0; m[i][k] = 0;

                     pop rax ; tornem el valor de rax

                     inc r8 ; incrementem els desplaçaments

                     jmp outEqual

            outEqual:
               sub rbx, 2; j--
               jmp forShift2
         fiShift2:
            sub rax, 8; i--
            jmp forShift


      fiShift:
         mov eax, r8d ; retornem per rax el nombre de desplçaments fets

         pop r15
         pop r14
         pop r13
         pop r12
         pop r11
         pop r10
         pop r9
         pop r8
         pop rsi
         pop rdx
         pop rcx
         pop rbx

         mov rsp, rbp
         pop rbp
         ret


;;;;;
; Aparellar nombres iguals des de la dreta de la matriu rebuda com a
; paràmetre (rdi) i acumular els punts sumant el punts de les parelles
; que s'hagin fet.
; Recórrer la matriu per files de dreta a esquerra i de baix a dalt.
; Quan es trobi una parella, dos caselles consecutives amb el mateix
; nombre, ajuntem la parella posant la suma de la parella a la casella
; de la dreta i un 0 a la casella de l'esquerra
; i acumularem aquesta suma (punts que es guanyen).
; Si una fila de la matriu és: [8,4,4,2] i (state = '1'), quedarà [8,0,8,2],
; i punts = (4+4)= 8.
; Retornarem els punts obtinguts de fer les parelles.
; Per recorrer la matriu en assemblador, en aquest cas, l'index va de la
; posició 30 (posició [3][3]) a la 0 (posició [0][0]) amb increments de
; 2 perquè les dades son de tipus short(WORD) 2 bytes.
; Per a accedir a una posició concreta de la matriu des d'assemblador
; cal tindre en compte que l'índex és:(index=(fila*DimMatrix+columna)*2),
; multipliquem per 2 perquè les dades son de tipus short(WORD) 2 bytes.
; Els canvis s'han de fer sobre la mateixa matriu.
; No s'ha de mostrar la matriu.
;
; Variables globals utilitzades:
; Cap.
;
; Paràmetres d'entrada :
; rdi      : Adreça de la matriu que volem fer les parelles.
;
; Paràmetres de sortida:
; rax(eax) : Punts obtinguts de fer les parelles.
;;;;;
addPairsRP2:
   push rbp
   mov  rbp, rsp
   ;guardem l'estat dels registres del processador perquè
   ;les funcions de C no mantenen l'estat dels registres.

   push rbx
   push rcx
   push rdx
   push rsi
   push r8
   push r9
   push r10
   push r11
   push r12
   push r13
   push r14
   push r15

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
            push rsi ; guardem rsi

            add rsi, rbx

            mov cx, [rdi+rsi]

            pop rsi ; tornem el valor de rsi

            cmp cx, 0
            je fiIfPairs

            push rsi ; guardem rsi

            add rsi, rbx

            mov dx, [rdi+rsi-2]

            pop rsi ; tornem el valor de rsi

            cmp cx, dx
            jne fiIfPairs

            certIfParis:
               push rax

               mov eax, 2
               mul cx

               push rsi ; guardem rsi

               add rsi, rbx

               mov [rdi+rsi], ax
               mov WORD[rdi+rsi-2], 0

               pop rsi ; tornem el valor de rsi

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
         pop r15
         pop r14
         pop r13
         pop r12
         pop r11
         pop r10
         pop r9
         pop r8
         pop rsi
         pop rdx
         pop rcx
         pop rbx

         mov rsp, rbp
         pop rbp
         ret



;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Llegir una tecla.  cridant la subrutina getchP2 que la guarda en el
; registre al.
; Segons la tecla llegida cridarem a les funcions corresponents.
;    ['i' (amunt),'j'(esquerra),'k' (avall) o 'l'(dreta)]
; Desplaçar els números i fer les parelles segons la direcció triada.
; Segons la tecla premuda, rotar la matriu cridant (rotateMatrixRP2)
; per a poder fer els desplaçaments dels nombres cap a l'esquerra
; (shiftNumbersRP2), fer les parelles cap a l'esquerra (addPairsRP2) i
; amb el nombre de punts retornats actualitzar el marcador (score).
; Tornar a desplaçar els nombres cap a l'esquerra (shiftNumbersLP2_C)
; amb les parelles fetes.
; Si s'ha fet algun desplaçament o alguna parella
; indicar-ho posant (state='2').
; Després seguir rotant cridant (rotateMatrixRP2_C)
; fins deixar la matriu en la posició inicial.
; Per a la tecla 'l' (dreta) no cal fer rotacions, per a la resta
; s'han de fer 4 rotacions.
;    'u'                Posar (state = '3') per a recuperar l'estat anterior.
;    '<ESC>' (ASCII 27) Posar (state = '0') per a sortir del joc.
; Si no és cap d'aquestes tecles no fer res.
; Els canvis produïts per aquestes subrutines no s'han de mostrar a la
; pantalla.
;
; Variables globals utilitzades:
; m        : Adreça de la matriu m
; mRotated : Dirección de la matriz mRotated
; state    : Estat del joc.
;
; Paràmetres d'entrada :
; rdi(edi) : Punts acumulats al marcador.

; Paràmetres de sortida:
; rax(eax) : Punts acumulats al marcador actualitzats.
;;;;;
readKeyP2:
   push rbp
   mov  rbp, rsp

   push rbx
   push rdx
   push rsi
   push rdi
   push r8          ;s1
   push r9          ;s2
   push r10         ;p
   push r11         ;actualscore

   mov  r11d, edi
   mov  rdi, m
   mov  rsi, mRotated

   call getchP2     ;getchP2_C();

   readKeyP2_i:
   cmp al, 'i'                ;i:(105) amunt
   jne  readKeyP2_j
      call rotateMatrixRP2    ;rotateMatrixRP2_C(m);

      call shiftNumbersRP2    ;s1 = shiftNumbersRP2_C(m);
      mov  r8d, eax
      call addPairsRP2        ;p  = addPairsRP2_C(m);
      mov  r10d, eax
      call shiftNumbersRP2    ;s2 = shiftNumbersRP2_C(m);
      mov  r9d, eax

      call rotateMatrixRP2    ;rotateMatrixRP2_C(m);
      call rotateMatrixRP2    ;rotateMatrixRP2_C(m);
      call rotateMatrixRP2    ;rotateMatrixRP2_C(m);
      jmp  readKeyP2_moved

   readKeyP2_j:
   cmp al, 'j'                ;j:(106) esquerra
   jne  readKeyP2_k
      call rotateMatrixRP2    ;rotateMatrixRP2_C(m);
      call rotateMatrixRP2    ;rotateMatrixRP2_C(m);

      call shiftNumbersRP2    ;s1 = shiftNumbersRP2_C(m);
      mov  r8d, eax
      call addPairsRP2        ;actualScore = actualScore + p;
      mov  r10d, eax
      call shiftNumbersRP2    ;s2 = shiftNumbersRP2_C(m);
      mov  r9d, eax

      call rotateMatrixRP2    ;rotateMatrixRP2_C(m);
      call rotateMatrixRP2    ;rotateMatrixRP2_C(m);
      jmp  readKeyP2_moved

   readKeyP2_k:
   cmp al, 'k'                ;k:(107) dreta
   jne  readKeyP2_l
      call rotateMatrixRP2    ;rotateMatrixRP2_C(m);
      call rotateMatrixRP2    ;rotateMatrixRP2_C(m);
      call rotateMatrixRP2    ;rotateMatrixRP2_C(m);

      call shiftNumbersRP2    ;s1 = shiftNumbersRP2_C(m);
      mov  r8d, eax
      call addPairsRP2        ;p  = addPairsRP2_C(m);
      mov  r10d, eax
      call shiftNumbersRP2    ;s2 = shiftNumbersRP2_C(m);
      mov  r9d, eax

      call rotateMatrixRP2    ;rotateMatrixRP2_C(m);
      jmp  readKeyP2_moved

   readKeyP2_l:
   cmp al, 'l'                ;l:(108) avall
   jne  readKeyP2_u

      call shiftNumbersRP2    ;s1 = shiftNumbersRP2_C(m);
      mov  r8d, eax
      call addPairsRP2        ;p  = addPairsRP2_C(m);
      mov  r10d, eax
      call shiftNumbersRP2    ;s2 = shiftNumbersRP2_C(m);
      mov  r9d, eax
      jmp readKeyP2_moved

   readKeyP2_u:
   cmp al, 'u'                ; Undo
   jne  readKeyP2_ESC
      mov BYTE[state], '3'    ;state = '3';
      jmp  readKeyP2_End

   readKeyP2_ESC:
   cmp al, 27                 ; Sortir del programa
   jne readKeyP2_End
      mov BYTE[state], '0'    ;state='0';
   jmp readKeyP2_End

   readKeyP2_moved:
   add  r11d, r10d            ;actualScore = actualScore + p;
   cmp  r8d, 0                ;if ( (s1>0) ||
   jg  readKeyP2_status2
      cmp  r10d, 0            ;(p>0) ||
      jg  readKeyP2_status2
         cmp r9d, 0           ;(s2>0) )
         jg  readKeyP2_status2
            jmp readKeyP2_End
   readKeyP2_status2:         ;state = '2';
   mov  BYTE[state], '2'

   readKeyP2_End:
   mov eax, r11d              ;return actualScore;

   pop r11
   pop r10
   pop r9
   pop r8
   pop rdi
   pop rsi
   pop rdx
   pop rbx

   mov rsp, rbp
   pop rbp
   ret


;;;;;
; Verificar si s'ha arribat a 2048 o si no es pot fer algun moviment.
; Si hi ha el nombre 2048 a la matriu (m), canviar l'estat a 4
; (state='4') per a indicar que s'ha guanyat (WIN!).
; Si no hem guanyat, mirar si es pot fer algun moviment,
; Si no es pot fer cap moviment canviar l'estat a 5 (state='5') per a
; indicar que s'ha perdut (GAME OVER!!!).
; Recórrer la matriu (m) per files de dreta a esquerra i de baix a dalt
; comptant les caselles buides i mirant si hi ha el nombre 2048.
; Per recorrer la matriu en assemblador, en aquest cas, l'index va de la
; posició 30 (posició [3][3]) a la 0 (posició [0][0]) amb increments de
; 2 perquè les dades son de tipus short(WORD) 2 bytes.
; Per a accedir a una posició concreta de la matriu des d'assemblador
; cal tindre en compte que l'índex és:(index=(fila*DimMatrix+columna)*2),
; multipliquem per 2 perquè les dades son de tipus short(WORD) 2 bytes.
; Si hi ha el nombre 2048 posar l'estat a 4 (state='4') i acabar.
; Si no ni ha el nombre 2048 i no hi ha caselles buides mirar si es pot
; fer algun aparellament en horitzontal o en vertical. Per fer-ho cal
; copiar la matriu (m) sobre la matriu (mAux) cridant a la subrutina
; (copyMatrixP2), fer parelles a la matriu (mAux) per mirar si es
; poden fer parelles en horitzontal cridant a la subrutina(addPairsRP2)
; i guardar els punts obtinguts, rotar la matriu (mAux) cridant a la
; subrutina (rotateMatrixRP2) i copiar la matriu rotada (mRotated) a la
; matriu (mAux) cridant a la subrutina(copyMatrixP2), tornar a fer
; parelles a la matriu (mAux) per mirar si es poden fer parelles en
; vertical cridant a la subrutina (addPairsRP2) i acumular els punts
; obtinguts amb els punt obtinguts abans. Si el punts acumulats són
; zero, vol dir que no es poden fer parelles i s'ha de posar l'estat
; del joc a 5 (state='5').
; No es pot modificar ni la matriu (m), ni la matriu (mUndo).
;
; Variables globals utilitzades:
; m        : Adreça de la matriu que volem verificar.
; mAux     : Adreça de la matriu on copiarem les dades per fer verificacions.
; mRotated : Adreça de la matriu on es fa la rotació.
; state    : Estat del joc.
;
; Paràmetres d'entrada :
; Cap.
;
; Paràmetres de sortida:
; Cap.
;;;;;
checkEndP2:
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

   mov rax, 0 ; zeros
   mov rbx, 0 ; pairs

   mov rcx, DimMatrix*8 ; i

   primerWhile:
      sub rcx, 8 ; i--
      mov rdx, DimMatrix*2 ; j

      segonWhile:
         sub rdx, 2 ; j--

         movzx rsi, WORD[m+rcx+rdx]

         cmp rsi, 0
         jne comproba2048

         sumaZeros:
            inc rax

         comproba2048:
            cmp si, 2048
            jne condicioSegonWhile

         canviaState4:
            mov BYTE[state], '4'

      condicioSegonWhile:
         cmp rdx, 0
         jg segonaCondicioSegonWhile
         jmp condicioPrimerWhile

         segonaCondicioSegonWhile:
            cmp si, 2048
            jne segonWhile
            jmp condicioPrimerWhile

   condicioPrimerWhile:
      cmp rcx, 0
      jg segonaCondicioPrimerWhile
      jmp comprobaAcabat

      segonaCondicioPrimerWhile:
         cmp si, 2048
         jne primerWhile

   comprobaAcabat:
      cmp BYTE[state], '4'
      jne comprobaAcabatSegonaCondicio
      jmp fiComprobaAcabat

      comprobaAcabatSegonaCondicio:
         cmp rax, 0
         je comprobaMesMoviments
         jmp fiComprobaAcabat

      comprobaMesMoviments:
         mov rdi, mAux
         mov rsi, m
         call copyMatrixP2; rdi destinacio, rsi origen

         ; rdi ja es la matriu que volem fer parelles
         call addPairsRP2 ; rdi matriu per fer parelles, eax punts obtinguts

         ; rdi ja es la matriu que volem rotar
         call rotateMatrixRP2; rdi matriu que volem rotar

         mov r8d, eax ; guardem el valor actual de pairs a r8d

         ; rdi ja es la matriu que volem fer parelles
         call addPairsRP2 ; rdi matriu per fer parelles, eax punts obtinguts

         add r8d, eax ; sumem el nou resultat d'addPairs

         cmp r8d, 0
         jne fiComprobaAcabat
         mov BYTE[state], '5'


   fiComprobaAcabat:
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Mostrar un missatge a sota del tauler segons el valor de la variable
; (state), cridant la funció printMessageP2_C().
;
; Variables globals utilitzades:
; Cap
;
; Paràmetres d'entrada :
; Cap
;
; Paràmetres de sortida:
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printMessageP2:
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

   ; Cridem la funció printMessageP2_C() des d'assemblador.
   call printMessageP2_C

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
; Generar nova fitxa de forma aleatòria.
; Si hi ha com a mínim una casella buida a la matriu (m) genera una
; fila i una columna de forma aleatòria fins que és una de les caselles
; buides. A continuació generar un nombre aleatori per decidir si la
; nova fitxa ha de ser un 2 (90% dels casos) o un 4 (10% dels casos),
; cridant la funció insertTileP2_C().
;
; Variables globals utilitzades:
; Cap
;
; Paràmetres d'entrada :
; Cap
;
; Paràmetres de sortida:
; Cap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
insertTileP2:
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

   ; Cridem la funció insertTileP2_C() des d'assemblador.
   call insertTileP2_C

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
; Joc del 2048
; Funció principal del joc
; Permet jugar al joc del 2048 cridant totes les funcionalitats.
; Aquesta subrutina es dóna feta. NO LA PODEU MODIFICAR.
;
; Pseudo codi:
; Inicialitzar estat del joc, (state='1').
; Esborrar pantalla (cridar la funció clearScreen_C).
; Mostrar el tauler de joc (cridar la funció PrintBoardP2_C).
; Actualitza el contingut del Tauler de Joc i els punts que s'han fet
; (cridar la subrutina updateBoardP2).
; Mentre (state='1') fer
;   Copiar l'estat del joc (m i score) a (mAux  i scoreAux) (cridant la
;   subrutina copyMatrixP2) i copiant (score) a (scoreAux).
;   Llegir una tecla (cridar la subrutina readKeyP2). Segons la tecla
;     llegida cridarem a les funcions corresponents.
;     - ['i','j','k' o 'l'] desplaçar els números i fer les parelles
;                           segons la direcció triada.
;     - 'u'                 Recupera la jugada anterior (mUndo i
;                           scoreUndo) sobre (m i score) (cridant a la
;                           subrutina copyMatrixP2) i copiant (scoreAux)
;                           a (score)
;     - '<ESC>'  (codi ASCII 27) posar (state = '0') per a sortir.
;   Si hem mogut algun número al fer els desplaçaments o al fer les
;   parelles (state=='2'), copiar l'estat del joc que hem guardar abans
;   (mAux i scoreAux) sobre (mUndo i scoreUndo) per a poder fer l'Undo
;   (recuperar estat anterior) copiant (mAux) sobre (mUndo) (cridant a
;   la funció copyMatrixP2_C) i copiant (scoreAux) sobre (scoreUndo).
;   Generar una nova fitxa (cridant la subrutina insertTileP2 i posar
;   la variable sate a '1' (state='1').
;   Si hem de recuperar l'estat anterior (state='3'), copiar l'estat
;   anterior del joc que tenim a (mUndu i scoreUndu) sobre (m i score)
;   (cridant a la funció copyMatrixP2_C) i copiant (scoreUndu) sobre
;   (score) i posar la variable state a '1' (state='1').
;   Actualitza el contingut del Tauler de Joc i els punts que s'han fet
;   (cridar la subrutina updateBoardP2).
;   Verificar si s'ha arribat a 2048 o si no es pot fer cap moviment
;   (cridar la subrutina CheckEndP2).
;   Mostra un missatge a sota del tauler segons el valor de la variable
;   (state). (cridar la subrutina printMessageP2).
; Fi mentre.
; Sortir:
; S'acabat el joc.
;
; Variables globals utilitzades:
; state    : Estat del joc.
; m        : Adreça de la matriu que volem verificar
; mAux     : Adreça de la matriu on copiarem les dades per fer verificacions.
; mUndo    : Adreça de la matriu on copiarem la jugada anterior del joc.
; score    : marcador de punts.
; scoreAux : marcador de punts auxiliar.
; scoreUndo: marcador de punts anterior.
; state    : Estat del joc.
;
; Paràmetres d'entrada :
; Cap.
;
; Paràmetres de sortida:
; Cap.
;;;;;
playP2:
   push rbp
   mov  rbp, rsp

   push rax
   push rbx
   push rdx
   push rsi
   push rdi

   call clearScreen_C
   call printBoardP2_C

   mov  BYTE[state], '1' ;state : 0: Sortir, hem premut la tecla 'ESC' per a sortir.
			             ;        1: Continuem jugant.
			             ;        2: Continuem jugant però hi han hagut canvis a la matriu
			             ;        3: Desfer últim moviment.
			             ;        4: Guanyat, s'han arribat a la casella 2048
			             ;        5: Perdut, no es poden fer moviments

   mov  r10d, 290500        ;int score     = 290500;
   mov  r11d, 0             ;int scoreAux  = 0;
   mov  r12d, 1             ;int scoreUndu = 1;

   mov  edi, r10d
   call updateBoardP2

   playP2_Loop:                    ;while  {
   cmp  BYTE[state], '1'           ;(state == 1)
   jne  playP2_End

      mov edi, mAux
      mov esi, m
      call copyMatrixP2            ;copyMatrixP2_C(mAux,m);
      mov r11d, r10d               ;scoreAux = score
      mov edi,  r10d
      call readKeyP2               ;readKeyP2_C();
      mov r10d, eax
      cmp BYTE[state], '2'         ;(state == '2') //Si s'ha fet algun moviment,
      jne playP2_Next
         mov edi, mUndo
         mov esi, mAux
         call copyMatrixP2         ;copyMatrixP2_C(mUndo,mAux);guardem estat.
         mov  r12d, r11d           ;scoreUndo = scoreAux
         call insertTileP2         ;insertTileP2_C(); //Afegir fitxa (2 o 4)
         mov BYTE[state],'1'       ;state = '1';
         jmp playP2_Next
      cmp BYTE[state], '3'         ;(state == '3') //Desfer últim moviment
      jne playP2_Next
         mov  edi, m
		 mov  esi, mUndo
		 call copyMatrixP2         ;copyMatrixP2_C(m,mUndo);
		 mov  r10d, r12d           ;score = scoreUndo;
		 mov  BYTE[state], '1'     ;state = '1';
      playP2_Next:
      mov  edi, r10d
      call updateBoardP2           ;updateBoardP2_C(score);
      call checkEndP2              ;checkEndP2_C();
      call printMessageP2          ;printMessageP2_C();
      cmp BYTE[state], '3'         ;(state == '3') //Desfer últim moviment
      jne playP2_Loop
         mov edi, m
		 mov  esi, mUndo
		 call copyMatrixP2        ;copyMatrixP2_C(m,mUndo);
		 mov  r10d, r12d          ;score = scoreUndo;
		 mov  BYTE[state], '1'    ;state = '1';
		 mov  edi, r10d
		 call updateBoardP2
   jmp playP2_Loop

   playP2_End:


   pop rdi
   pop rsi
   pop rdx
   pop rbx
   pop rax

   mov rsp, rbp
   pop rbp
   ret
