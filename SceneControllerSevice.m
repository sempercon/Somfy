//
//  SceneControllerSevice.m
//  Somfy
//
//  Created by mac user on 6/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SceneControllerSevice.h"
#import "DataConversionUtil.h"
#import "Constants.h"

@implementation SceneControllerSevice


-(void)getListOfControllers:(id<ParserCallback>)delegate
{
	[self dispatchRequest:GET_LIST :Nil :delegate];
}

-(void)getController:(NSString*)ID :(id<ParserCallback>)delegate
{
	NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
	[dict setObject:ID forKey:@"value"];
	[self dispatchRequest:GET_CONTROLLER :dict :delegate];
	[dict release];
}

-(void)setButton:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
	[self dispatchRequest:SET_BUTTON :dict :delegate];
}

-(void)clearButton:(NSMutableDictionary*)dict :(id<ParserCallback>)delegate
{
	[self dispatchRequest:CLEAR_BUTTON :dict :delegate];
}

//Dispatch request
-(void) dispatchRequest: (NSString *) strCommand :(NSMutableDictionary *) dataDict :(id<ParserCallback>)delegate
{
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:strCommand :dataDict];
	[[SendCommand getSharedInstance] SendAPICommand:strCommand :command :delegate];
}

#pragma mark -
#pragma mark Initialization & Deallocation
static SceneControllerSevice *sharedInstance = nil;

+(SceneControllerSevice *)getSharedInstance {
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
