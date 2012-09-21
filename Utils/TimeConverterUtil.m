//
//  TimeConverterUtil.m
//  Somfy
//
//  Created by Sempercon on 5/27/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "TimeConverterUtil.h"


@implementation TimeConverterUtil

#pragma mark -
#pragma mark Initialization & Deallocation
static TimeConverterUtil *sharedInstance = nil;

#define MINUTES_PER_HOUR 60

-(void)convertTimeFromMinutesAfterMidnight:(int)time
{
	Hours = time / MINUTES_PER_HOUR;
	Minutes = time % MINUTES_PER_HOUR;
}

-(int)getHours
{
	return Hours;
}

-(int)getMinutes
{
	return Minutes;
}

-(BOOL)containsDate:(NSString*)date
{
	if ([date rangeOfString:@"sDate."].location == NSNotFound)
		return NO;
	else
		return YES;
}

-(int)convertTimeToMinutesAfterMidnight:(int)hours :(int)minutes
{
	//Want to multiple the hours by MINUTES_PER_HOUR to get the total minutes per hours 
	//and then add the minutes to the end
	int convertedTime = ( hours * MINUTES_PER_HOUR ) + minutes;
	return convertedTime;
}


+(TimeConverterUtil *)getSharedInstance {
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
