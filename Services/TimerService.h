//
//  TimerService.h
//  Somfy
//
//  Created by Sempercon on 5/25/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendCommand.h"
#import "Constants.h"

@interface TimerService : NSObject {
		NSString *command;
}
+ (TimerService *)getSharedInstance;
-(void)getTimers:(id<ParserCallback>)delegate;
-(void)timerGetInfo:(NSString*) scheduleId :(id<ParserCallback>)delegate;
-(void)addTimer:(NSMutableDictionary*)dataDict :(id<ParserCallback>)delegate;
-(void)getName:(NSString*) Id :(id<ParserCallback>)delegate;
-(void)changeName:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void)enableTimer:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void)setDaysMask:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void)setTime:(NSMutableDictionary*)dictionary :(id<ParserCallback>)delegate;
-(void)randomizeTimer:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void)includeScene:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate;
-(void)removeTimerFromController:(NSMutableDictionary*)dataDict :(id<ParserCallback>)delegate;
-(void)changeOrder:(NSMutableArray*)timerArray :(id<ParserCallback>)delegate;


@end
