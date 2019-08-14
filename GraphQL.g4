/*
The MIT License (MIT)

Copyright (c) 2019 Alexander Zaytsev

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

grammar GraphQL;

document
   : definition+
   ;

definition
   : executableDefinition | typeSystemDefinition | typeSystemExtension
   ;

executableDefinition
   : operationDefinition | fragmentDefinition
   ;

operationDefinition
   : operationType NAME? variableDefinitions? directives? selectionSet | selectionSet
   ;

operationType
   : 'query' | 'mutation' | 'subscription'
   ;

selectionSet
   : '{' selection+ '}'
   ;

selection
   : field | fragmentSpread | inlineFragment
   ;

field
   : alias? NAME arguments? directives? selectionSet?
   ;

alias
   : NAME ':'
   ;

arguments
   : '(' argument+ ')'
   ;

argument
   : NAME ':' value
   ;

fragmentSpread
   : '...' fragmentName directives?
   ;

inlineFragment
   : '...' typeCondition? directives? selectionSet
   ;

fragmentDefinition
   : 'fragment' fragmentName typeCondition directives? selectionSet
   ;

fragmentName
   : NAME
   ;

typeCondition
   : 'on' namedType
   ;
 
value
   : variable
   | intValue    
   | floatValue  
   | stringValue 
   | booleanValue
   | nullValue   
   | enumValue  
   | listValue
   | objectValue
   ;

intValue
   : INT
   ;

floatValue
   : FLOAT
   ;

stringValue
   : STRING
   ;

booleanValue
   : 'true'
   | 'false'
   ;

nullValue
   : 'null'
   ;

enumValue
   : NAME
   ;
   
listValue
   : '[' value+ ']'
   ;
   
objectValue
   : '{' value+ '}'
   ;
   
objectField
   : NAME ':' value
   ;

variableDefinitions
   : '(' variableDefinition+ ')'
   ;

variableDefinition
   : variable ':' type defaultValue?
   ;

variable
   : '$' NAME
   ;

defaultValue
   : '=' value
   ;
   
type
   : namedType
   | listType
   | nonNullType
   ;

namedType
   : NAME
   ;
   
listType
   : '[' type ']'
   ;

nonNullType
   : namedType '!'
   | listType '!'
   ;

directives
   : directive+
   ;

directive
   : '@' NAME ':' arguments?
   ;

typeSystemDefinition
   : schemaDefinition
   | typeDefinition
   | directiveDefinition
   ;

typeSystemExtension
   : schemaExtension
   | typeExtension
   ;
   
schemaDefinition
   : 'schema' directives? '{' operationTypeDefinition+ '}'
   ;

schemaExtension
   : 'extend schema' directives? '{' operationTypeDefinition+ '}'
   | 'extend schema' directives
   ;

operationTypeDefinition
   : operationType ':' NAME
   ;
   
description
   : stringValue
   ;

typeDefinition
   : scalarTypeDefinition
   | objectTypeDefinition
   | interfaceTypeDefinition
   | unionTypeDefinition
   | enumTypeDefinition
   | inputObjectTypeDefinition
   ;
   
typeExtension
   : scalarTypeExtension
   | objectTypeExtension
   | interfaceTypeExtension
   | unionTypeExtension
   | enumTypeExtension
   | inputObjectTypeExtension   
   ;

scalarTypeDefinition
   : description? 'scalar' NAME directives?
   ;
   
scalarTypeExtension
   : 'extend scalar' NAME directives?
   ;

objectTypeDefinition
   : description? 'type' NAME implementsInterfaces? directives? fieldsDefinition?
   ;
   
objectTypeExtension
   : 'extend type' NAME implementsInterfaces? directives? fieldsDefinition
   | 'extend type' NAME implementsInterfaces? directives
   | 'extend type' NAME implementsInterfaces
   ;
   
implementsInterfaces
   : 'implements' '&'? namedType
   | implementsInterfaces '&' namedType
   ;

fieldsDefinition
   : '{' fieldDefinition+ '}'
   ;

fieldDefinition
   : description? NAME argumentsDefinition? ':' type directives?
   ;

argumentsDefinition
   : '(' inputValueDefinition+ ')'
   ;

inputValueDefinition
   : description? NAME ':' type defaultValue? directives?
   ;
   
interfaceTypeDefinition
   : description? 'interface' NAME directives? fieldsDefinition?
   ;

interfaceTypeExtension
   : 'extend interface' NAME directives? fieldsDefinition
   | 'extend interface' NAME directives?
   ;
   
unionTypeDefinition
   : description? 'union' NAME directives? unionMemberTypes?
   ;

unionMemberTypes
   : '=' '|'? namedType
   | unionMemberTypes '|' namedType
   ;
   
unionTypeExtension
   : 'extend union' NAME directives? unionMemberTypes
   | 'extend union' NAME directives
   ;
   
enumTypeDefinition
   : description? 'enum' NAME directives? enumValuesDefinition?
   ;

enumValuesDefinition
   : '{' enumValueDefinition+ '}'
   ;
   
enumValueDefinition
   : description? enumValue directives?
   ;

enumTypeExtension
   : 'extend enum' NAME directives? enumValuesDefinition
   | 'extend enum' NAME directives
   ;
   
inputObjectTypeDefinition
   : description? 'input' NAME directives? inputFieldsDefinition?
   ;

inputFieldsDefinition
   : '{' inputValueDefinition+ '}'
   ;

inputObjectTypeExtension
   : 'extend input' NAME directives? inputFieldsDefinition
   | 'extend input' NAME directives
   ;

directiveDefinition
   : description? 'directive @' NAME argumentsDefinition? 'on' directiveLocations
   ;

directiveLocations
   : directiveLocation ( '|' directiveLocation )*
   ;
   
directiveLocation
   : executableDirectiveLocation
   | typeSystemDirectiveLocation
   ;
   
executableDirectiveLocation
   : 'QUERY'
   | 'MUTATION'
   | 'SUBSCRIPTION'
   | 'FIELD'
   | 'FRAGMENT_DEFINITION'
   | 'FRAGMENT_SPREAD'
   | 'INLINE_FRAGMENT'
   ;

typeSystemDirectiveLocation
   : 'SCHEMA'
   | 'SCALAR'
   | 'OBJECT'
   | 'FIELD_DEFINITION'
   | 'ARGUMENT_DEFINITION'
   | 'INTERFACE'
   | 'UNION'
   | 'ENUM'
   | 'ENUM_VALUE'
   | 'INPUT_OBJECT'
   | 'INPUT_FIELD_DEFINITION'
   ;
   
STRING
   : '"' ( ESC | ~ ["\\] )* '"'
   ;

NAME
   : [_A-Za-z] [_0-9A-Za-z]*
   ;

fragment ESC
   : '\\' ( ["\\/bfnrt] | UNICODE )
   ;

fragment UNICODE
   : 'u' HEX HEX HEX HEX
   ;

fragment HEX
   : [0-9a-fA-F]
   ;

INT
   : '-'? '0' | '-'? [1-9] [0-9]*
   ;

FLOAT
   : INT '.' [0-9]+ EXP? | INT EXP | INT
   ;

fragment EXP
   : [Ee] [+\-]? INT
   ;

COMMENT
   : '#' ~[\r\n]* '\r'? '\n' -> skip
   ;

COMMA
   : ',' -> skip
   ;

WS
   : [ \t\n\r]+ -> skip
   ;
