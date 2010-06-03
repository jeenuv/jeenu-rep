" Vim syntax file for mmp/mmh files

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore

syn match  mmpComment "//.*$"
syn region mmpComment start="/\*" end="\*\/"

syn keyword mmpKeyword aif asspabi assplibrary aaspexports baseaddress
syn keyword mmpKeyword debuglibrary deffile document epocheapsize
syn keyword mmpKeyword epocprocesspriority epocstacksize exportunfrozen
syn keyword mmpKeyword lang library linkas nostrictdef option option_replace
syn keyword mmpKeyword resource source sourcepath srcdbg startbitmap
syn keyword mmpKeyword start end staticlibrary strictdepend systeminclude
syn keyword mmpKeyword systemresource target targettype targetpath uid romtarget
syn keyword mmpKeyword userinclude win32_library capability epocallowdlldata exportlibrary
syn keyword mmpKeyword smpsafe firstlib

syn match mmpIfdef "^\s*#\(include\|ifdef\|ifndef\|if\|endif\|else\|elif\|define\).*$" contains=mmpComment
syn match mmpMacro "^\s*macro.*$" contains=mmpComment

syn match   mmpNumber "\d+"
syn match   mmpNumber "0x\x\+"


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if !exists("did_mmp_syntax_inits")
  let did_mmp_syntax_inits=1

  hi def link mmpComment    Comment
  hi def link mmpKeyword    Keyword
  hi def link mmpMacro      Keyword
  hi def link mmpNumber     Number
  hi def link mmpIfdef      PreCondit
endif

let b:current_syntax = "mmp"
