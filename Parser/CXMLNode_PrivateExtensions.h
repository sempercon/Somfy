//
//  CXMLNode_PrivateExtensions.h
//  Somfy
//
//  Created by Sempercon on 5/7/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "CXMLNode.h"

@interface CXMLNode (CXMLNode_PrivateExtensions)

- (id)initWithLibXMLNode:(xmlNodePtr)inLibXMLNode;

+ (id)nodeWithLibXMLNode:(xmlNodePtr)inLibXMLNode;

@end
