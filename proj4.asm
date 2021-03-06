Array       .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0
            .INT    0

CNT         .INT    0       # max size of count is 30

EOT         .BYT        3
NL          .BYT        10
Space       .BYT        32

COMMA       .BYT        44

ZERO        .INT    0
I           .INT    1
II          .INT    2
III         .INT    3
IV          .INT    4
V           .INT    5
VI          .INT    6
VII         .INT    7
VIII        .INT    8
IX          .INT    9
X           .INT    10

cZERO       .BYT    48
cI          .BYT    49
cII         .BYT    50
cIII        .BYT    51
cIV         .BYT    52
cV          .BYT    53
cVI         .BYT    54
cVII        .BYT    55
cVIII       .BYT    56
cIX         .BYT    57


# Program strings
fib_str1    .BYT    70      # F
            .BYT    105     # i
            .BYT    98      # b
            .BYT    111     # o
            .BYT    110     # n
            .BYT    110     # n
            .BYT    97      # a
            .BYT    99      # c
            .BYT    99      # c
            .BYT    105     # i
            .BYT    32  
            .BYT    111     # o
            .BYT    102     # f
            .BYT    32     
            .BYT    3

fib_str2    .BYT    32
            .BYT    105     # i
            .BYT    115     # s
            .BYT    32
            .BYT    3

part1&2_str   .BYT    80      # P
            .BYT    97      # a
            .BYT    114     # r
            .BYT    116     # t
            .BYT    32          
            .BYT    49      # 1
            .BYT    32      
            .BYT    97      # a
            .BYT    110     # n
            .BYT    100     # d
            .BYT    32      
            .BYT    50      # 2
            .BYT    58      # :
            .BYT    10
            .BYT    3


part3_str   .BYT    80      # P
            .BYT    97      # a
            .BYT    114     # r
            .BYT    116     # t
            .BYT    32          
            .BYT    51      # 3
            .BYT    58      # :
            .BYT    10
            .BYT    3





# ~~~~~~~~~~~~~~~~~~~~~~ Function printf ~~~~~~~~~~~~~~~~~~~~~~~~~
printf  MOV     R6      FP 
        ADI     R6      -32         # bypass RA, PFP, and Registers
        LDR     R1      R6          # R1 holding address of error message
        LDB     R3      R1

p_char  LDB     R0      EOT
        CMP     R0      R3          # if the current byte is the EOT character then end the print loop
        BRZ     R0      end_p   
        TRP     3    
        ADI     R1      1
        LDB     R3      R1
        JMP     p_char

        # begin return call
end_p   MOV     SP      FP
        MOV     R4      SP          
        ADI     R4      -4      # point at PFP
        LDR     FP      R4
        MOV     R6      SP
        CMP     R6      SB
        BGT     R6      UNDERFLOW

        LDR     R8      ZERO    # Return 0
    # store return value
    # function complete. return to caller
        MOV     R6      SP      # 
        LDR     R6      R6      # R6 has return address
        STR     R8      SP      # set return value 
        JMR     R6
# ~~~~~~~~~~~~~ END PRINTF ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




###### int fib(int n) ######
fib     MOV     R8      SP          # test for SO with Ret Addr + PFP + passed parameter + locals and temps
        ADI     R8      -16          # space for 5 int temps
        CMP     R8      SL           # test for SO
        BLT     R8      OVERFLOW
        ADI     SP      -20          # adjust SP to word on top of AR

        MOV     R6      FP          # 
        ADI     R6      -32         # location for param n
        LDR     R5      R6
        MOV     R7      R5
        ADI     R7      -1
        ADI     R6      -4
        STR     R7      R6          # store (n-1) in t1
        ADI     R7      -1
        ADI     R6      -4
        STR     R7      R6          # store (n-2) in t2
        
        MOV     R6      FP          # 
        ADI     R6      -32         # location for param n
        LDR     R8      R6
        LDR     R5      I           # if (n <= 1)
        CMP     R5      R8
        BLT     R5      fib_else
    # return n
        MOV     SP      FP
        MOV     R4      SP          
        ADI     R4      -4      # point at PFP
        LDR     FP      R4
        MOV     R6      SP
        CMP     R6      SB
        BGT     R6      UNDERFLOW

    # store return value
    # function complete. return to caller
        MOV     R6      SP      # SP points to return adddress
        LDR     R6      R6
        STR     R8      SP      # set return value 
        JMR     R6

    # prepare for else condition call
fib_else MOV     R8      SP          # compute space needed for activation record
        ADI     R8      -4          # Adjust for space needed (Rtn Address & PFP)
        ADI     R8      -4          # Adjust for space for passed paramters
        ADI     R8      -24         # Space for R1-R6
        CMP     R8      SL          # test for SO
        BLT     R8      OVERFLOW

    # Store RA and PFP
        MOV     R8      FP          # Save FP in R8, this will be the PFP
        ADI     FP      -36         # t1
        LDR     R1      FP
        MOV     FP      SP          # Point at Current Activation Record (FP = SP)
        ADI     SP      -0          # Adjust SP for Rtn Address. To be pushed on later
        MOV     R6      SP          # R6 holding address for Rtn Address
        ADI     SP      -4          # Space for PFP
        STR     R8      SP          # PFP to Top of Stack

    # Save registers
        ADI     SP      -4
        STR     R1      SP
        ADI     SP      -4
        STR     R2      SP
        ADI     SP      -4
        STR     R3      SP
        ADI     SP      -4
        STR     R4      SP
        ADI     SP      -4
        STR     R5      SP
        ADI     SP      -4
        STR     R6      SP

    # Pass parameters on the stack
        ADI     SP      -4
        STR     R1      SP          # t1 = n-1
        
    # Update the return address in the Stack Frame
        ADI     SP      -4          # SP points to word before activation rec
        MOV     R7      PC
        ADI     R7      48          # Compute Return Address (12 * # of instructions until instruction after JMP)
        STR     R7      R6          # push return address on the stack. R7 is holding ret address -> R6 holding stack location for ret address
        
    # Jump to function    
        JMP     fib
    
    # Restore registers
        MOV     R7      FP
        ADI     R7      -8
        LDR     R1      R7 
        ADI     R7      -4
        LDR     R2      R7
        ADI     R7      -4
        LDR     R3      R7
        ADI     R7      -4
        LDR     R4      R7
        ADI     R7      -4
        LDR     R5      R7
        ADI     R7      -4
        LDR     R6      R7

    # get fib(n) return value
        LDR     R3      SP          # should be store in a temp
        MOV     R6      FP          # 
        ADI     R6      -44         # location for t3
        STR     R3      R6          # store return value in t3

    # prepare for fib(n-2)
        MOV     R8      SP          # compute space needed for activation record
        ADI     R8      -4          # Adjust for space needed (Rtn Address & PFP)
        ADI     R8      -4          # Adjust for space for passed paramters
        ADI     R8      -24         # Space for R1-R6
        CMP     R8      SL          # test for SO
        BLT     R8      OVERFLOW

    # Store RA and PFP
        MOV     R8      FP          # Save FP in R8, this will be the PFP
        ADI     FP      -40         # t2
        LDR     R1      FP
        MOV     FP      SP          # Point at Current Activation Record (FP = SP)
        ADI     SP      -0          # Adjust SP for Rtn Address. To be pushed on later
        MOV     R6      SP          # R6 holding address for Rtn Address
        ADI     SP      -4          # Space for PFP
        STR     R8      SP          # PFP to Top of Stack
 
    # Save registers
        ADI     SP      -4
        STR     R1      SP
        ADI     SP      -4
        STR     R2      SP
        ADI     SP      -4
        STR     R3      SP
        ADI     SP      -4
        STR     R4      SP
        ADI     SP      -4
        STR     R5      SP
        ADI     SP      -4
        STR     R6      SP
        
    # Pass parameters on the stack
        ADI     SP      -4
        STR     R1      SP          # t2 = n-2
        
    # Update the return address in the Stack Frame
        ADI     SP      -4          # SP points to word before activation rec
        MOV     R7      PC
        ADI     R7      48          # Compute Return Address (12 * # of instructions until instruction after JMP)
        STR     R7      R6          # push return address on the stack. R7 is holding ret address -> R6 holding stack location for ret address
        
    # Jump to function    
        JMP     fib

    # Restore registers
        MOV     R7      FP
        ADI     R7      -8
        LDR     R1      R7 
        ADI     R7      -4
        LDR     R2      R7
        ADI     R7      -4
        LDR     R3      R7
        ADI     R7      -4
        LDR     R4      R7
        ADI     R7      -4
        LDR     R5      R7
        ADI     R7      -4
        LDR     R6      R7

    # get fib(n) return value from TOS -4 (prev act record)
        LDR     R3      SP          
        MOV     R6      FP          
        ADI     R6      -48         
        STR     R3      R6          # store return value in t4

    # set t5 (t3+t4)
        MOV     R6      FP
        ADI     R6      -44
        LDR     R7      R6      # t3
        ADI     R6      -4
        LDR     R8      R6      # t4
        ADD     R8      R7
        ADI     R6      -4
        STR     R8      R6        # store val in t5
        # MOV     R8      R6      # R8 holding addr or t5

    # begin return call
        MOV     SP      FP
        MOV     R4      SP          
        ADI     R4      -4      # point at PFP
        LDR     FP      R4
        MOV     R6      SP
        CMP     R6      SB
        BGT     R6      UNDERFLOW

    # store return value
    # function complete. return to caller
        MOV     R6      SP      # 
        LDR     R6      R6      # R6 has return address
        STR     R8      SP      # set return value 
        JMR     R6




################# PART 1 ########################
START   MOV     R8      SP          # compute space needed for activation record
        ADI     R8      -4          # Adjust for space needed (Rtn Address & PFP)
        ADI     R8      -4          # Adjust for space for passed paramter n
        ADI     R8      -24         # Space for R1-R6
        CMP     R8      SL          # test for SO
        BLT     R8      OVERFLOW

    # store RA and PFP
        MOV     R8      FP          # Save FP in R8, this will be the PFP
        MOV     FP      SP          # Point at Current Activation Record (FP = SP)
        ADI     SP      -0          # Adjust SP for Rtn Address. To be pushed on later
        MOV     R6      SP          # R6 holding address for Rtn Address
        ADI     SP      -4          # Space for PFP
        STR     R8      SP          # PFP to Top of Stack

    # Save registers
        ADI     SP      -4
        STR     R1      SP
        ADI     SP      -4
        STR     R2      SP
        ADI     SP      -4
        STR     R3      SP
        ADI     SP      -4
        STR     R4      SP
        ADI     SP      -4
        STR     R5      SP
        ADI     SP      -4
        STR     R6      SP
        
    # Pass parameters on the stack
        ADI     SP      -4
        LDA     R4      part1&2_str
        STR     R4      SP          

    # Update the return address in the Stack Frame
        ADI     SP      -4          # SP points to word before activation rec
        MOV     R7      PC
        ADI     R7      48          # Compute Return Address (12 * # of instructions until instruction after JMP)
        STR     R7      R6          # push return address on the stack. R7 is holding ret address -> R6 holding stack location for ret address
        
    # Jump to function    
        JMP     printf
    
    # Restore registers
        MOV     R7      FP
        ADI     R7      -8
        LDR     R1      R7 
        ADI     R7      -4
        LDR     R2      R7
        ADI     R7      -4
        LDR     R3      R7
        ADI     R7      -4
        LDR     R4      R7
        ADI     R7      -4
        LDR     R5      R7
        ADI     R7      -4
        LDR     R6      R7

    # Call fib()

ffib    TRP 98   
        MOV     R8      SP          # compute space needed for activation record
        ADI     R8      -4          # Adjust for space needed (Rtn Address & PFP)
        ADI     R8      -4          # Adjust for space for passed paramter n
        ADI     R8      -24         # Space for R1-R6
        CMP     R8      SL          # test for SO
        BLT     R8      OVERFLOW

        TRP     2                   # get int from user
        LDB     R1      ZERO        # check stop condition
        CMP     R1      R3
        BRZ     R1      fib_stop

    # store RA and PFP
        MOV     R8      FP          # Save FP in R8, this will be the PFP
        MOV     FP      SP          # Point at Current Activation Record (FP = SP)
        ADI     SP      -0          # Adjust SP for Rtn Address. To be pushed on later
        MOV     R6      SP          # R6 holding address for Rtn Address
        ADI     SP      -4          # Space for PFP
        STR     R8      SP          # PFP to Top of Stack

    # Save registers
        ADI     SP      -4
        STR     R1      SP
        ADI     SP      -4
        STR     R2      SP
        ADI     SP      -4
        STR     R3      SP
        ADI     SP      -4
        STR     R4      SP
        ADI     SP      -4
        STR     R5      SP
        ADI     SP      -4
        STR     R6      SP
        
    # Pass parameters on the stack
        ADI     SP      -4
        STR     R3      SP          # n value for fib(n)

    # Push X into the Array
        LDA     R5      Array
        LDR     R4      CNT
        LDR     R1      IV
        MUL     R4      R1
        ADD     R5      R4
        STR     R3      R5
        LDR     R4      CNT
        ADI     R4      1
        STR     R4      CNT    

    # Update the return address in the Stack Frame
        ADI     SP      -4          # SP points to word before activation rec
        MOV     R7      PC
        ADI     R7      48          # Compute Return Address (12 * # of instructions until instruction after JMP)
        STR     R7      R6          # push return address on the stack. R7 is holding ret address -> R6 holding stack location for ret address
        
    # Jump to function    
        JMP     fib
    
    # Restore registers
        MOV     R7      FP
        ADI     R7      -8
        LDR     R1      R7 
        ADI     R7      -4
        LDR     R2      R7
        ADI     R7      -4
        LDR     R3      R7
        ADI     R7      -4
        LDR     R4      R7
        ADI     R7      -4
        LDR     R5      R7
        ADI     R7      -4
        LDR     R6      R7


    # get fib(n) return value from TOS -4 (prev act record)
        LDR     R5      SP

    # Push Y into the Array
        LDA     R4      Array
        LDR     R7      CNT
        LDR     R1      IV
        MUL     R7      R1
        ADD     R4      R7
        STR     R5      R4
        LDR     R7      CNT
        ADI     R7      1
        STR     R7      CNT 

    # prepare for printf
        MOV     R8      SP          # compute space needed for activation record
        ADI     R8      -4          # Adjust for space needed (Rtn Address & PFP)
        ADI     R8      -4          # Adjust for space for passed paramter n
        ADI     R8      -24         # Space for R1-R6
        CMP     R8      SL          # test for SO
        BLT     R8      OVERFLOW

    # store RA and PFP
        MOV     R8      FP          # Save FP in R8, this will be the PFP
        MOV     FP      SP          # Point at Current Activation Record (FP = SP)
        ADI     SP      -0          # Adjust SP for Rtn Address. To be pushed on later
        MOV     R6      SP          # R6 holding address for Rtn Address
        ADI     SP      -4          # Space for PFP
        STR     R8      SP          # PFP to Top of Stack

    # Save registers
        ADI     SP      -4
        STR     R1      SP
        ADI     SP      -4
        STR     R2      SP
        ADI     SP      -4
        STR     R3      SP
        ADI     SP      -4
        STR     R4      SP
        ADI     SP      -4
        STR     R5      SP
        ADI     SP      -4
        STR     R6      SP
        
    # Pass parameters on the stack
        ADI     SP      -4
        LDA     R4      fib_str1
        STR     R4      SP          

    # Update the return address in the Stack Frame
        ADI     SP      -4          # SP points to word before activation rec
        MOV     R7      PC
        ADI     R7      48          # Compute Return Address (12 * # of instructions until instruction after JMP)
        STR     R7      R6          # push return address on the stack. R7 is holding ret address -> R6 holding stack location for ret address
        
    # Jump to function    
        JMP     printf
    
    # Restore registers
        MOV     R7      FP
        ADI     R7      -8
        LDR     R1      R7 
        ADI     R7      -4
        LDR     R2      R7
        ADI     R7      -4
        LDR     R3      R7
        ADI     R7      -4
        LDR     R4      R7
        ADI     R7      -4
        LDR     R5      R7
        ADI     R7      -4
        LDR     R6      R7

    # print fib value
        TRP     1
        MOV     R3      R5
        
    # prepare for printf
        MOV     R8      SP          # compute space needed for activation record
        ADI     R8      -4          # Adjust for space needed (Rtn Address & PFP)
        ADI     R8      -4          # Adjust for space for passed paramter n
        ADI     R8      -24         # Space for R1-R6
        CMP     R8      SL          # test for SO
        BLT     R8      OVERFLOW

    # store RA and PFP
        MOV     R8      FP          # Save FP in R8, this will be the PFP
        MOV     FP      SP          # Point at Current Activation Record (FP = SP)
        ADI     SP      -0          # Adjust SP for Rtn Address. To be pushed on later
        MOV     R6      SP          # R6 holding address for Rtn Address
        ADI     SP      -4          # Space for PFP
        STR     R8      SP          # PFP to Top of Stack

    # Save registers
        ADI     SP      -4
        STR     R1      SP
        ADI     SP      -4
        STR     R2      SP
        ADI     SP      -4
        STR     R3      SP
        ADI     SP      -4
        STR     R4      SP
        ADI     SP      -4
        STR     R5      SP
        ADI     SP      -4
        STR     R6      SP
        
    # Pass parameters on the stack
        ADI     SP      -4
        LDA     R4      fib_str2
        STR     R4      SP          

    # Update the return address in the Stack Frame
        ADI     SP      -4          # SP points to word before activation rec
        MOV     R7      PC
        ADI     R7      48          # Compute Return Address (12 * # of instructions until instruction after JMP)
        STR     R7      R6          # push return address on the stack. R7 is holding ret address -> R6 holding stack location for ret address
        
    # Jump to function    
        JMP     printf
    
    # Restore registers
        MOV     R7      FP
        ADI     R7      -8
        LDR     R1      R7 
        ADI     R7      -4
        LDR     R2      R7
        ADI     R7      -4
        LDR     R3      R7
        ADI     R7      -4
        LDR     R4      R7
        ADI     R7      -4
        LDR     R5      R7
        ADI     R7      -4
        LDR     R6      R7

    # print fib value
        TRP     1
        LDB     R3      NL
        TRP     3
        
        JMP ffib

fib_stop    TRP 99

################# PART 2 ########################

        LDB     R3      NL
        TRP     3
        LDR     R6      ZERO
        LDR     R2      I
        LDR     R1      IV
w_parr  LDA     R4      Array
        MOV     R7      R6
        MUL     R7      R1
        ADD     R4      R7
        LDR     R3      R4
        TRP     1
        LDB     R3      COMMA
        TRP     3
        LDB     R3      Space
        TRP     3
        ADI     R6      1
        LDA     R4      Array
        LDR     R5      CNT
        SUB     R5      R2
        MUL     R5      R1
        ADD     R4      R5
        LDR     R3      R4
        TRP     1
        ADI     R2      1
        LDR     R5      CNT
        LDR     R4      II
        DIV     R5      R4
        MOV     R7      R6
        CMP     R7      R5
        BRZ     R7      e_w_parr
        LDB     R3      COMMA
        TRP     3
        LDB     R3      Space
        TRP     3
        JMP     w_parr


 e_w_parr   LDB     R3      NL
            TRP     3
            TRP 3
 

################# PART 3 ########################

        MOV     R8      SP          # compute space needed for activation record
        ADI     R8      -4          # Adjust for space needed (Rtn Address & PFP)
        ADI     R8      -4          # Adjust for space for passed paramter n
        ADI     R8      -24         # Space for R1-R6
        CMP     R8      SL          # test for SO
        BLT     R8      OVERFLOW

    # store RA and PFP
        MOV     R8      FP          # Save FP in R8, this will be the PFP
        MOV     FP      SP          # Point at Current Activation Record (FP = SP)
        ADI     SP      -0          # Adjust SP for Rtn Address. To be pushed on later
        MOV     R6      SP          # R6 holding address for Rtn Address
        ADI     SP      -4          # Space for PFP
        STR     R8      SP          # PFP to Top of Stack

    # Save registers
        ADI     SP      -4
        STR     R1      SP
        ADI     SP      -4
        STR     R2      SP
        ADI     SP      -4
        STR     R3      SP
        ADI     SP      -4
        STR     R4      SP
        ADI     SP      -4
        STR     R5      SP
        ADI     SP      -4
        STR     R6      SP
        
    # Pass parameters on the stack
        ADI     SP      -4
        LDA     R4      part3_str
        STR     R4      SP          

    # Update the return address in the Stack Frame
        ADI     SP      -4          # SP points to word before activation rec
        MOV     R7      PC
        ADI     R7      48          # Compute Return Address (12 * # of instructions until instruction after JMP)
        STR     R7      R6          # push return address on the stack. R7 is holding ret address -> R6 holding stack location for ret address
        
    # Jump to function    
        JMP     printf
    
    # Restore registers
        MOV     R7      FP
        ADI     R7      -8
        LDR     R1      R7 
        ADI     R7      -4
        LDR     R2      R7
        ADI     R7      -4
        LDR     R3      R7
        ADI     R7      -4
        LDR     R4      R7
        ADI     R7      -4
        LDR     R5      R7
        ADI     R7      -4
        LDR     R6      R7



        TRP     0       # END OF PROGRAM


UNDERFLOW   TRP     0
OVERFLOW    TRP     0