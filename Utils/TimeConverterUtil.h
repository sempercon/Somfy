//
//  TimeConverterUtil.h
//  Somfy
//
//  Created by Sempercon on 5/27/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TimeConverterUtil : NSObject {
	int Hours,Minutes;
}

+ (TimeConverterUtil *)getSharedInstance;
-(int)getHours;
-(int)getMinutes;
-(void)convertTimeFromMinutesAfterMidnight:(int)time;
-(int)convertTimeToMinutesAfterMidnight:(int)hours :(int)minutes;
-(BOOL)containsDate:(NSString*)date;

@end
