lexer grammar DmscSrcLexer;

SEA_WS	
	: (' '|'\t'|'\r'? '\n')+ -> channel(HIDDEN) 
	;

OPEN
	: '<' -> pushMode(CHECK_DAMASCUS_TAG) 
	;

SLASH_OPEN
	: '</' -> pushMode(CHECK_DAMASCUS_TAG)
	;
	
TEXT
	: ~[<]+
	| '<%'
	;

// ----------------- Check if Damascus tags ---------------------
mode CHECK_DAMASCUS_TAG;

RootDecl
	: 'dmsc:root' S? -> pushMode(INSIDE_TAG) 
	;
	
SyncDecl
	: 'dmsc:sync' S? -> pushMode(INSIDE_TAG) 
	;

OTHER_TEXT
	: . -> more, mode(DEFAULT_MODE)
	;
			
// ----------------- Everything INSIDE of a tag ---------------------
mode INSIDE_TAG;

CLOSE       :   '>'                  -> mode(DEFAULT_MODE) ;
SLASH_CLOSE :   '/>'                 -> mode(DEFAULT_MODE) ;
SLASH       :   '/' ;
EQUALS      :   '=' ;
STRING      :   '"' ~[<"]* '"'
            |   '\'' ~[<']* '\''
            ;
Name        :   NameStartChar NameChar* ;
S           :   [ \t\r\n]            -> channel(HIDDEN) ;

fragment
HEXDIGIT    :   [a-fA-F0-9] ;

fragment
DIGIT       :   [0-9] ;

fragment
NameChar    :   NameStartChar
            |   '-' | '_' | '.' | DIGIT
            |   '\u00B7'
            |   '\u0300'..'\u036F'
            |   '\u203F'..'\u2040'
            ;

fragment
NameStartChar
            :   [:a-zA-Z]
            |   '\u2070'..'\u218F'
            |   '\u2C00'..'\u2FEF'
            |   '\u3001'..'\uD7FF'
            |   '\uF900'..'\uFDCF'
            |   '\uFDF0'..'\uFFFD'
            ;
