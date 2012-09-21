//
//  DeviceService.h
//  Somfy
//
//  Created by Sempercon on 5/7/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendCommand.h"

@interface DeviceService : NSObject {
	NSString *command;
}

+ (DeviceService *)getSharedInstance;
-(void)getAll:(id<ParserCallback>)delegate;
-(void)setSomfyMyPosition :(NSString*)deviceId :(id<ParserCallback>)delegate;
-(void)changeName :(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void)changeRoom :(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void)getDevice :(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void)getDeviceName :(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void)getProtection :(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void)setAsShortcut :(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void)setControlledWatts :(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void)setProtection :(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void)setValue :(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;


@end
