//
//  CXMLNode.h
//  Somfy
//
//  Created by Sempercon on 5/7/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//


#import <Foundation/Foundation.h>

#include <libxml/tree.h>

typedef enum {
	CXMLInvalidKind = 0,
	CXMLElementKind = XML_ELEMENT_NODE,
	CXMLAttributeKind = XML_ATTRIBUTE_NODE,
	CXMLTextKind = XML_TEXT_NODE,
	CXMLProcessingInstructionKind = XML_PI_NODE,
	CXMLCommentKind = XML_COMMENT_NODE,
	CXMLNotationDeclarationKind = XML_NOTATION_NODE,
	CXMLDTDKind = XML_DTD_NODE,
	CXMLElementDeclarationKind =  XML_ELEMENT_DECL,
	CXMLAttributeDeclarationKind =  XML_ATTRIBUTE_DECL,
	CXMLEntityDeclarationKind = XML_ENTITY_DECL,
	CXMLNamespaceKind = XML_NAMESPACE_DECL,
} CXMLNodeKind;

@class CXMLDocument;

// NSXMLNode
@interface CXMLNode : NSObject {
	xmlNodePtr _node;
}

- (CXMLNodeKind)kind;
- (NSString *)name;
- (NSString *)stringValue;
- (NSUInteger)index;
- (NSUInteger)level;
- (CXMLDocument *)rootDocument;
- (CXMLNode *)parent;
- (NSUInteger)childCount;
- (NSArray *)children;
- (CXMLNode *)childAtIndex:(NSUInteger)index;
- (CXMLNode *)previousSibling;
- (CXMLNode *)nextSibling;
- (NSString *)description;
- (NSString *)XMLString;
- (NSString *)XMLStringWithOptions:(NSUInteger)options;
- (NSArray *)nodesForXPath:(NSString *)xpath error:(NSError **)error;

- (NSString*)_XMLStringWithOptions:(NSUInteger)options appendingToString:(NSMutableString*)str;
@end
