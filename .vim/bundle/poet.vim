" poet.vim - Vim syntax file for POET
"
" Language:     POET
" Maintainer:   jichi <jguo@cs.utsa.edu>
" Since:        8/22/2010
" Update:       9/12/2010
" See:          c.vim, html.vim, xml.vim
"
" INSTALL:
" - Put this file into '~/.vim/syntax/'.
" - Add following codes into to '~/.vimrc'.
"
"    aug syntax
"    au  BufNewFile,BufReadPost *.pt,*.pi,*.code,*.incl,*.tune set ft=poet
"    aug end
"
" TODO (8/23/2010): Recognize ptTagAttr context.

" Clear existing syntax
"if exists("b:current_syntax")
"  finish
"endif
syn clear

"runtime! syntax/html.vim
"unlet b:current_syntax
"syn case match

" Statements
syn keyword     ptStatement     BREAK CONTINUE BREAK
syn keyword     ptConditional   if else switch
syn keyword     ptLabel         case default
syn keyword     ptRepeat        for foreach foreach_r

syn keyword     ptTodo          contained TODO FIXME XXX

" Operators
syn keyword     ptOperator      EVAL
syn keyword     ptOperator      REPLACE REBUILD COPY INSERT
syn keyword     ptOperator      PERMUTE
syn keyword     ptOperator      ERROR PRINT CLEAR DEBUG

" Functions
syn keyword     ptFunction      car cdr
syn keyword     ptFunction      ParseList BuildList MergeList AppendList
                              \ ReverseList FlatternList CountList SortList
                              \ SkipEmpty FirstToken NextToken
syn keyword     ptFunction      DistributeLoops FuseLoops PeelLoop BlockLoops
                              \ UnrollLoops PermuteLoops UnrollJam ScalarRepl

" Types
syn keyword     ptType          CODE GLOBAL TRACE XFORM TRACE
syn keyword     ptType          LIST TUPLE MAP
syn keyword     ptType          INT FLOAT STRING ID
syn keyword     ptType          VALUE EXP
syn keyword     ptType          Char String FileName Comment UnknownUntilEOL
                              \ Name NameList NameOrStringList
syn keyword     ptType          Bop Uop FunctionCall ArrayAccess Macro TypeDef
                              \ Type Loop Nest Assign If Else Stmt StmtList

syn match       ptUserType      "\w\+#"

" Constants
syn keyword     ptConstant      TRUE FALSE
syn keyword     ptConstant      "_"

" Macros
syn keyword     ptMacro         TOKEN KEYWORDS PARSE UNPARSE NoParse BACKTRACK
syn keyword     ptMacro         PARSE_BOP PARSE_UOP PARSE_CALL PARSE_ARRAY

" Instructions
syn match       ptInclude       "^include"       

" Literals
syn region      ptString        start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=@Spell
syn match       ptCharacter     "'[^\\]'"
syn region      ptAnnot         start=+@+ end=+@+
  \ contains=ptConditional,ptLabel,ptStatement,ptLabel,ptNumbers,ptString,@Spell

syn match       ptNumbers       display transparent "\<\d\|\.\d"
  \ contains=ptNumber,ptFloat
syn match       ptNumber        display contained "\d\+\(u\=l\{0,2}\|ll\=u\)\>"
"floating point number, with dot, optional exponent
syn match       ptFloat	        display contained "\d\+\.\d*\(e[-+]\=\d\+\)\=[fl]\="
"floating point number, starting with a dot, optional exponent
syn match       ptFloat	        display contained "\.\d\+\(e[-+]\=\d\+\)\=[fl]\=\>"

" Tags
"syn region      ptTag           start="<[^/]" end=">"
"  \ contains=ptTagName,ptTagAttr,@Spell
syn region      ptTag           start="<[^/]" end="\s\|$"
  \ contains=ptTagName ",ptTagAttr,@Spell
syn region      ptEndTag        start="</" end=">"
  \ contains=ptTagName ",ptTagError
syn match       ptTagError      contained "[^>]<"ms=s+1
"syn region      ptTagAttr       start="" end=""
"  \ contains=ptNumbers,ptString

syn keyword     ptTagName       contained input output parameter
syn keyword     ptTagName       contained code xform
syn keyword     ptTagName       contained eval
syn keyword     ptTagName       contained define trace

"syn region      ptXformTag      start="<[^/]xform" end="\s\|$"
"  \ contains=ptUserFunction ",ptTagAttr,@Spell
"syn match       ptUserFunction  contained "\w+"

" Specials
syn keyword     ptSpecial       "+" "-" "*" "/"
syn keyword     ptSpecial       "=" ":"
syn keyword     ptSpecial       "==" "!=" "<=" ">=" "<" ">"
syn keyword     ptSpecial       "!" "&&" "||"
syn keyword     ptSpecial       "=>" "#" "::"

" Comments
"syn region      ptComment       transparent start="<\*" end="\*>" contains=ALLBUT,poetCommentError
syn region      ptTagComment    start="<\*" end="\*>" contains=ptTodo,@Spell
syn region      ptLineComment   start="<<" end="$" contains=ptTodo,ptCommentError,@Spell
syn match       ptCommentError  contained "\*>"

syn cluster     ptCommentGroup  contains=ptTodo,ptTagComment,ptLineComment

" Parentheses
"syn region      ptParen         transparent start="(" end=")" contains=ALLBUT,ptParenError,@Spell
"syn region      ptBracket       transparent start="\[" end="\]" contains=ALLBUT,ptBracketError,@Spell
"syn region      ptBlock         transparent start="{" end="}" contains=ALLBUT,ptBlockError,@Spell
"syn match       ptParenError    ")"
"syn match       ptBracketError  "]"
"syn match       ptBlockError    "}"

"syn sync lines=10

" Defines the default highlighting
if !exists("poet_syntax_init")
  let poet_syntax_init = 1
  " The default methods for highlighting.  Can be overridden later
  hi link ptLabel               Label
  hi link ptConditional         Conditional
  hi link ptRepeat              Repeat
  hi link ptStatement           Statement

  hi link ptInclude             Include
  hi link ptType                Type
  hi link ptUserType            Type
  hi link ptOperator            Operator
  hi link ptMacro               Macro
  hi link ptFunction            Function
  hi link ptUserFunction        Function
  hi link ptSpecial             Special

  hi link ptCharacter           Character
  hi link ptString              String
  hi link ptAnnot               Identifier
  hi link ptConstant            Constant
  hi link ptNumber              Number
  hi link ptFloat               Float     

  hi link ptTag                 Function
  hi link ptTagName             Statement
  hi link ptEndTag              Identifier

  hi link ptTodo                Todo
  hi link ptTagComment          Comment
  hi link ptLineComment         Comment

  hi link ptTagError            ptError
  hi link ptCommentError        ptError
  hi link ptParenError          ptError
  hi link ptBracket             ptError
  hi link ptBlockError          ptError
  hi link ptError               Error
endif

let b:current_syntax = "poet"

" vim: ts=8
