//
//  DeviceSkinChooser.h
//  Somfy
//
//  Created by Sempercon on 5/14/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BinaryLightDeviceView.h"
#import "DimmerDeviceView.h"
#import "ThermostatView.h"

@interface DeviceSkinChooser : NSObject {

}
+ (DeviceSkinChooser *)getSharedInstance;
-(id) getDeviceSkinBasedOnDeviceType :(int)deviceType;

@end
