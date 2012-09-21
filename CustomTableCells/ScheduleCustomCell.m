//
//  ScheduleCustomCell.m
//  Somfy
//
//  Created by Karuppiah Annamalai on 7/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScheduleCustomCell.h"


@implementation ScheduleCustomCell

@synthesize backgroundImg,img;
@synthesize lblScheduleName,lblScheduleEnable;
@synthesize arrowBtn;
@synthesize delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		backgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 50)];
		backgroundImg.backgroundColor = [UIColor clearColor];
		backgroundImg.contentMode = UIViewContentModeScaleToFill;
		[self.contentView addSubview:backgroundImg];
		
		img = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
		img.backgroundColor = [UIColor clearColor];
		img.contentMode = UIViewContentModeScaleToFill;
		[self.contentView addSubview:img];
		
		lblScheduleName = [[[UILabel alloc]initWithFrame:CGRectMake(60, 7, 200, 25)]autorelease];
		lblScheduleName.textColor=[UIColor blackColor];
		lblScheduleName.backgroundColor=[UIColor clearColor];
		lblScheduleName.lineBreakMode= UILineBreakModeWordWrap;
		lblScheduleName.contentMode = UIViewContentModeScaleToFill;
		lblScheduleName.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
		lblScheduleName.numberOfLines=0;
		[self.contentView addSubview:lblScheduleName];
		
		lblScheduleEnable = [[[UILabel alloc]initWithFrame:CGRectMake(60, 25, 200, 25)]autorelease];
		lblScheduleEnable.textColor=[UIColor blackColor];
		lblScheduleEnable.backgroundColor=[UIColor clearColor];
		lblScheduleEnable.lineBreakMode= UILineBreakModeWordWrap;
		lblScheduleEnable.contentMode = UIViewContentModeScaleToFill;
		lblScheduleEnable.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
		lblScheduleEnable.numberOfLines=0;
		[self.contentView addSubview:lblScheduleEnable];
		
		arrowBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		arrowBtn.frame=CGRectMake(270, 10, 25, 25);
		[arrowBtn setBackgroundImage:[UIImage imageNamed:@"sh_arrow.png"] forState:UIControlStateNormal];
		[arrowBtn addTarget:self action:@selector(Onclick:)  forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:arrowBtn];
    }
    return self;
}

-(void)Onclick:(id)sender
{
	if ([delegate respondsToSelector:@selector(ScheduleSelected:)])
    {
        [delegate ScheduleSelected:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {

	[delegate release];
	[backgroundImg,img release];
	[lblScheduleName,lblScheduleEnable release];
	[arrowBtn release];
    
	[super dealloc];
}


@end
