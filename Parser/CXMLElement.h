//
//  CXMLElement.h
//  Somfy
//
//  Created by Sempercon on 5/7/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "CXMLNode.h"

@interface CXMLElement : CXMLNode {

}

- (NSArray *)elementsForName:(NSString *)name;

- (NSArray *)attributes;
- (CXMLNode *)attributeForName:(NSString *)name;


- (NSString*)_XMLStringWithOptions:(NSUInteger)options appendingToString:(NSMutableString*)str;
@end
