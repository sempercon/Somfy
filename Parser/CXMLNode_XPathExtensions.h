//
//  CXMLNode_XPathExtensions.h
//  Somfy
//
//  Created by Sempercon on 5/9/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "CXMLNode.h"

@interface CXMLNode (CXMLNode_XPathExtensions)

- (NSArray *)nodesForXPath:(NSString *)xpath namespaceMappings:(NSDictionary *)inNamespaceMappings error:(NSError **)error;

@end
