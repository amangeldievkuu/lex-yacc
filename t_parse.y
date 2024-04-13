%{
 #include <stdio.h>
 #include <stdlib.h>
 #include "t2c.h"
 #include "t_parse.h"
%}
%token lWRITE lREAD lIF lASSIGN
%token lRETURN lBEGIN lEND
%left lEQU lNEQ lGT lLT lGE lLE
%left lADD lMINUS
%left lTIMES lDIVIDE
%token lLP lRP
%token lINT lREAL
%token lELSE
%token lMAIN
%token lSEMI lCOMMA
%token lID lINUM lRNUM lQSTR
%expect 1
%%
prog : mthdcls
 { printf("Program -> MethodDecls\n");
 printf("Parsed OK!\n"); }
 |
 { printf("****** Parsing failed!\n"); }
 ;


mthdcls : mthdcl mthdcls
 { printf("MethodDecls -> MethodDecl MethodDecls\n"); }
 | mthdcl
 { printf("MethodDecls -> MethodDecl\n"); }
 ;


type : lINT
 { printf("Type -> INT\n"); }
 | lREAL
 { printf("Type -> REAL\n"); }
 ;

mthdcl : type lMAIN lID lLP formals lRP block
 { printf("MethodDecl -> Type MAIN ID LP Formals RP Block\n"); }
 | type lID lLP formals lRP block
 { printf("MethodDecl -> Type ID LP Formals RP Block\n"); }
 ;

formals : formal oformal
 { printf("Formals -> Formal OtherFormals\n"); }
 |
 { printf("Formals -> \n"); }
 ;

formal : type lID
 { printf("Formal -> Type ID\n"); }
 ;

oformal : lCOMMA formal oformal
 { printf("OtherFormals -> COMMA Formal OtherFormals\n"); }
 |
 { printf("OtherFormals -> \n"); }
 ;


block: lBEGIN statements lEND
 {printf("Block -> BEGIN Statement End\n"); }
 ;


statements: statement statements
 {printf("Statements-> Statement Statements\n");}
 |
 {printf("Statements->\\n\n");}
 ;


statement: block
 {printf("Statement -> Block\n");}
 |
 localvardcl
 {printf("Statement -> LocalVarDecl\n");}
 |
 assignstmt
 {printf("Statement -> AssignStmt\n");}
 |
 returnstmt
 {printf("Statement -> ReturnStmt\n");}
 |
 ifstmt
 {printf("Statement -> IfStmt\n");}
 |
 writestmt
 {printf("Statement -> WriteStmt\n");}
 |
 readstmt
 {printf("Statement -> ReadStmt\n");}
 ;

localvardcl: type lID lSEMI {printf("LocalVarDecl -> Type Id ';'\n");}
 |
 type assignstmt
 {printf("LocalVarDecl -> Type AssignStmt\n");}
 ;

assignstmt: lID lASSIGN expr lSEMI
 {printf("AssignStmt -> Id := Expression ';'\n"); }
 ;

returnstmt: lRETURN expr lSEMI
 {printf("ReturnStmt -> RETURN Expression ';'\n");}
 ;

ifstmt: lIF lLP boolexpr lRP statement
 {printf("IfStmt -> IF '(' BoolExpression ')' Statement\n");}
 |
 lIF lLP boolexpr lRP statement lELSE statement
 {printf("IfStmt -> IF '(' BoolExpression ')' Statement ELSE Statement\n");}
 ;

writestmt: lWRITE lLP expr lCOMMA lQSTR lRP lSEMI
 {printf("WriteStmt -> WRITE '(' Expression ',' QSTRING ')' ';'\n");}
 ;

readstmt: lREAD lLP lID lCOMMA lQSTR lRP lSEMI
 {printf("ReadStmt -> READ '(' Id ',' QString ')' ';'\n");}
 ;

expr: multexpr multexprs
 {printf("Expression -> MultiplcativeExpr MultiplcativeExprs\n");}
;

multexprs: addsub multexpr multexprs
 {printf("MultExprs -> (('+' | '-') MultExpr Multexprs)\n");}
 |
 {printf("MultExprs -> \\n\n");}
 ;

addsub: lADD
 {printf("Sign->'+'\n");}
 |
 lMINUS
 {printf("Sign->'-'\n");}
 ;

muldiv: lTIMES
 {printf("Sign->'*'\n");} |
 lDIVIDE
 {printf("Sign->'/'\n");}
 ;

multexpr: primaryexpr primaryexprs
 {printf("MultiplicativeExpr -> PrimaryExpr PrimaryExprs");}
 ;

primaryexprs: muldiv primaryexpr primaryexprs
 {printf("PrimaryExprs -> ('*'|'/') PrimaryExpr PrimaryExprs\n");}
 |
 {printf("PrimaryExprs-> \\n\n");}
 ;

primaryexpr: num
 {printf("PrimaryExpr -> Num\n");}
 |
 lID
 {printf("PrimaryExpr -> Id\n");}
 |
 lLP expr lRP
 {printf("PrimaryExpr -> '(' Expression ')'\n");}
 |
 lID lLP actualparams lRP
 {printf("PrimaryExpr -> Id '(' ActualParams ')'\n");}
 ;

num: lINT
 {printf("Num -> Integer");}
 |
 lREAL
 {printf("Num -> Real Number");}
 ;

boolexpr: expr lEQU expr
 {printf("BoolExpr -> Expression '==' Expression\n");}
 |
 expr lNEQ expr
 {printf("BoolExpr -> Expression '!=' Expression\n");}
 |
 expr lGT expr
 {printf("BoolExpr -> Expression '>' Expression\n");}
 |
 expr lGE expr
 {printf("BoolExpr -> Expression '>=' Expression\n");}
 |
 expr lLT expr {printf("BoolExpr -> Expression '<' Expression\n");}
 |
 expr lLE expr
 {printf("BoolExpr -> Expression '<=' Expression\n");}
 ;

params:
 lCOMMA expr params
 {printf(", Expression")}
 |
 {printf("\n");}
 ;

actualparams: expr params
 {printf("ActualParams -> Expression");}
 ;

%%
int yyerror(char *s)
{
 printf("%s\n",s);
 return 1;
}
