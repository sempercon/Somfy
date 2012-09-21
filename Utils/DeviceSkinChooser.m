//
//  DeviceSkinChooser.m
//  Somfy
//
//  Created by Sempercon on 5/14/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "DeviceSkinChooser.h"
#import "BinaryLightDeviceView.h"
#import "DimmerDeviceView.h"
#import "OnewayMotorView.h"
#import "ThermostatView.h"
#import "ILTMotorView.h"
#import "Constants.h"
#import "MJPEGViewer_iPad.h"

@implementation DeviceSkinChooser

//Select device skin based on devicetype
-(id) getDeviceSkinBasedOnDeviceType :(int)deviceType
{
	id skinView = nil;
	switch ( deviceType )
	{
		case THERMOSTAT_RCS:
		case THERMOSTATV2:
			skinView = [ThermostatView thermostatview];
			break;
        case MULTILEVEL_SWITCH:
		case REMOTE_SWITCH:
			skinView = [DimmerDeviceView dimmerDeviceview];
			break;
		case BINARY_SWITCH:
			skinView = [BinaryLightDeviceView binarylightview];
			break;
		case MOTOR_GENERIC:
		case SOMFY_RTS:
			skinView = [OnewayMotorView onewaymotorview];
			break;
		case SOMFY_ILT:
			skinView = [ILTMotorView iLTMotorView];
			break;
        case IP_CAMERA_DEVICE_TYPE:
			skinView = [MJPEGViewer_iPad MJPEGViewer_iPadView];
			break;
		default:
			break;
	}
	return skinView;
}


#pragma mark -
#pragma mark Initialization & Deallocation
static DeviceSkinChooser *sharedInstance = nil;

+(DeviceSkinChooser *)getSharedInstance {
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
