//
//  DataConversionUtil.h
//  Somfy
//
//  Created by Sempercon on 5/5/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataConversionUtil : NSObject {

}
+ (DataConversionUtil *)getSharedInstance;
-(NSString *) buildXMLCommand :(NSString *) commandName :(NSMutableDictionary *) data;
@end
