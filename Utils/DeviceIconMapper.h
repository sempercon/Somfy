//
//  DeviceIconMapper.h
//  Somfy
//
//  Created by Sempercon on 5/9/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface DeviceIconMapper : NSObject {

}


+ (DeviceIconMapper *)getSharedInstance;
-(UIImage*) getDeviceImageBasedOnDeviceTypeandDeviceValue:(int)deviceType :(int)deviceValue :(int)somfyDeviceType;
-(UIImage *) getDeviceImageBasedOnDeviceType :(int)deviceType :(int)somfyDeviceType;
-(UIImage *)getSomfyDeviceImageBasedOnDeviceType:(int)somfyDeviceType;
-(NSString*)determineDeviceLabel:(int)_somfyDeviceType;
-(UIImage *) getDeviceForiPhoneImageBasedOnDeviceType :(int)deviceType :(int)somfyDeviceType:(int)deviceValue;
-(UIImage *)getSomfyDeviceForiPhoneImageBasedOnDeviceType:(int)somfyDeviceType;
-(UIImage *)getSomfyDeviceImageBasedOnValue:(int)somfyDeviceType :(int) deviceValue;


@end
