//
//  ManufacturerIdToNameMapper.m
//  Somfy
//
//  Created by mac user on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ManufacturerIdToNameMapper.h"
#import "Constants.h"


@implementation ManufacturerIdToNameMapper



-(NSString*)mapManufacturerIdToName:(int)ManufacturerId
{
	NSString *manufacturerIdName = @"";
	
	switch ( ManufacturerId )
	{
		case ZW_MAN_ZENSYS:
			manufacturerIdName = NAME_ZENSYS;
			break;
		case ZW_MAN_ACT:
			manufacturerIdName = NAME_ACT;
			break;
		case ZW_MAN_DANFOSS:
			manufacturerIdName = NAME_DANFOSS;
			break;
		case ZW_MAN_WRAP:
			manufacturerIdName = NAME_WRAP;
			break;
		case ZW_MAN_EXHAUSTO:
			manufacturerIdName = NAME_EXHAUSTO;
			break;
		case ZW_MAN_INTERMATIC:
			manufacturerIdName = NAME_INTERMATIC;
			break;
		case ZW_MAN_INTEL:
			manufacturerIdName = NAME_INTEL;
			break;
		case ZW_MAN_VIMAR_CRS:
			manufacturerIdName = NAME_VIMAR_CRS;
			break;
		case ZW_MAN_WAYNE_DALTON:
			manufacturerIdName = NAME_WAYNE_DALTON;
			break;
		case ZW_MAN_SYLVANIA:
			manufacturerIdName = NAME_SYLVANIA;
			break;
		case ZW_MAN_TECHNIKU:
			manufacturerIdName = NAME_TECHNIKU;
			break;
		case ZW_MAN_CASAWORKS:
			manufacturerIdName = NAME_CASAWORKS;
			break;
		case ZW_MAN_HOMESEER_TECHNOLOGIES:
			manufacturerIdName = NAME_HOMESEER_TECHNOLOGIES;
			break;
		case ZW_MAN_HOME_AUTOMATED_LIVING:
			manufacturerIdName = NAME_HOME_AUTOMATED_LIVING;
			break;
		case ZW_MAN_CONVERGEX_LTD:
			manufacturerIdName = NAME_CONVERGEX_LTD;
			break;
		case ZW_MAN_RCS:
			manufacturerIdName = NAME_RCS;
			break;
		case ZW_MAN_ICOM_TECHNOLOGY:
			manufacturerIdName = NAME_ICOM_TECHNOLOGY;
			break;
		case ZW_MAN_TELL_IT_ONLINE:
			manufacturerIdName = NAME_TELL_IT_ONLINE;
			break;
		case ZW_MAN_INTERNET_DOM:
			manufacturerIdName = NAME_INTERNET_DOM;
			break;
		case ZW_MAN_CYBERHOUSE:
			manufacturerIdName = NAME_CYBERHOUSE;
			break;
		case ZW_MAN_POWERLYNX:
			manufacturerIdName = NAME_POWERLYNX;
			break;
		case ZW_MAN_HITECH_AUTOMATION:
			manufacturerIdName = NAME_HITECH_AUTOMATION;
			break;
		case ZW_MAN_BALBOA_INSTRUMENTS:
			manufacturerIdName = NAME_BALBOA_INSTRUMENTS;
			break;
		case ZW_MAN_CONTROLTHINK_LC:
			manufacturerIdName = NAME_CONTROLTHINK_LC;
			break;
		case ZW_MAN_COOPER_WIRING_DEVICES:
			manufacturerIdName = NAME_COOPER_WIRING_DEVICES;
			break;
		case ZW_MAN_ELK_PRODUCTS:
			manufacturerIdName = NAME_ELK_PRODUCTS;
			break;
		case ZW_MAN_INTELLICON:
			manufacturerIdName = NAME_INTELLICON;
			break;
		case ZW_MAN_LEVITON:
			manufacturerIdName = NAME_LEVITON;
			break;
		case ZW_MAN_RYHERD_VENTURES:
			manufacturerIdName = NAME_RYHERD_VENTURES;
			break;
		case ZW_MAN_SCIENTIA_TECHNOLOGIES:
			manufacturerIdName = NAME_SCIENTIA_TECHNOLOGIES;
			break;
		case ZW_MAN_UEI:
			manufacturerIdName = NAME_UEI;
			break;
		case ZW_MAN_ZYKRONIX:
			manufacturerIdName = NAME_ZYKRONIX;
			break;
		case ZW_MAN_A1_COMPONENTS:
			manufacturerIdName = NAME_A1_COMPONENTS;
			break;
		case ZW_MAN_BOCA_DEVICES:
			manufacturerIdName = NAME_BOCA_DEVICES;
			break;
		case ZW_MAN_LOUDWATER_TECHNOLOGIES:
			manufacturerIdName = NAME_LOUDWATER_TECHNOLOGIES;
			break;
		case ZW_MAN_BULOGICS:
			manufacturerIdName = NAME_BULOGICS;
			break;
		case ZW_MAN_2B_ELECTRONICS:
			manufacturerIdName = NAME_2B_ELECTRONICS;
			break;
		case ZW_MAN_ASIA_HEADING:
			manufacturerIdName = NAME_ASIA_HEADING;
			break;
		case ZW_MAN_3E_TECHNOLOGIES:
			manufacturerIdName = NAME_3E_TECHNOLOGIES;
			break;
		case ZW_MAN_ATECH:
			manufacturerIdName = NAME_ATECH;
			break;
		case ZW_MAN_BESAFER:
			manufacturerIdName = NAME_BESAFER;
			break;
		case ZW_MAN_BROADBAND_ENERGY_NETWORKS_INC:
			manufacturerIdName = NAME_BROADBAND_ENERGY_NETWORKS_INC;
			break;
		case ZW_MAN_CARRIER:
			manufacturerIdName = NAME_CARRIER;
			break;
		case ZW_MAN_COLOR_KINETICS_INCORPORATED:
			manufacturerIdName = NAME_COLOR_KINETICS_INCORPORATED;
			break;
		case ZW_MAN_CYTECH_TECHNOLOGY_PRE_LTD:
			manufacturerIdName = NAME_CYTECH_TECHNOLOGY_PRE_LTD;
			break;
		case ZW_MAN_DESTINY_NETWORKS:
			manufacturerIdName = NAME_DESTINY_NETWORKS;
			break;
		case ZW_MAN_DIGITAL_5:
			manufacturerIdName = NAME_DIGITAL_5;
			break;
		case ZW_MAN_ELECTRONIC_SOLUTIONS:
			manufacturerIdName = NAME_ELECTRONIC_SOLUTIONS;
			break;
		case ZW_MAN_EL_GEV_ELECTRONICS_LTD:
			manufacturerIdName = NAME_EL_GEV_ELECTRONICS_LTD;
			break;
		case ZW_MAN_EMBEDIT:
			manufacturerIdName = NAME_EMBEDIT;
			break;
		case ZW_MAN_EXCEPTIONAL_INNOVATIONS:
			manufacturerIdName = NAME_EXCEPTIONAL_INNOVATIONS;
			break;
		case ZW_MAN_FOARD_SYSTEMS:
			manufacturerIdName = NAME_FOARD_SYSTEMS;
			break;
		case ZW_MAN_HOME_DIRECTOR:
			manufacturerIdName = NAME_HOME_DIRECTOR;
			break;
		case ZW_MAN_HONEYWELL:
			manufacturerIdName = NAME_HONEYWELL;
			break;
		case ZW_MAN_INLON_SRL:
			manufacturerIdName = NAME_INLON_SRL;
			break;
		case ZW_MAN_IR_SEC_SAFETY:
			manufacturerIdName = NAME_IR_SEC_SAFETY;
			break;
		case ZW_MAN_LIFESTYLE_NETWORKS:
			manufacturerIdName = NAME_LIFESTYLE_NETWORKS;
			break;
		case ZW_MAN_MARMITEK_BV:
			manufacturerIdName = NAME_MARMITEK_BV;
			break;
		case ZW_MAN_MARTEC_ACCESS_PRODUCTS:
			manufacturerIdName = NAME_MARTEC_ACCESS_PRODUCTS;
			break;
		case ZW_MAN_MOTOROLA:
			manufacturerIdName = NAME_MOTOROLA;
			break;
		case ZW_MAN_NOVAR:
			manufacturerIdName = NAME_NOVAR;
			break;
		case ZW_MAN_OPENPEAK_INC:
			manufacturerIdName = NAME_PRAGMATIC_CONSULTING_INC;
			break;
		case ZW_MAN_PRAGMATIC_CONSULTING_INC:
			manufacturerIdName = NAME_PRAGMATIC_CONSULTING_INC;
			break;
		case ZW_MAN_SENMATIC:
			manufacturerIdName = NAME_SENMATIC;
			break;
		case ZW_MAN_SEQUOIA_TECHNOLOGY_LTD:
			manufacturerIdName = NAME_SEQUOIA_TECHNOLOGY_LTD;
			break;
		case ZW_MAN_SINE_WIRELESS:
			manufacturerIdName = NAME_SINE_WIRELESS;
			break;
		case ZW_MAN_SMART_PRODUCTS:
			manufacturerIdName = NAME_SMART_PRODUCTS;
			break;
		case ZW_MAN_SOMFY:
			manufacturerIdName = NAME_SOMFY;
			break;
		case ZW_MAN_TELSEY:
			manufacturerIdName = NAME_TELSEY;
			break;
		case ZW_MAN_TWISTHINK:
			manufacturerIdName = NAME_TWISTHINK;
			break;
		case ZW_MAN_VISUALIZE:
			manufacturerIdName = NAME_VISUALIZE;
			break;
		case ZW_MAN_WATT_STOPPER:
			manufacturerIdName = NAME_WATT_STOPPER;
			break;
		case ZW_MAN_WOODWARD_LABS:
			manufacturerIdName = NAME_WOODWARD_LABS;
			break;
		case ZW_MAN_XANBOO:
			manufacturerIdName = NAME_XANBOO;
			break;
		case ZW_MAN_ZDATA:
			manufacturerIdName = NAME_ZDATA;
			break;
		case ZW_MAN_ZWAVE_TECHNOLOGIA:
			manufacturerIdName = NAME_ZWAVE_TECHNOLOGIA;
			break;
		case ZW_MAN_HOMEPRO:
			manufacturerIdName = NAME_HOMEPRO;
			break;
		case ZW_MAN_LAGOTEK_CORPORATION:
			manufacturerIdName = NAME_LAGOTEK_CORPORATION;
			break;
		case ZW_MAN_HORSTMANN_CONTROLS_LIMITED:
			manufacturerIdName = NAME_HORSTMANN_CONTROLS_LIMITED;
			break;
		case ZW_MAN_HOME_AUTOMATED_INC:
			manufacturerIdName = NAME_HOME_AUTOMATED_INC;
			break;
		case ZW_MAN_ASPALIS:
			manufacturerIdName = NAME_ASPALIS;
			break;
		case ZW_MAN_VIEWSONIC_CORPORATION:
			manufacturerIdName = NAME_VIEWSONIC_CORPORATION;
			break;
		case ZW_MAN_EVERSPRING:
			manufacturerIdName = NAME_EVERSPRING;
			break;
		case ZW_MAN_JASCO_PRODUCTS:
			manufacturerIdName = NAME_JASCO_PRODUCTS;
			break;
		case ZW_MAN_REITZ_GROUP:
			manufacturerIdName = NAME_REITZ_GROUP;
			break;
		case ZW_MAN_RS_SCENE_AUTOMATIO:
			manufacturerIdName = NAME_RS_SCENE_AUTOMATION;
			break;
		case ZW_MAN_SELUXIT:
			manufacturerIdName = NAME_SELUXIT;
			break;
		case ZW_MAN_TRICKLESTAR_LTD:
			manufacturerIdName = NAME_TRICKLESTAR_LTD;
			break;
		case ZW_MAN_HOME_MANAGEBLES:
			manufacturerIdName = NAME_HOME_MANAGEBLES;
			break;
		case ZW_MAN_LS_CONTROL:
			manufacturerIdName = NAME_LS_CONTROL;
			break;
		case ZW_MAN_INNOVUS:
			manufacturerIdName = NAME_INNOVUS;
			break;
		case ZW_MAN_MERTEN:
			manufacturerIdName = NAME_MERTEN;
			break;
		case ZW_MAN_MONSTER_CABLE:
			manufacturerIdName = NAME_MONSTER_CABLE;
			break;
		case ZW_MAN_LOGITECH:
			manufacturerIdName = NAME_LOGITECH;
			break;
		case ZW_MAN_VERO_DUCO:
			manufacturerIdName = NAME_VERO_DUCO;
			break;
		case ZW_MAN_MTC_MAINTRONIC_GERMANY:
			manufacturerIdName = NAME_MTC_MAINTRONIC_GERMANY;
			break;
		case ZW_MAN_FAKRO:
			manufacturerIdName = NAME_FAKRO;
			break;
		case ZW_MAN_AEON_LABS:
			manufacturerIdName = NAME_AEON_LABS;
			break;
		case ZW_MAN_EKA_SYSTEMS:
			manufacturerIdName = NAME_EKA_SYSTEMS;
			break;
		case ZW_MAN_TRANE_CORPORATION:
			manufacturerIdName = NAME_TRANE_CORPORATION;
			break;
		case ZW_MAN_RARITAN:
			manufacturerIdName = NAME_RARITAN;
			break;
		case ZW_MAN_MB_TURN_KEY_DESIGN:
			manufacturerIdName = NAME_MB_TURN_KEY_DESIGN;
			break;
		case ZW_MAN_KWIKSET:
			manufacturerIdName = NAME_KWIKSET;
			break;
		case ZW_MAN_KAMSTRUP:
			manufacturerIdName = NAME_KAMSTRUP;
			break;
		case ZW_MAN_ALARM_DOT_COM:
			manufacturerIdName = NAME_ALARM_DOT_COM;
			break;
		case ZW_MAN_QEES:
			manufacturerIdName = NAME_QEES;
			break;
		case ZW_MAN_NORTHQ:
			manufacturerIdName = NAME_NORTHQ;
			break;
		case ZW_MAN_GREENWAVE_REALITY_INC:
			manufacturerIdName = NAME_GREENWAVE_REALITY_INC;
			break;
		case ZW_MAN_HOME_AUTOMATION_EUROPE:
			manufacturerIdName = NAME_HOME_AUTOMATION_EUROPE;
			break;
		case ZW_MAN_CAMEO_COMMUNICATIONS_INC:
			manufacturerIdName = NAME_CAMEO_COMMUNICATIONS_INC;
			break;
		case ZW_MAN_COVENTIVE_TECHNOLOGIES_INC:
			manufacturerIdName = NAME_COVENTIVE_TECHNOLOGIES_INC;
			break;
		case ZW_MAN_EXIGENT_SENSORS:
			manufacturerIdName = NAME_EXIGENT_SENSORS;
			break;
		case ZW_MAN_ASSA_ABLOY_USA:
			manufacturerIdName = NAME_ASSA_ABLOY_USA;
			break;
	}
	
	return manufacturerIdName;
}


-(NSString*)mapDeviceIdToName:(int)deviceType
{
	NSString *deviceTypeName = @"";
	
	switch ( deviceType )
	{
		case CONTROLLER:
			deviceTypeName = CONTROLLER_STRING;
			break;
		case UNKNOWN:
			deviceTypeName = UNKNOWN_STRING;
			break;
      	case MULTILEVEL_SWITCH:
			deviceTypeName = MULTILEVEL_SWITCH_STRING;
			break;
		case BINARY_SWITCH:
			deviceTypeName = BINARY_SWITCH_STRING;
			break;
		case UNDEFINED:
			deviceTypeName = UNDEFINED_STRING;
			break;
		case THERMOSTAT:
			deviceTypeName = THERMOSTAT_STRING;
			break;
		case THERMOSTATV2:
			deviceTypeName = THERMOSTATV2_STRING;
			break;
		case SETBACK_THERMOSTAT:
			deviceTypeName = SETBACK_THERMOSTAT_STRING;
			break;
		case GARAGE_DOOR:
			deviceTypeName = GARAGE_DOOR_STRING;
			break;
		case SATELLITE_RADIO:
			deviceTypeName = SATELLITE_RADIO_STRING;
			break;
		case BINARY_SENSOR:
			deviceTypeName = BINARY_SENSOR_STRING;
			break;
		case BINARY_SENSOR_TWO:
			deviceTypeName = BINARY_SENSOR_TWO_STRING;
			break;
		case PC_CONTROLLER:
			deviceTypeName = PC_CONTROLLER_STRING;
			break;
		case STATIC_CONTROLLER:
			deviceTypeName = STATIC_CONTROLLER_STRING;
			break;
		case SCENE_CONTROLLER:
			deviceTypeName = SCENE_CONTROLLER_STRING;
			break;
		case SCENE_CONTROLLER_PORTABLE:
			deviceTypeName = SCENE_CONTROLLER_PORTABLE_STRING;
			break;
		case SCENE_CONTROLLER_TWO:
			deviceTypeName = SCENE_CONTROLLER_TWO_STRING;
			break;
		case INSTALLER_TOOL:
			deviceTypeName = INSTALLER_TOOL_STRING;
			break;
		case INSTALLER_TOOL_PORTABLE:
			deviceTypeName = INSTALLER_TOOL_PORTABLE_STRING;
			break;
		case REMOTE_CONTROLLER_PORTABLE:
			deviceTypeName = REMOTE_CONTROLLER_PORTABLE_STRING;
			break;
		case METER_GENERIC:
			deviceTypeName = METER_GENERIC_STRING;
			break;
		case REMOTE_SWITCH:
			deviceTypeName = REMOTE_SWITCH_STRING;
			break;
		case MULTILEVEL_SENSOR:
			deviceTypeName = MULTILEVEL_SENSOR_STRING;
			break;
		case ENTRY_CONTROL:
			deviceTypeName = ENTRY_CONTROL_STRING;
			break;
		case SECURE_KEYPAD_ENTRY_CONTROL_DOOR_LOCK:
			deviceTypeName = SECURE_KEYPAD_ENTRY_CONTROL_DOOR_LOCK_STRING;
			break;
		case ADVANCED_ENTRY_CONTROL_DOOR_LOCK:
			deviceTypeName = ADVANCED_ENTRY_CONTROL_DOOR_LOCK_STRING;
			break;
		case BULOGICS_USB_SHUTDOWN_STICK:
			deviceTypeName = BULOGICS_USB_SHUTDOWN_STICK_STRING;
			break;
		case ZIGBEE_METER:
			deviceTypeName = ZIGBEE_METER_STRING;
			break;
		case THERMOSTAT_RCS:
			deviceTypeName = THERMOSTAT_RCS_STRING;
			break;
		case SCENE_CONTROLLER_THREE:
			deviceTypeName = SCENE_CONTROLLER_THREE_STRING;
			break;
		case ZONE_CONTROLLER:
			deviceTypeName = ZONE_CONTROLLER_STRING;
			break;
		case SOMFY_ILT:
			deviceTypeName = SOMFY_ILT_STRING;
			break;
		case SOMFY_RTS:
			deviceTypeName = SOMFY_RTS_STRING;
			break;
			
	}
	
	return deviceTypeName;
}





#pragma mark -
#pragma mark Initialization & Deallocation
static ManufacturerIdToNameMapper *sharedInstance = nil;

+(ManufacturerIdToNameMapper *)getSharedInstance {
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
