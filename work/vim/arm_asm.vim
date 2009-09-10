" Vim syntax file
" Language:     ARM assembler
" Maintainer:   Goran Jakovljevic <goran.jakovljevic@fer.hr>
" Last Change:  2002 May 15

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
        syntax clear
elseif exists("b:current_syntax")
        finish
endif

syn case match

"identifiers
"syn match armIdentifier        "[a-zA-Z][0-9a-zA-Z]*"

"comments
syn match armComment            ";.*$"

"numbers
syn match armNumber             "=[a-zA-Z][a-zA-Z0-9_]\+\>"
syn match armNumber             "#[0-9]\+\>"
syn match armNumber             "#\?0x[A-Fa-f0-9]\+\>"
syn match armNumber             "#[a-zA-Z][a-zA-z0-9_]\+\>"
syn match armNumber             "\<[0-9]\+\>"
syn match armNumber             "[-+][0-9]\+\>"
syn match armNumber             "[-+][0-9a-fA-F]\+\>"

syn match armString             "\"[^"]*\""

"operators
"syn match armOperator          "[(),\[\]{}!#<]"

"conditional fields
syn match armConditional        "\(eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)" contained
syn match armConditional        "s\>" contained

"stack fields
syn match armStack              "ia\|ib\|da\|db\|fa\|fd\|ea\|ed" contained

"length modifiers
syn match armLenModif           "b\|sb\|h\|sh" contained

syn case ignore
"
"registers
syn match armRegister           "\<[CRP][0-9]"
syn match armRegister           "\<R1[0-5]"
syn match armRegister           "\<P1[0-5]"
syn keyword armRegister         LR PC SP CPSR SPSR


"instructions
syn match armMoveKeyword        "\<MOV\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|s\)\>" contains=armConditional
syn match armMoveKeyword        "\<MVN\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|s\)\>" contains=armConditional
syn match armMoveKeyword        "\<MRS\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\>" contains=armConditional
syn match armMoveKeyword        "\<MSR\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\>" contains=armConditional

syn match armArithmKeyword      "\<ADD\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|s\)\>" contains=armConditional
syn match armArithmKeyword      "\<ADC\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|s\)\>" contains=armConditional
syn match armArithmKeyword      "\<SUB\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|s\)\>" contains=armConditional
syn match armArithmKeyword      "\<SBC\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|s\)\>" contains=armConditional
syn match armArithmKeyword      "\<RSB\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|s\)\>" contains=armConditional
syn match armArithmKeyword      "\<RSC\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|s\)\>" contains=armConditional
syn match armArithmKeyword      "\<MUL\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|s\)\>" contains=armConditional
syn match armArithmKeyword      "\<MLA\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|s\)\>" contains=armConditional
syn match armArithmKeyword      "\<UMULL\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|s\)\>" contains=armConditional
syn match armArithmKeyword      "\<UMLAL\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|s\)\>" contains=armConditional
syn match armArithmKeyword      "\<SMULL\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|s\)\>" contains=armConditional
syn match armArithmKeyword      "\<SMLAL\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|s\)\>" contains=armConditional
syn match armArithmKeyword      "\<CLZ\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\>" contains=armConditional

syn match armLogicKeyword       "\<TST\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\>" contains=armConditional
syn match armLogicKeyword       "\<TEQ\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\>" contains=armConditional
syn match armLogicKeyword       "\<AND\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|s\)\>" contains=armConditional
syn match armLogicKeyword       "\<EOR\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|s\)\>" contains=armConditional
syn match armLogicKeyword       "\<ORR\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|s\)\>" contains=armConditional
syn match armLogicKeyword       "\<BIC\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|s\)\>" contains=armConditional
syn match armLogicKeyword       "\<NOP\>"

syn match armCompareKeyword     "\<CMP\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\>" contains=armConditional
syn match armCompareKeyword     "\<CMN\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\>" contains=armConditional

syn match armBranchKeyword      "\<BL\?X\?\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\>" contains=armConditional

syn match armLoadKeyword        "\<LDR\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|b\|sb\|h\|sh\)\>" contains=armConditional,armLenModif
syn match armLoadMKeyword       "\<LDM\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(IA\|IB\|DA\|DB\|FD\|ED\|FA\|EA\)\>" contains=armConditional,armStack

syn match armStoreKeyword       "\<STR\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(\|b\|h\)\>" contains=armConditional,armLenModif
syn match armStoreMKeyword      "\<STM\(\|eq\|ne\|cs\|hs\|cc\|lo\|mi\|pl\|vs\|vc\|hi\|ls\|ge\|lt\|gt\|le\|al\)\(IA\|IB\|DA\|DB\|FD\|ED\|FA\|EA\)\>" contains=armConditional,armStack

syn keyword armInstruction      HALT SWI MCR MRC LSL ASL LSR ASR ROR RRX SETCPSR SETSPSR GETCPSR ADR

syn keyword armAssembler        IF ELSE ENDIF MACRO MEND EXPORT IMPORT GBLL INCLUDE CODE READONLY ALIGN AREA END DCB DCD DCDU DCW DCWU DCDO SPACE FILL SETL
syn match   armAssembler        "[a-zA-Z_][a-zA-Z0-9_]\+\s\+rout"
syn match   armAssembler        "^[a-zA-Z0-9_]\+\s*$"
syn match   armAssembler        "%[FB][AT][0-9]\([a-zA-Z0-9]\+\)\?"
syn match   armAssembler        ":\(OR\|LOR\|AND\|LAND\|DEF\|LNOT\):"
syn match   armAssembler        "{\(TRUE\|FALSE\)}"

"pseudo instructions
syn match armPseudoKeyword      "`\(ORG\|DW\|\DB\|DS\|EQU\|END\|BASE\)"
syn keyword armPseudoKeyword    DW DB DH
syn match armPseudoKeyword      "%[FB][AT][0-9]\([a-zA-Z0-9_]\+\)\?"


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
        HiLink  armStack                Special
        HiLink  armAssembler            Special
        HiLink  armComment              Comment
        HiLink  armPseudoKeyword        Special
        HiLink  armNumber               Number
        HiLink  armString               String
        HiLink  armPseudoConstant       Number

        delcommand HiLink
endif

let b:current_syntax = "arm"

" vim: ts=8
