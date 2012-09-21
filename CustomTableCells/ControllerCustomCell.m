//
//  ControllerCustomCell.m
//  Somfy
//
//  Created by Sempercon on 7/29/11.
//  Copyright 2011 __Sempercon__. All rights reserved.
//

#import "ControllerCustomCell.h"


@implementation ControllerCustomCell

@synthesize lblControllerName;
@synthesize imgBg;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
		imgBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 302 ,47)];
		imgBg.backgroundColor = [UIColor clearColor];
		imgBg.contentMode = UIViewContentModeScaleToFill;
		imgBg.image = [UIImage imageNamed:@"Line_BG.png"];
		[self.contentView addSubview:imgBg];
		
		lblControllerName=[[UILabel alloc]initWithFrame:CGRectMake(10,0,250,45)];
		lblControllerName.textColor=[UIColor colorWithRed:(float)68/255 green:(float)73/255 blue:(float)74/255 alpha:1.0]; //204 219 212
		lblControllerName.backgroundColor=[UIColor clearColor];
		lblControllerName.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
		lblControllerName.textAlignment = UITextAlignmentLeft;
		lblControllerName.lineBreakMode= UILineBreakModeWordWrap;
		lblControllerName.contentMode = UIViewContentModeScaleToFill;
		lblControllerName.numberOfLines=0;
		lblControllerName.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
		[self.contentView addSubview:lblControllerName];
		
	}
    return self;
}



- (void)dealloc 
{
	[lblControllerName release];
    [imgBg release];
    [super dealloc];
}


@end
