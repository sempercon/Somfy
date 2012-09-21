//
//  DataConversionUtil.m
//  Somfy
//
//  Created by Sempercon on 5/5/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "DataConversionUtil.h"
#import "RoomService.h"
#import "Constants.h"
#import "AppDelegate_iPad.h"

@implementation DataConversionUtil



//Formatting xmlcommand 
-(NSString *) buildXMLCommand :(NSString *) commandName :(NSMutableDictionary *) data 
{
	NSArray *dataKeys;
	NSString *xmlString=@"";
	xmlString = [xmlString stringByAppendingString:@"<command>"];
	if(commandName != AUTHENTICATE_USER)
	{
		xmlString = [xmlString stringByAppendingString:@"<sessionid>"];
		if([[AppDelegate_iPad  sharedAppDelegate].g_SessionArray count]>0)
			xmlString = [xmlString stringByAppendingString:[[[AppDelegate_iPad  sharedAppDelegate].g_SessionArray objectAtIndex:0] objectForKey:@"sessionid"]];
		else 
			xmlString = [xmlString stringByAppendingString:sessionid];
		xmlString = [xmlString stringByAppendingString:@"</sessionid>"];
	}
	xmlString = [xmlString stringByAppendingString:@"<name>"];
	xmlString = [xmlString stringByAppendingString:commandName];
	xmlString = [xmlString stringByAppendingString:@"</name>"];
	
	if (data != nil)
	{
		dataKeys = [data allKeys];
		xmlString = [xmlString stringByAppendingString:@"<arg>"];
		for (int i =0 ; i < [dataKeys count]; i++)
		{
			NSString *elementName = [dataKeys objectAtIndex:i];
			if([elementName isEqualToString:@"arg"])
			{
				xmlString = [xmlString stringByAppendingString:[data objectForKey:[dataKeys objectAtIndex:i]]];
			}
			else
			{
				xmlString = [xmlString stringByAppendingString:[NSString stringWithFormat:@"<%@>",elementName]];
				xmlString = [xmlString stringByAppendingString:[data objectForKey:[dataKeys objectAtIndex:i]]];
				xmlString = [xmlString stringByAppendingString:[NSString stringWithFormat:@"</%@>",elementName]];
			}
		}
		xmlString = [xmlString stringByAppendingString:@"</arg>"];
	}
	
	xmlString = [xmlString stringByAppendingString:@"</command>"];
	
	return xmlString;
}

#pragma mark -
#pragma mark Initialization & Deallocation
static DataConversionUtil *sharedInstance = nil;

+(DataConversionUtil *)getSharedInstance {
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
