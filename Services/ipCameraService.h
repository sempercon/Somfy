//
//  ipCameraService.h
//  Somfy
//
//  Created by Sempercon on 5/31/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendCommand.h"

@interface ipCameraService : NSObject {
	NSString *command;
}

+ (ipCameraService *)getSharedInstance;
-(void)get_zonoff_ip_camera_get_list:(id<ParserCallback>)delegate;

@end
