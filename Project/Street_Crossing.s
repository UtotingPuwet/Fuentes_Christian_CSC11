//bare bones source file
.global main

.equ INPUT, 0
.equ OUTPUT, 1
.equ LOW, 0
.equ HIGH, 1

.equ RED, 27 //gpio 27 phys 36
.equ YELLOW, 28//gpio 28 phys 38
.equ GREEN, 29//gpio 29 phys 40

.equ BUTTON, 26 //gpio 26 phys 32
.equ GO, 24 //gpio 24 phys 39
.equ STOP, 25 //gpio 25 phys 37

//gpio 6 = phys 22

.align 4
.section .rodata
// all constant data goes here

.align 4
.section .bss
// all uninitialized data goes here

.align 4
.data
// all non-constant, initialized data goes here
.align 4
.text
main: push {lr} // save link register, this one of many ways this can be done
        bl wiringPiSetup

        mov r0, #GREEN
        bl pinOut

        mov r0, #STOP
        bl pinOut

        mov r0, #GREEN
        bl pinOn

        mov r0, #STOP
        bl pinOn

        ldr r0, =#5000
        bl delay

        mov r0, #GREEN
        bl pinOff

        mov r0, #YELLOW
        bl pinOut

        mov r0, #YELLOW
        bl pinOn

        ldr r0, =#5000
        bl delay

        mov r0, #YELLOW
        bl pinOff

        mov r0, #STOP
        bl pinOff
beginning:      
        mov r0, #RED
        bl pinOut

        mov r0, #GO
        bl pinOut

        mov r0, #BUTTON
        bl pinIn

        mov r0, #RED
        bl pinOn

        mov r0, #GO
        bl pinOn

        mov r0, #20
        bl action

        cmp r0, #HIGH

        beq done

 done:

        mov r0, #RED
        bl pinOff

        mov r0, #GO
        bl pinOff


        mov r0, #0 //return code for your program (must be 8 bits)
        pop {pc}

pinOn:
        push {lr}
        mov r1, #HIGH
        bl digitalWrite
        pop {pc}

pinOff:
        push {lr}
        mov r1, #LOW
        bl digitalWrite
        pop {pc}

pinIn: 
        push {lr}
        mov r1, #INPUT
        bl pinMode
        pop {pc} 
pinOut:
        push {lr}
        mov r1, #OUTPUT
        bl pinMode
        pop {pc}
action:
        //r0 is going going hold seconds 

        push {r4, r5, lr}
        mov r4, r0          //ok so now r4 holds the seconds to wait
        mov r0, #0
        bl time
        mov r5, r0
action_loop:
        bl read_button
        cmp r0, #HIGH
        beq end_action_press
        mov r0, #0
        bl time
        sub r0, r0, r5
        cmp r0, r4
        blt action_loop
        mov r0, #0
        b end_action
end_action_press:
        mov r0, #RED
        bl pinOff
        mov r0, #GO
        bl pinOff
        mov r0, #1
        b end_action
end_action:
        pop {r4, r5, pc}

read_button:
        push {lr}
        mov r0, #BUTTON
        bl digitalRead
        pop {pc}
