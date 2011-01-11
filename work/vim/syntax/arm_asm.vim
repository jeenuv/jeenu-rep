
if version < 600
        syntax clear
elseif exists("b:current_syntax")
        finish
endif

syn case ignore

"comments
syn match armComment            '[;@].*$'

"numbers
syn match armNumber             '=\@<=[a-zA-Z_][a-zA-Z0-9_]\+\>'
syn match armNumber             '#[0-9]\+\>'
syn match armNumber             '#\?0x[A-Fa-f0-9]\+\>'
syn match armNumber             '#[a-zA-Z][a-zA-z0-9_]\+\>'
syn match armNumber             '\<-\?[0-9]\+\>'
syn match armNumber             '\<-\?[0-9a-fA-F]\+\>'
syn match armNumber             '\$[A-Za-z.0-9_]\+\>'
syn match armNumber             '|[^|]\+|'

syn match armString             '"[^"]*"'

" Operators
"syn match armOperator          '[(),\[\]{}!#<]'

" Conditional fields
syn match armConditional        '\(eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)s\?\>' contained

" Stack fields
syn keyword armStack              IA IB DA DB FA FD EA ED contained

" Length modifiers
syn keyword armLenModif           B SB H SH contained

"
" Registers
syn match armRegister           "\<[CRP][0-9]\>"
syn match armRegister           "\<[CRP]1[0-5]\>"
syn keyword armRegister         LR PC SP CPSR CPSR_C CPSR_CF SPSR

"" Instructions
for pat in ["MOV", "MVN", "M\(RS\|SR\)"]
    exe "syn match armMoveKeyword " . '"\<' . pat . '\w\{,3\}"' . " contains=armConditional"
endfor

for pat in ['ADD', 'ADC', 'SUB', 'SBC', 'RSB', 'MUL', 'MLA', '[US]M\(ULL\|LAL\)', 'CLZ']
    exe "syn match armArithmKeyword " . '"\<' . pat . '\w\{,3\}"' . " contains=armConditional"
endfor

for pat in ['TST', 'TEQ', 'AND', 'EOR', 'ORR', 'BIC', 'LS\(R\|L\)', 'NOP']
    exe "syn match armLogicKeyword " . '"\<' . pat . '\w\{,3\}"' . " contains=armConditional"
endfor

for pat in ['CMP', 'CMN']
    exe "syn match armCompareKeyword " . '"\<' . pat . '\w\{,3\}"' . " contains=armConditional"
endfor

for pat in ['LDR\(EX\)\?', 'LDM']
    exe "syn match armLoadKeyword " . '"\<' . pat . '\w\{,3\}"' . " contains=armConditional"
endfor

for pat in ['STR\(EX\)\?', 'STM']
    exe "syn match armStoreKeyword " . '"\<' . pat . '\w\{,3\}"' . " contains=armConditional"
endfor

for pat in ['WF[EI]', 'SEV']
    exe "syn match armWaitKeyword " . '"\<' . pat . '\w\{,3\}"' . " contains=armConditional"
endfor

for pat in ['MCRR\?', 'MRR\?C']
    exe "syn match armInstruction " . '"\<' . pat . '\w\{,3\}"' . " contains=armConditional"
endfor

syn match armBranchKeyword "\<BL\?X\?\w\{,3\}" contains=armConditional

syn keyword armInstruction      HALT SWI ASL ASR ROR RRX SETCPSR SETSPSR GETCPSR DSB DMB ISB CLREX MSR MRS PUSH POP

syn keyword armAssembler        IF ELIF ELSE ENDIF MACRO MEND EXPORT IMPORT GBLL INCLUDE CODE READONLY ALIGN AREA END DCB DCD DCDU DCW DCWU DCDO SPACE FILL SETL SETA DWORD ROUT
syn match   armAssembler        "^[a-zA-Z0-9_]\+:\?" contains=armComment
syn match   armAssembler        "%[FB][AT][0-9]\([a-zA-Z0-9]\+\)\?"
syn match   armAssembler        ":\(L\?OR\|L\?AND\|DEF\|LNOT\):"
syn match   armAssembler        "{\(TRUE\|FALSE\)}"
syn match   armAssembler        '\.\w\+\>'

"pseudo instructions
syn keyword armPseudoKeyword    ORG DW DB DS EQU END BASE
syn match armPseudoKeyword      "%[FB][AT][0-9]\([a-zA-Z0-9_]\+\)\?"
syn match armPseudoKeyword      "\<ADRL\?\w\{,3\}" contains=armConditional


syn case ignore

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_arm_syntax_inits")
        if version < 508
                let did_arm_syntax_inits = 1
                command -nargs=+ HiLink hi link <args>
        else
                command -nargs=+ HiLink hi def link <args>
        endif

        HiLink  armMoveKeyword          Statement
        HiLink  armArithmKeyword        Statement
        HiLink  armLogicKeyword         Statement
        HiLink  armCompareKeyword       Statement
        HiLink  armBranchKeyword        Statement
        HiLink  armLoadKeyword          Statement
        HiLink  armStoreKeyword         Statement
        HiLink  armInstruction          Statement
        HiLink  armWaitKeyword          Statement

        HiLink  armRegister             Type
        HiLink  armConditional          Identifier
        HiLink  armStack                Identifier

        HiLink  armLenModif             Special
        HiLink  armAssembler            Special
        HiLink  armPseudoKeyword        Special

        HiLink  armComment              Comment
        HiLink  armString               String

        HiLink  armNumber               Number
        HiLink  armPseudoConstant       Number

        delcommand HiLink
endif

let b:current_syntax = "arm"
