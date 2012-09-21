//
//  UserService.h
//  Somfy
//
//  Created by Sempercon on 5/31/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendCommand.h"

@interface UserService : NSObject {
	NSString *command;
}

+ (UserService *)getSharedInstance;
-(void)authenticate:(NSMutableDictionary*) dataDict :(id<ParserCallback>)delegate;
-(void)selectTahomaController:(NSString*)index :(id<ParserCallback>)delegate;
-(void)Logout:(id<ParserCallback>)delegate;
-(void)HomeOccupationGetInfo:(id<ParserCallback>)delegate;
-(void)HomeOccupationEnable :(NSMutableDictionary*) dataDict :(id<ParserCallback>)delegate;
-(void)HomeOccupancyStateGroupDeviceAdd :(NSMutableDictionary*) dataDict :(id<ParserCallback>)delegate;

@end
