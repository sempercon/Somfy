//
//  SceneControllerSevice.h
//  Somfy
//
//  Created by mac user on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendCommand.h"

@interface SceneControllerSevice : NSObject {
	NSString *command;
}

+ (SceneControllerSevice *)getSharedInstance;
-(void)getListOfControllers:(id<ParserCallback>)delegate;
-(void)getController:(NSString*)ID :(id<ParserCallback>)delegate;
-(void)setButton:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void)clearButton:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void) dispatchRequest: (NSString *) strCommand :(NSMutableDictionary *) dataDict :(id<ParserCallback>)delegate;


@end
