//
//  EventsService.m
//  Somfy
//
//  Created by Sempercon on 5/25/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "EventsService.h"
#import "Constants.h"
#import "DataConversionUtil.h"



@interface EventsService (private)
//TODO: Declare private methods here
-(void) dispatchRequest: (NSString *) strCommand :(NSMutableDictionary *) dataDict :(id<ParserCallback>)delegate;
-(NSMutableDictionary*)bindEventValuesToDict :(NSMutableArray*)eventArr;
@end


@implementation EventsService


-(void)getEvents:(id<ParserCallback>)delegate
{
	//return dispatchRequest( GET_EVENTS );
	[self dispatchRequest : GET_EVENTS :Nil :delegate];
}

-(void)changeEventOrder:(NSMutableArray*)eventArray :(id<ParserCallback>)delegate
{
	//return null;
	/*NSMutableDictionary *dataDict = [self bindEventValuesToDict :eventArray];
	[self dispatchRequest : EVENT_CHANGE_ORDER :dataDict :delegate];
	[dataDict release];*/
	return;
}

-(void)add:(NSMutableDictionary*)dataDict :(id<ParserCallback>)delegate
{
	[self dispatchRequest : EVENT_ADD :dataDict :delegate];
}

-(void)getInfo:(NSString*) Id :(id<ParserCallback>)delegate
{
	//return dispatchRequest ( EVENT_GET_INFO, id, int );
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:Id forKey:@"arg"];
	[self dispatchRequest : EVENT_GET_INFO :dataDict :delegate];
	[dataDict release];
}

-(void)changeName:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
	[self dispatchRequest : EVENT_CHANGE_NAME :dict :delegate];
	return;
}

-(void)getName:(NSString*) Id :(id<ParserCallback>)delegate
{
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:Id forKey:@"arg"];
	[self dispatchRequest : EVENT_GET_NAME :dataDict :delegate];
	[dataDict release];
}

-(void)enable:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
	//return dispatchRequest ( EVENT_ENABLE, event, EventInfoType );
	[self dispatchRequest : EVENT_ENABLE :dict :delegate];
}

-(void)setDaysMask:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
	//return dispatchRequest ( EVENT_SET_DAYS_MASK, event, EventInfoType);
	[self dispatchRequest : EVENT_SET_DAYS_MASK :dict :delegate];
}

-(void)setTimeType:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
	//return dispatchRequest ( EVENT_SET_TIME_TYPE, condition, EventCondType );
	[self dispatchRequest : EVENT_SET_TIME_TYPE :dict :delegate];
}

-(void)setTime:(NSMutableDictionary*)dataDict :(id<ParserCallback>)delegate
{
	[self dispatchRequest : EVENT_SET_TIME :dataDict :delegate];
}

-(void)setTriggerDevice:(NSMutableDictionary*)dataDict :(id<ParserCallback>)delegate
{
	[self dispatchRequest : EVENT_SET_TRIGGER_DEVICE :dataDict :delegate];
}

-(void)setTriggerDeviceReason:(NSMutableDictionary*)dataDict :(id<ParserCallback>)delegate
{
	[self dispatchRequest : EVENT_SET_TRIGGER_REASON :dataDict :delegate];
}

-(void)sceneInclude:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
	//return dispatchRequest ( EVENT_SCENE_INCLUDE, scene, SceneIncludeType );
	[self dispatchRequest : EVENT_SCENE_INCLUDE :dict :delegate];
}

-(void)getTriggerDevicesList:(id<ParserCallback>)delegate
{
	//return dispatchRequest( EVENT_GET_TRIGGER_DEVICES_LIST );
	[self dispatchRequest : EVENT_GET_TRIGGER_DEVICES_LIST :Nil :delegate];
}

-(void)getTriggerReasonList:(NSString*) Id :(id<ParserCallback>)delegate
{
	//return dispatchRequest( EVENT_GET_TRIGGER_REASON_LIST, id, int );
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:Id forKey:@"arg"];
	[self dispatchRequest : EVENT_GET_TRIGGER_REASON_LIST :dataDict :delegate];
	[dataDict release];
}

-(void)getTriggerReasonListById:(NSString*) Id :(id<ParserCallback>)delegate
{
	//return dispatchRequest( EVENT_GET_TRIGGER_REASON_LIST_BY_ID, id, int  );
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:Id forKey:@"arg"];
	[self dispatchRequest : EVENT_GET_TRIGGER_REASON_LIST_BY_ID :dataDict :delegate];
	[dataDict release];
}

-(void)eventRemove:(NSMutableDictionary*)dataDict :(id<ParserCallback>)delegate
{
	[self dispatchRequest : EVENT_REMOVE :dataDict :delegate];
}

//-----------------------------------------------------------------------------
//
//	Private Method
//
//-----------------------------------------------------------------------------

-(NSMutableDictionary*)bindEventValuesToDict :(NSMutableArray*)eventArr
{
	NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
	[dataDict setObject:[[eventArr objectAtIndex:0]objectForKey:@"enabled"] forKey:@"enabled"];
	[dataDict setObject:[[eventArr objectAtIndex:0]objectForKey:@"startTime"] forKey:@"startTime"];
	[dataDict setObject:[[eventArr objectAtIndex:0]objectForKey:@"randomized"] forKey:@"randomized"];
	[dataDict setObject:[[eventArr objectAtIndex:0]objectForKey:@"daysActiveMask"] forKey:@"daysActiveMask"];
	[dataDict setObject:[[eventArr objectAtIndex:0]objectForKey:@"name"] forKey:@"name"];
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
static EventsService *sharedInstance = nil;

+(EventsService *)getSharedInstance {
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
