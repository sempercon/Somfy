//
//  ManufacturerIdToNameMapper.h
//  Somfy
//
//  Created by mac user on 6/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"Globals.h"
#import "Constants.h"

@interface ManufacturerIdToNameMapper : NSObject {

}

+ (ManufacturerIdToNameMapper *)getSharedInstance;
-(NSString*)mapManufacturerIdToName:(int)ManufacturerId;
-(NSString*)mapDeviceIdToName:(int)deviceType;

@end
