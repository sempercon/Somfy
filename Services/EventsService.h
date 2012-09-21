//
//  EventsService.h
//  Somfy
//
//  Created by Sempercon on 5/25/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendCommand.h"
#import "Constants.h"


@interface EventsService : NSObject {
		NSString *command;
}

+ (EventsService *)getSharedInstance;

-(void)getEvents:(id<ParserCallback>)delegate;
-(void)changeEventOrder:(NSMutableArray*)eventArray :(id<ParserCallback>)delegate;
-(void)add:(NSMutableDictionary*)dataDict :(id<ParserCallback>)delegate;
-(void)getInfo:(NSString*) Id :(id<ParserCallback>)delegate;
-(void)changeName:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void)getName:(NSString*) Id :(id<ParserCallback>)delegate;
-(void)enable:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void)setDaysMask:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void)setTimeType:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void)setTime:(NSMutableDictionary*)dataDict :(id<ParserCallback>)delegate;
-(void)setTriggerDevice:(NSMutableDictionary*)dataDict :(id<ParserCallback>)delegate;
-(void)setTriggerDeviceReason:(NSMutableDictionary*)dataDict :(id<ParserCallback>)delegate;
-(void)sceneInclude:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void)getTriggerDevicesList:(id<ParserCallback>)delegate;
-(void)getTriggerReasonList:(NSString*) Id :(id<ParserCallback>)delegate;
-(void)getTriggerReasonListById:(NSString*) Id :(id<ParserCallback>)delegate;
-(void)eventRemove:(NSMutableDictionary*)dataDict :(id<ParserCallback>)delegate;

@end
