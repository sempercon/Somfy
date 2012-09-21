//
//  CXMLDocument.h
//  Somfy
//
//  Created by Sempercon on 5/5/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "CXMLNode.h"

enum {
	CXMLDocumentTidyHTML = 1 << 9
};

@class CXMLElement;

@interface CXMLDocument : CXMLNode {
	NSMutableSet *nodePool;
}

- (id)initWithXMLString:(NSString *)inString options:(NSUInteger)inOptions error:(NSError **)outError;
- (id)initWithContentsOfURL:(NSURL *)inURL options:(NSUInteger)inOptions error:(NSError **)outError;
- (id)initWithData:(NSData *)inData options:(NSUInteger)inOptions error:(NSError **)outError;

- (CXMLElement *)rootElement;


@end
