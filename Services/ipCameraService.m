//
//  ipCameraService.m
//  Somfy
//
//  Created by Sempercon on 5/31/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "ipCameraService.h"
#import "Constants.h"
#import "DataConversionUtil.h"

@interface ipCameraService (private)
-(void) dispatchRequest: (NSString *) strCommand :(NSMutableDictionary *) dataDict :(id<ParserCallback>)delegate;
@end

@implementation ipCameraService



-(void)get_zonoff_ip_camera_get_list:(id<ParserCallback>)delegate;
{
	// command string ZONOFF_IP_CAMERA_GET_LIST
	[self dispatchRequest : ZONOFF_IP_CAMERA_GET_LIST :Nil :delegate];
}

//Dispatch request
-(void) dispatchRequest: (NSString *) strCommand :(NSMutableDictionary *) dataDict :(id<ParserCallback>)delegate
{
	command = [[DataConversionUtil getSharedInstance] buildXMLCommand:strCommand :dataDict];
	[[SendCommand getSharedInstance] SendAPICommand:strCommand :command :delegate];
}

#pragma mark -
#pragma mark Initialization & Deallocation
static ipCameraService *sharedInstance = nil;

+(ipCameraService *)getSharedInstance {
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
