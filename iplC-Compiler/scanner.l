%{
// This part goes directly into the generated parser

#include "scanner.hh"
#include "parser.tab.hh"

// YY_DECL is bound to the type of the scanner. The default is 
// #define YY_DECL int Scanner::yylex()
// which is generated anyway.

//If you want the type of the generated scanner to be different, do this

#undef  YY_DECL
#define YY_DECL int IPL::Scanner::yylex( IPL::Parser::semantic_type * const lval, IPL::Parser::location_type *location )

//We want these to be the first action after a token is recognized. 

#define YY_USER_ACTION loc->step(); loc->columns(yyleng);

// token_type is a short hand for IPL::Parser::token
using token_type = IPL::Parser::token;

%}


/* %option debug */
%option nodefault
%option yyclass="Scanner"
%option noyywrap
%option c++

BIG_PART        [0-9]+
SMOL_PART       [0-9]*
EXPONENT_PART   ([eE][+-]([0-9])+)|([eE]([0-9])+)
WITHOUT_SLASH   [^\\\"]*

%%

%{ /** Code executed at the beginning of yylex **/

      yylval = lval;

%}

[ \t\n\r]                             //skip
"/*"([^*]|\*+[^*/])*\*+"/"            //skip, it is a comment
struct          {   
       yylval->emplace< std::string >( YYText() );
       return token_type::STRUCT;
}
void                            {   
       yylval->emplace< std::string >( YYText() );
       return token_type::VOID;
}
int                         {   
       yylval->emplace< std::string >( YYText() );
       return token_type::INT;  
}
float                    {   
       yylval->emplace< std::string >( YYText() );
       return token_type::FLOAT;    
} 
while                     {   
       yylval->emplace< std::string >( YYText() );
       return token_type::WHILE;
}
for            {
      yylval->emplace< std::string >( YYText() );
      return token_type::FOR;
}
if            {
      yylval->emplace< std::string >( YYText() );
      return token_type::IF;
}
else            {
      yylval->emplace< std::string >( YYText() );
      return token_type::ELSE;
}
([1-9][0-9]*)|(0[bB][01]*)|(0[0-7]*)|(0[xX][0-9a-fA-F]*)            {
      yylval->emplace< std::string >( YYText() );
      return token_type::INT_CONSTANT;
}
(({BIG_PART}"."{SMOL_PART})|({SMOL_PART}"."{BIG_PART})){EXPONENT_PART}?            {
      yylval->emplace< std::string >( YYText() );
      return token_type::FLOAT_CONSTANT;
}
"||"            {
      yylval->emplace< std::string >( YYText() );
      return token_type::OR_OP;
}
"&&"            {
      yylval->emplace< std::string >( YYText() );
      return token_type::AND_OP;
}
return            {
      yylval->emplace< std::string >( YYText() );
      return token_type::RETURN;
}
"=="            {
      yylval->emplace< std::string >( YYText() );
      return token_type::EQ_OP;
}
"!="            {
      yylval->emplace< std::string >( YYText() );
      return token_type::NE_OP;
}
"<="            {
      yylval->emplace< std::string >( YYText() );
      return token_type::LE_OP;
}
">="            {
      yylval->emplace< std::string >( YYText() );
      return token_type::GE_OP;
}
"++"            {
      yylval->emplace< std::string >( YYText() );
      return token_type::INC_OP;
}
"->"            {
      yylval->emplace< std::string >( YYText() );
      return token_type::PTR_OP;
}
\"({WITHOUT_SLASH}\\(\"|t|n|\\))*{WITHOUT_SLASH}\"            {
      yylval->emplace< std::string >( YYText() );
      return token_type::STRING_LITERAL;
}
[[:alpha:]_][[:alnum:]_]*            {
      yylval->emplace< std::string >( YYText() );
      return token_type::IDENTIFIER;
}
";"                               return ';';
"{"                               return '{';
"}"                               return '}';
"="                               return '=';
"("                               return '(';
")"                               return ')';
"<"                               return '<';
">"                               return '>';
"["                               return '[';
"]"                               return ']';
","                               return ',';
"-"                               return '-';
"!"                               return '!';
"&"                               return '&';
"+"                               return '+';
"*"                               return '*';
"/"                               return '/';
"."                               return '.';  
<<EOF>>         yyterminate();
.            {
      yylval->emplace< std::string >( YYText() );
      return token_type::OTHERS;
};


%%

