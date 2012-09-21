//
//  CXMLDocument_PrivateExtensions.m
//  Somfy
//
//  Created by Sempercon on 5/5/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "CXMLDocument_PrivateExtensions.h"

@implementation CXMLDocument (CXMLDocument_PrivateExtensions)


- (NSMutableSet *)nodePool
{
if (nodePool == NULL)
	{
	nodePool = [[NSMutableSet alloc] init];
	}
return(nodePool);
}


@end
