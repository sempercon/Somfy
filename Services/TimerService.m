//
//  TimerService.m
//  Somfy
//
//  Created by Sempercon on 5/25/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "TimerService.h"
#import "Constants.h"
#import "DataConversionUtil.h"



@interface TimerService (private)
//TODO: Declare private methods here
-(void) dispatchRequest: (NSString *) strCommand :(NSMutableDictionary *) dataDict :(id<ParserCallback>)delegate;
-(NSMutableDictionary*)bindTimerValuesToDict :(NSMutableArray*)timerArr;
@end

@implementation TimerService

/**
 * Retreives the timers that are currently stored on the controller
 * @return 
 */
-(void)getTimers:(id<ParserCallback>)delegate
{
	//return dispatchRequest( GET_TIMERS );
	[self dispatchRequest : GET_TIMERS :Nil :delegate];
}

/**
 * Retrieves the information associated with the requested timer
 * @return 
 */
-(void)timerGetInfo:(NSString*) scheduleId :(id<ParserCallback>)delegate
{			
	//Format commands
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:scheduleId forKey:@"arg"];
	[self dispatchRequest : GET_INFO :dataDict :delegate];
	[dataDict release];
}

/**
 * 
 * @return 
 */
-(void)addTimer:(NSMutableDictionary*)dataDict :(id<ParserCallback>)delegate
{	
	[self dispatchRequest : ADD_TIMER :dataDict :delegate];
}

/**
 * 
 * @return 
 */
-(void)getName:(NSString*) Id :(id<ParserCallback>)delegate
{
	//return dispatchRequest( GET_NAME, new GenericIDType(id), GenericIDType );
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:Id forKey:@"arg"];
	[self dispatchRequest : GET_NAME :dataDict :delegate];
	[dataDict release];
}

/**
 * 
 * @return 
 */
-(void)changeName:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
	//return dispatchRequest( CHANGE_NAME, name, ChangeNameType );
	//NSMutableDictionary *dataDict = [self bindTimerValuesToDict :timerArray];
	[self dispatchRequest : TIMER_CHANGE_NAME :dict :delegate];
	//[dataDict release];
}

/**
 * 
 * @return 
 */
-(void)enableTimer:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
	//return dispatchRequest( ENABLE, timer, TimerInfoType );
	//NSMutableDictionary *dataDict = [self bindTimerValuesToDict :timerArray];
	[self dispatchRequest : ENABLE :dict :delegate];
	//[dataDict release];
}

/**
 * 
 * @return 
 */
-(void)setDaysMask:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
	//return dispatchRequest( SET_DAYS_MASK, timer, TimerInfoType );
	[self dispatchRequest : SET_DAYS_MASK :dict :delegate];	
}

/**
 * 
 * @return 
 */
-(void)setTime:(NSMutableDictionary*)dictionary :(id<ParserCallback>)delegate
{
	///return dispatchRequest( SET_TIME, timer, TimerInfoType );
	//NSMutableDictionary *dataDict = [self bindTimerValuesToDict :timerArray];
	[self dispatchRequest : SET_TIME :dictionary :delegate];
	//[dataDict release];
}

/**
 * 
 * @return 
 */
-(void)randomizeTimer:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
	//return dispatchRequest( TIMER_RANDOMIZE, timer, TimerInfoType );
	[self dispatchRequest : TIMER_RANDOMIZE :dict :delegate];	
}

/**
 * 
 * @return 
 */
-(void)includeScene:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
	//return dispatchRequest( INCLUDE_SCENE, scene, SceneIncludeType );
	//NSMutableDictionary *dataDict = [self bindTimerValuesToDict :timerArray];
	[self dispatchRequest : INCLUDE_SCENE :dict :delegate];
	//[dataDict release];
}

/**
 * 
 * @return 
 */
-(void)removeTimerFromController:(NSMutableDictionary*)dataDict :(id<ParserCallback>)delegate
{
	[self dispatchRequest : REMOVE :dataDict :delegate];
}

/**
 * 
 * @return 
 */
-(void)changeOrder:(NSMutableArray*)timerArray :(id<ParserCallback>)delegate
{
	//return dispatchRequest( CHANGE_ORDER, orderChange, ChangeOrderType );
	NSMutableDictionary *dataDict = [self bindTimerValuesToDict :timerArray];
	[self dispatchRequest : CHANGE_ORDER :dataDict :delegate];
	[dataDict release];
}

-(NSMutableDictionary*)bindTimerValuesToDict :(NSMutableArray*)timerArr
{
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:[[timerArr objectAtIndex:0]objectForKey:@"enabled"] forKey:@"enabled"];
	[dataDict setObject:[[timerArr objectAtIndex:0]objectForKey:@"startTime"] forKey:@"startTime"];
	[dataDict setObject:[[timerArr objectAtIndex:0]objectForKey:@"randomized"] forKey:@"randomized"];
	[dataDict setObject:[[timerArr objectAtIndex:0]objectForKey:@"daysActiveMask"] forKey:@"daysActiveMask"];
	[dataDict setObject:[[timerArr objectAtIndex:0]objectForKey:@"name"] forKey:@"name"];
	return dataDict;
}


//Dispatch request
-(void) dispatchRequest: (NSString *) strCommand :(NSMutableDictionary *) dataDict :(id<ParserCallback>)delegate
{
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:strCommand :dataDict];
	[[SendCommand getSharedInstance] SendAPICommand:strCommand :command :delegate];
}




#pragma mark -
#pragma mark Initialization & Deallocation
static TimerService *sharedInstance = nil;

+(TimerService *)getSharedInstance {
	@synchronized(self) {
		if (sharedInstance == nil) {
			[[self alloc] init];
		}
	}
	
	return sharedInstance;
}

+(id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (sharedInstance == nil) {
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
	
	return nil;
}

-(id)copyWithZone:(NSZone *)zone {
	return self;
}

-(id)retain {
	return self;
}

-(unsigned)retainCount {
	return UINT_MAX;
}

-(void)release { }

-(id)autorelease {
	return self;
}

-(id) init {
	self = [super init];
	if (self != nil) {
	}
	return self;
}

-(void) dealloc {
	[super dealloc];
}



@end
