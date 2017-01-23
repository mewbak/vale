module Ast

open Microsoft.FSharp.Math

type loc = {loc_file:string; loc_line:int; loc_col:int; loc_pos:int}

type id = Id of string | Reserved of string | Operator of string

type typ =
| TName of id
| TApp of typ * typ list

type ghost = Ghost | NotGhost
type stmt_modifier = SmPlain | SmGhost | SmInline
type formal = id * typ option

type uop = 
| UNot | UNeg | UOld | UIs of id
| UConst
| UReveal | UGhostOnly | UToOperand | UUnrefinedSpec
| UCustom of string | UCustomAssign of string

type bop =
| BEquiv | BImply | BExply | BAnd | BOr
| BEq | BNe | BLt | BGt | BLe | BGe | BIn
| BAdd | BSub | BMul | BDiv | BMod
| BOldAt
| BCustom of string

//type mop =
//| MTuple | MList | MSet

type op =
| Uop of uop
| Bop of bop
//| MultiOp of mop
| Subscript
| Update
| Cond
| FieldOp of id
| FieldUpdate of id
//| CodeLemmaOp // one expression for code, a different expression for lemmas
| RefineOp // one expression for abstract, one expression for abstract with optional oldness, one expression for refined
| StateOp of id * string * typ // example: (eax, "reg", int) for va_get_reg(EAX, ...exps..., state):int
| OperandArg of id * string * typ

type bindOp =
| Forall
| Exists
| Lambda
| BindLet
| BindSet

type exp =
| ELoc of loc * exp
| EVar of id
| EInt of bigint
| EReal of string
| EBitVector of int * bigint
| EBool of bool
| EString of string
| EOp of op * exp list
| EApply of id * exp list
| EBind of bindOp * exp list * formal list * triggers * exp
and triggers = exp list list

type attr = id * exp list
type attrs = attr list

type var_alias =
| AliasThread // thread-local variable, such as register
| AliasLocal // procedure-local variable
type var_storage =
| XGhost // ghost, no storage space
| XPhysical // ordinary non-ghost variable (supplies its own storage space)
| XOperand of string // procedure operand argument (procedure caller determines storage)
| XInline // inline procedure argument (procedure caller supplies constant that gets inlined)
| XAlias of var_alias * exp // variable is a name for some other storage
| XState of exp // top-level declaration of member of the state (e.g. a register)

type is_invariant = IsInv | NotInv
type lhs = id * (typ option * ghost) option
type stmt =
| SLoc of loc * stmt
| SLabel of id
| SGoto of id
| SReturn
| SAssume of exp
| SAssert of is_invariant * exp
| SCalc of bop option * calcContents list
| SSplit
| SVar of id * typ option * var_storage * attrs * exp option
| SAssign of lhs list * exp
| SBlock of stmt list
| SIfElse of stmt_modifier * exp * stmt list * stmt list
| SWhile of exp * (loc * exp) list * (loc * exp list) * stmt list
| SForall of formal list * triggers * exp * exp * stmt list
| SExists of formal list * triggers * exp
and calcContents =
| CalcLine of exp
| CalcHint of bop option * stmt list

type spec =
| Requires of exp
| Ensures of exp
| Modifies of bool * exp // false => reads, true => modifies

type inline_kind = Outline | Inline
type inout = In | Out | InOut
type pformal = id * typ * var_storage * inout * attrs

type fun_decl =
  {
    fname:id;
    fghost:ghost;
    fargs:formal list;
    fret:typ;
    fbody:exp option;
    fattrs:attrs;
  }

type proc_decl =
  {
    pname:id;
    pghost:ghost;
    pinline:inline_kind;
    pargs:pformal list;
    prets:pformal list;
    pspecs:(loc * spec) list;
    pbody:stmt list option;
    pattrs:attrs;
  }

type decl =
| DVar of id * typ * var_storage * attrs
| DFun of fun_decl
| DProc of proc_decl
| DVerbatim of string list

type decls = (loc * decl) list

type include_decl = {inc_loc:loc; inc_attrs:attrs; inc_path:string}

let expAt (l:loc) (e:exp):exp = ELoc (l, e)
let stmtAt (l:loc) (s:stmt):stmt list = [SLoc (l, s)]