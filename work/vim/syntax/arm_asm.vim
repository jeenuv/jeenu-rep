
if version < 600
        syntax clear
elseif exists("b:current_syntax")
        finish
endif

syn case ignore

"comments
syn match armComment            ";.*$"

"numbers
syn match armNumber             "=\@<=[a-zA-Z][a-zA-Z0-9_]\+\>"
syn match armNumber             "#[0-9]\+\>"
syn match armNumber             "#\?0x[A-Fa-f0-9]\+\>"
syn match armNumber             "#[a-zA-Z][a-zA-z0-9_]\+\>"
syn match armNumber             "\<-\?[0-9]\+\>"
syn match armNumber             "\<-\?[0-9a-fA-F]\+\>"
syn match armNumber             "\$[A-Za-z.0-9_]\+\>"
syn match armNumber             "|[^|]\+|"

syn match armString             "\"[^"]*\""

"operators
"syn match armOperator          "[(),\[\]{}!#<]"

"conditional fields
syn match armConditional        "\(eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\|s\)\>" contained

"stack fields
syn keyword armStack              IA IB DA DB FA FD EA ED contained

"length modifiers
syn keyword armLenModif           B SB H SH contained

"
"registers
syn match armRegister           "\<[CRP][0-9]\>"
syn match armRegister           "\<[CRP]1[0-5]\>"
syn keyword armRegister         LR PC SP CPSR CPSR_C CPSR_CF SPSR


"instructions
syn match armMoveKeyword        "\<MOV\(..\)\?s\?\>" contains=armConditional
syn match armMoveKeyword        "\<MVN\(..\)\?s\?\>" contains=armConditional
syn match armMoveKeyword        "\<M\(RS\|SR\)\(..\)\?s\?\>" contains=armConditional

syn match armArithmKeyword      "\<ADD\(..\)\?s\?\>" contains=armConditional
syn match armArithmKeyword      "\<ADC\(..\)\?s\?\>" contains=armConditional
syn match armArithmKeyword      "\<SUB\(..\)\?s\?\>" contains=armConditional
syn match armArithmKeyword      "\<SBC\(..\)\?s\?\>" contains=armConditional
syn match armArithmKeyword      "\<RSB\(..\)\?s\?\>" contains=armConditional
syn match armArithmKeyword      "\<RSC\(..\)\?s\?\>" contains=armConditional
syn match armArithmKeyword      "\<MUL\(..\)\?s\?\>" contains=armConditional
syn match armArithmKeyword      "\<MLA\(..\)\?s\?\>" contains=armConditional
syn match armArithmKeyword      "\<UMULL\(..\)\?s\?\>" contains=armConditional
syn match armArithmKeyword      "\<UMLAL\(..\)\?s\?\>" contains=armConditional
syn match armArithmKeyword      "\<SMULL\(..\)\?s\?\>" contains=armConditional
syn match armArithmKeyword      "\<SMLAL\(..\)\?s\?\>" contains=armConditional
syn match armArithmKeyword      "\<CLZ\(..\)\?s\?\>" contains=armConditional

syn match armLogicKeyword       "\<TST\(..\)\?s\?\>" contains=armConditional
syn match armLogicKeyword       "\<TEQ\(..\)\?s\?\>" contains=armConditional
syn match armLogicKeyword       "\<AND\(..\)\?s\?\>" contains=armConditional
syn match armLogicKeyword       "\<EOR\(..\)\?s\?\>" contains=armConditional
syn match armLogicKeyword       "\<ORR\(..\)\?s\?\>" contains=armConditional
syn match armLogicKeyword       "\<BIC\(..\)\?s\?\>" contains=armConditional
syn match armLogicKeyword       "\<LS\(R\|L\)\(..\)\?s\?\>" contains=armConditional
syn match armLogicKeyword       "\<NOP\>"

syn match armCompareKeyword     "\<CMP\(..\)\?s\?\>" contains=armConditional
syn match armCompareKeyword     "\<CMN\(..\)\?s\?\>" contains=armConditional

syn match armBranchKeyword      "\<BL\?X\?\(..\)\?s\?\>" contains=armConditional

syn match armLoadKeyword        "\<LDR\(..\)\?s\?\>" contains=armConditional
syn match armLoadMKeyword       "\<LDM\(..\)\?s\?\>" contains=armConditional

syn match armStoreKeyword       "\<STR\(..\)\?s\?\>" contains=armConditional
syn match armStoreMKeyword      "\<STM\(..\)\?s\?\>" contains=armConditional

syn keyword armInstruction      HALT SWI MCR MRC ASL ASR ROR RRX SETCPSR SETSPSR GETCPSR

syn keyword armAssembler        IF ELIF ELSE ENDIF MACRO MEND EXPORT IMPORT GBLL INCLUDE CODE READONLY ALIGN AREA END DCB DCD DCDU DCW DCWU DCDO SPACE FILL SETL SETA DWORD
syn match   armAssembler        "[a-zA-Z_][a-zA-Z0-9_]\+\s\+rout"
syn match   armAssembler        "^[a-zA-Z0-9_]\+\s*$"
syn match   armAssembler        "%[FB][AT][0-9]\([a-zA-Z0-9]\+\)\?"
syn match   armAssembler        ":\(L\?OR\|L\?AND\|DEF\|LNOT\):"
syn match   armAssembler        "{\(TRUE\|FALSE\)}"

"pseudo instructions
syn keyword armPseudoKeyword    ORG DW DB DS EQU END BASE
syn match armPseudoKeyword      "%[FB][AT][0-9]\([a-zA-Z0-9_]\+\)\?"
syn match armPseudoKeyword      "\<ADRL\?\(..\)\?s\?\>" contains=armConditional


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
        HiLink  armLoadMKeyword         Statement
        HiLink  armStoreKeyword         Statement
        HiLink  armStoreMKeyword        Statement
        HiLink  armInstruction          Statement
        HiLink  armRegister             Type
        HiLink  armAsmKeyword           Statement
        HiLink  armConditional          Identifier
        HiLink  armLenModif             Special
        HiLink  armStack                Identifier
        HiLink  armAssembler            Special
        HiLink  armComment              Comment
        HiLink  armPseudoKeyword        Special
        HiLink  armNumber               Number
        HiLink  armString               String
        HiLink  armPseudoConstant       Number

        delcommand HiLink
endif

let b:current_syntax = "arm"
