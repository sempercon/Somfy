//
//  CXMLDocument_PrivateExtensions.h
//  Somfy
//
//  Created by Sempercon on 5/5/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "CXMLDocument.h"

#include <libxml/parser.h>

@interface CXMLDocument (CXMLDocument_PrivateExtensions)

- (NSMutableSet *)nodePool;

@end
