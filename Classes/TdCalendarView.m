//
//  CalendarView.m
//
//

#import "TdCalendarView.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

const float headHeight=45;
const float itemHeight=45;
const float prevNextButtonSize=15;
const float prevNextButtonSpaceWidth=20;
const float prevNextButtonSpaceHeight=10;
const float titleFontSize=20;
const int	weekFontSize=10;
const float	dateFontSize=22;

@implementation TdCalendarView

@synthesize currentMonthDate;
@synthesize currentSelectDate;
@synthesize currentTime;
@synthesize viewImageView;
@synthesize calendarViewDelegate;

-(void)initCalView{
	currentTime=CFAbsoluteTimeGetCurrent();
	currentMonthDate=CFAbsoluteTimeGetGregorianDate(currentTime,CFTimeZoneCopyDefault());
	currentMonthDate.day=1;
	currentSelectDate.year=0;
	monthFlagArray=malloc(sizeof(int)*31);
	if ([self.calendarViewDelegate respondsToSelector:@selector(clearAllDayFlag)]) {
		[self.calendarViewDelegate clearAllDayFlag];	
	}
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
		[self initCalView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		[self initCalView];
	}
	return self;
}

-(int)getDayCountOfaMonth:(CFGregorianDate)date{
	switch (date.month) {
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			return 31;
			
		case 2:
			if((date.year % 4==0 && date.year % 100!=0) || date.year % 400==0)
				return 29;
			else
				return 28;
		case 4:
		case 6:
		case 9:		
		case 11:
			return 30;
		default:
			return 31;
	}
}

-(void)drawPrevButton:(CGPoint)leftTop
{
	CGContextRef ctx=UIGraphicsGetCurrentContext();
	CGContextSetGrayStrokeColor(ctx,0.5,1);
	//CGContextSetRGBFillColor (ctx, 0.5, 0, 0, 1);
	CGContextMoveToPoint	(ctx,  0 + leftTop.x, prevNextButtonSize/2 + leftTop.y);
	CGContextAddLineToPoint	(ctx, prevNextButtonSize + leftTop.x,  0 + leftTop.y);
	CGContextAddLineToPoint	(ctx, prevNextButtonSize + leftTop.x,  prevNextButtonSize + leftTop.y);
	CGContextAddLineToPoint	(ctx,  0 + leftTop.x,  prevNextButtonSize/2 + leftTop.y);
	CGContextClosePath(ctx);
	CGContextFillPath(ctx);
}

-(void)drawNextButton:(CGPoint)leftTop
{
	CGContextRef ctx=UIGraphicsGetCurrentContext();
	CGContextSetGrayStrokeColor(ctx,0.5,1);
	//CGContextSetRGBFillColor (ctx, 0.5, 0, 0, 1);
	CGContextMoveToPoint	(ctx,  0 + leftTop.x,  0 + leftTop.y);
	CGContextAddLineToPoint	(ctx, prevNextButtonSize + leftTop.x,  prevNextButtonSize/2 + leftTop.y);
	CGContextAddLineToPoint	(ctx,  0 + leftTop.x,  prevNextButtonSize + leftTop.y);
	CGContextAddLineToPoint	(ctx,  0 + leftTop.x,  0 + leftTop.y);
	CGContextClosePath(ctx);
	CGContextFillPath(ctx);
}


-(void)drawTopGradientBar{

	// Replace contents of drawRect with the following:
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	 
	CGColorRef whiteColor = [UIColor colorWithRed:1.0 green:1.0 
	    blue:1.0 alpha:1.0].CGColor; 
	CGColorRef lightGrayColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 
	    blue:230.0/255.0 alpha:1.0].CGColor;
	 
	// Draw a gradient bar
	int width=self.frame.size.width;
	int height=45;

	CGRect paperRect = CGRectMake (0, 0, width, height);

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGFloat locations[] = { 0.0, 1.0 };
	NSArray *colors = [NSArray arrayWithObjects:(id)whiteColor, (id)lightGrayColor, nil];
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, 
         (CFArrayRef) colors, locations);
 
  CGPoint startPoint = CGPointMake(CGRectGetMidX(paperRect), CGRectGetMinY(paperRect));
	CGPoint endPoint = CGPointMake(CGRectGetMidX(paperRect), CGRectGetMaxY(paperRect));
	 
	CGContextSaveGState(ctx);
	CGContextAddRect(ctx, paperRect);
	CGContextClip(ctx);
	
	CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
	CGContextRestoreGState(ctx);
 
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);

	// Add Title and Arrows
	[self drawPrevButton:CGPointMake(prevNextButtonSpaceWidth,prevNextButtonSpaceHeight)];
	[self drawNextButton:CGPointMake(self.frame.size.width-prevNextButtonSpaceWidth-prevNextButtonSize,prevNextButtonSpaceHeight)];
}

-(void)drawTopBarWords{
	int width=self.frame.size.width;
	int s_width=width/7;

	NSArray *months=[NSArray arrayWithObjects: @"-", @"January",@"February",
												@"March",@"April",@"May",@"June",@"July",
												@"August",@"September",@"October",@"November",@"December", nil];
	[[UIColor blackColor] set];
	NSString *title_Month   = [[NSString alloc] initWithFormat:@"%@ %d",
							   [months objectAtIndex: currentMonthDate.month],
							   currentMonthDate.year];

	// all this, jst so we can horizontally center the month at the top of the widget.
	int fontsize=[UIFont buttonFontSize];
    UIFont *font = [UIFont boldSystemFontOfSize:titleFontSize];

	int textWidth = [title_Month sizeWithFont:font forWidth:width lineBreakMode:UILineBreakModeWordWrap].width;

	CGPoint  location = CGPointMake((width-textWidth)/2, 6);
	CGContextRef ctx = UIGraphicsGetCurrentContext();

	CGContextSaveGState(ctx);
	CGContextSetShadow(ctx, CGSizeMake(0.0f, 1.0f), 0.5f);
	// CGContextClip(ctx);
  [title_Month drawAtPoint:location withFont:font];
	[title_Month release];

	UIFont *weekfont=[UIFont boldSystemFontOfSize:weekFontSize];
	
	[[UIColor blackColor] set];
	[@"Sun" drawAtPoint:CGPointMake(s_width*0+12,fontsize+13) withFont:weekfont];
	[[UIColor blackColor] set];
	[@"Mon" drawAtPoint:CGPointMake(s_width*1+13,fontsize+13) withFont:weekfont];
	[@"Tue" drawAtPoint:CGPointMake(s_width*2+12,fontsize+13) withFont:weekfont];
	[@"Wed" drawAtPoint:CGPointMake(s_width*3+13,fontsize+13) withFont:weekfont];
	[@"Thu" drawAtPoint:CGPointMake(s_width*4+12,fontsize+13) withFont:weekfont];
	[@"Fri" drawAtPoint:CGPointMake(s_width*5+13,fontsize+13) withFont:weekfont];
	[[UIColor blackColor] set];
	[@"Sat" drawAtPoint:CGPointMake(s_width*6+12,fontsize+13) withFont:weekfont];
	[[UIColor blackColor] set];
	CGContextRestoreGState(ctx);
}

-(void)drawGridLines{
	
	CGContextRef ctx=UIGraphicsGetCurrentContext();
	float width=self.frame.size.width;
	int row_Count=([self getDayCountOfaMonth:currentMonthDate]+[self getMonthWeekday:currentMonthDate]-2)/7+1;
	
	int s_width= (int)(width/7 + 0.5); // should rounded up to 46px
	int tabHeight=row_Count*itemHeight+headHeight;


	CGColorRef lighterGray = [UIColor colorWithRed:227.00/255.00 green:226.00/255.00 
	    blue:229.00/255.00 alpha:1.0].CGColor; 
	CGColorRef lightGrayColor = [UIColor colorWithRed:200.0/255.0 green:200.0/205.0 
	    blue:230.0/255.0 alpha:1.0].CGColor;
	CGRect paperRect = CGRectMake (0, 45, width, tabHeight);

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGFloat locations[] = { 0.0, 1.0 };
	NSArray *colors = [NSArray arrayWithObjects:(id)lighterGray, (id)lightGrayColor, nil];
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, 
         (CFArrayRef) colors, locations);
 
  CGPoint startPoint = CGPointMake(CGRectGetMidX(paperRect), CGRectGetMinY(paperRect));
	CGPoint endPoint = CGPointMake(CGRectGetMidX(paperRect), CGRectGetMaxY(paperRect));
	 
	CGContextSaveGState(ctx);
	CGContextAddRect(ctx, paperRect);
	CGContextClip(ctx);
	
	CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
	CGContextRestoreGState(ctx);
 
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);


  // CGContextSetGrayStrokeColor(ctx,0,1);
  // CGContextMoveToPoint  (ctx,0,headHeight);
  // CGContextAddLineToPoint  (ctx,0,tabHeight);
  // CGContextStrokePath    (ctx);
  // CGContextMoveToPoint  (ctx,width,headHeight);
  // CGContextAddLineToPoint  (ctx,width,tabHeight);
  // CGContextStrokePath    (ctx);


	CGColorRef lineWhite = [UIColor colorWithRed:237.00/255.00 green:236.00/255.00 
	    blue:239.00/255.00 alpha:1.0].CGColor; 
	CGColorRef lineGray = [UIColor colorWithRed:161.00/255.00 green:164.00/255.00 
	    blue:173.00/255.00 alpha:1.0].CGColor;

  for(int i=1;i<7;i++){
    CGContextSetStrokeColorWithColor(ctx, lineWhite);
    // Use a hackist -0.5 to make the width of the path 1px
    CGContextMoveToPoint(ctx, i*s_width - 1.5, headHeight);
    CGContextAddLineToPoint(ctx, i*s_width - 1.5,tabHeight);
    CGContextStrokePath(ctx);
  }

  // CGContextSetGrayStrokeColor(ctx,0.3,1);
  // CGContextMoveToPoint(ctx, 45.50f, headHeight);
  // CGContextAddLineToPoint( ctx, 45.50f, tabHeight);
  // CGContextStrokePath(ctx);
  //   // 
  //   CGContextMoveToPoint(ctx, 91.50f, headHeight);
  //   CGContextAddLineToPoint( ctx, 91.50f, tabHeight);
  //   CGContextStrokePath(ctx);
  
  for(int i=0;i<row_Count+1;i++){
      CGContextSetStrokeColorWithColor(ctx, lineGray);
      CGContextMoveToPoint(ctx, 0, i*itemHeight+headHeight-0.5);
      CGContextAddLineToPoint( ctx, width,i*itemHeight+headHeight-0.5);
      CGContextStrokePath(ctx);
      
      CGContextSetStrokeColorWithColor(ctx, lineWhite);
      CGContextMoveToPoint(ctx, 0, i*itemHeight+headHeight + 0.5);
      CGContextAddLineToPoint( ctx, width,i*itemHeight+headHeight + 0.5);
      CGContextStrokePath(ctx);
  }
  for(int i=1;i<7;i++){
      CGContextSetStrokeColorWithColor(ctx, lineGray);
      CGContextMoveToPoint(ctx, i*s_width-0.5, headHeight);
      CGContextAddLineToPoint( ctx, i*s_width-0.5,tabHeight);
      CGContextStrokePath(ctx);
    }
}


-(int)getMonthWeekday:(CFGregorianDate)date
{
	CFTimeZoneRef tz = CFTimeZoneCopyDefault();
	CFGregorianDate month_date;
	month_date.year=date.year;
	month_date.month=date.month;
	month_date.day=1;
	month_date.hour=0;
	month_date.minute=0;
	month_date.second=1;
	return (int)CFAbsoluteTimeGetDayOfWeek(CFGregorianDateGetAbsoluteTime(month_date,tz),tz);
}

-(void)drawDateWords{
	CGContextRef ctx=UIGraphicsGetCurrentContext();

	int width=self.frame.size.width;
	
	int dayCount=[self getDayCountOfaMonth:currentMonthDate];
	int day=0;
	int x=0;
	int y=0;
	int s_width=width/7;
	int curr_Weekday=[self getMonthWeekday:currentMonthDate];
	UIFont *weekfont=[UIFont boldSystemFontOfSize:dateFontSize];

	for(int i=1;i<dayCount+1;i++)
	{
		day=i+curr_Weekday-1;
		x=day % 7;
		y=day / 7;
		NSString *date=[[[NSString alloc] initWithFormat:@"%2d",i] autorelease];
		[date drawAtPoint:CGPointMake(x*s_width+10,y*itemHeight+headHeight+10) withFont:weekfont];
		
		CFGregorianDate tmpDate = currentMonthDate;
		tmpDate.day = i;
		// TBD make this into an array of matching events ?
		int retFlag = [self.calendarViewDelegate getDayFlag:tmpDate];
		
		if(retFlag==1)
		{
			CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
			[@"." drawAtPoint:CGPointMake(x*s_width+19,y*itemHeight+headHeight+6) withFont:[UIFont boldSystemFontOfSize:dateFontSize]];
		}
		else if(retFlag==-1)
		{
			CGContextSetRGBFillColor(ctx, 0, 8.5, 0.3, 1);
			[@"." drawAtPoint:CGPointMake(x*s_width+19,y*itemHeight+headHeight+6) withFont:[UIFont boldSystemFontOfSize:dateFontSize]];
		}
			
		CGContextSetRGBFillColor(ctx, 0, 0, 0, 1);

	}
}


- (void) movePrevNext:(int)isPrev{
	currentSelectDate.year=0;
	if ([self.calendarViewDelegate respondsToSelector:@selector(beforeMonthChange:willto:)]) {		
		[calendarViewDelegate beforeMonthChange:self willto:currentMonthDate];
	}
	int width=self.frame.size.width;
	int posX;
	if(isPrev==1)
	{
		posX=width;
	}
	else
	{
		posX=-width;
	}
	
	UIImage *viewImage;
	
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];	
	viewImage= UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	if(viewImageView==nil)
	{
		viewImageView=[[UIImageView alloc] initWithImage:viewImage];
		
		viewImageView.center=self.center;
		[[self superview] addSubview:viewImageView];
	}
	else
	{
		viewImageView.image=viewImage;
	}
	
	viewImageView.hidden=NO;
	viewImageView.transform=CGAffineTransformMakeTranslation(0, 0);
	self.hidden=YES;
	[self setNeedsDisplay];
	self.transform=CGAffineTransformMakeTranslation(posX,0);
	
	
	float height;
	int row_Count=([self getDayCountOfaMonth:currentMonthDate]+[self getMonthWeekday:currentMonthDate]-2)/7+1;
	height=row_Count*itemHeight+headHeight;
	self.hidden=NO;
	[UIView beginAnimations:nil	context:nil];
	[UIView setAnimationDuration:0.5];
	self.transform=CGAffineTransformMakeTranslation(0,0);
	viewImageView.transform=CGAffineTransformMakeTranslation(-posX, 0);
	[UIView commitAnimations];
	if ([self.calendarViewDelegate respondsToSelector:@selector(monthChanged:viewLeftTop:height:)]) {
		[calendarViewDelegate monthChanged:currentMonthDate viewLeftTop:self.frame.origin height:height];
	}
}

- (void)movePrevMonth{
	if(currentMonthDate.month>1)
		currentMonthDate.month-=1;
	else
	{
		currentMonthDate.month=12;
		currentMonthDate.year-=1;
	}
	[self movePrevNext:0];
}

- (void)moveNextMonth{
	if(currentMonthDate.month<12)
		currentMonthDate.month+=1;
	else
	{
		currentMonthDate.month=1;
		currentMonthDate.year+=1;
	}
	[self movePrevNext:1];	
}

- (void) drawToday{
	int x;
	int y;
	int day;
	CFGregorianDate today=CFAbsoluteTimeGetGregorianDate(currentTime, CFTimeZoneCopyDefault());
	if(today.month==currentMonthDate.month && today.year==currentMonthDate.year)
	{
		int width=self.frame.size.width;
		int swidth=width/7;
		int weekday=[self getMonthWeekday:currentMonthDate];
		day=today.day+weekday-1;
		x=day%7;
		y=day/7;
		CGContextRef ctx=UIGraphicsGetCurrentContext();

    CGColorRef darkGreyColor = [UIColor colorWithRed:141.0/255.00 green:127.0/255.00 
        blue:119.0/255.00 alpha:1.0].CGColor;
      
    CGContextSetFillColorWithColor(ctx, darkGreyColor);
    CGContextMoveToPoint(ctx, x*swidth+1, y*itemHeight+headHeight);
    CGContextAddLineToPoint(ctx, x*swidth+swidth+2, y*itemHeight+headHeight);
    CGContextAddLineToPoint(ctx, x*swidth+swidth+2, y*itemHeight+headHeight+itemHeight);
    CGContextAddLineToPoint(ctx, x*swidth+1, y*itemHeight+headHeight+itemHeight);
    CGContextFillPath(ctx);
    
    // int tileWidth = 45;
    // int tileHeight = 45;
    // CGRect tileRect = CGRectMake (x*swidth+1, y*itemHeight+headHeight, tileWidth, tileHeight);
    // CGContextSetFillColorWithColor(ctx, darkGreyColor);
    // CGContextFillRect(ctx, tileRect);
    // CGContextAddRect(ctx, tileRect);

    // CGRect strokeRect = CGRectInset(paperRect, 5.0, 5.0);
    //  
    //     CGContextSetStrokeColorWithColor(context, redColor);
    //     CGContextSetLineWidth(context, 1.0);
    //     CGContextStrokeRect(context, strokeRect);
    
    
		CGContextSetRGBFillColor(ctx, 1, 1, 1, 1); //today date font color
		UIFont *weekfont=[UIFont boldSystemFontOfSize:dateFontSize];
		NSString *date=[[[NSString alloc] initWithFormat:@"%2d",today.day] autorelease];
		[date drawAtPoint:CGPointMake(x*swidth+10,y*itemHeight+headHeight+10) withFont:weekfont];
		
		int retFlag = [self.calendarViewDelegate getDayFlag:today];

		if(retFlag==1)
		{
			CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
			[@"." drawAtPoint:CGPointMake(x*swidth+19,y*itemHeight+headHeight+6) withFont:[UIFont boldSystemFontOfSize:dateFontSize]];
		}
		else if(retFlag==-1)
		{
			CGContextSetRGBFillColor(ctx, 0, 8.5, 0.3, 1);
			[@"." drawAtPoint:CGPointMake(x*swidth+19,y*itemHeight+headHeight+6) withFont:[UIFont boldSystemFontOfSize:dateFontSize]];
		}
		
	}
}

- (void) drawCurrentSelectDate{
	int x;
	int y;
	int day;
	int todayFlag;
	if (currentSelectDate.year!=0)
	{
		CFGregorianDate today=CFAbsoluteTimeGetGregorianDate(currentTime, CFTimeZoneCopyDefault());

		if(today.year==currentSelectDate.year && today.month==currentSelectDate.month && today.day==currentSelectDate.day)
			todayFlag=1;
		else
			todayFlag=0;
		
		int width=self.frame.size.width;
		int swidth=width/7;
		int weekday=[self getMonthWeekday:currentMonthDate];
		day=currentSelectDate.day+weekday-1;
		x=day%7;
		y=day/7;
		CGContextRef ctx=UIGraphicsGetCurrentContext();
    
    CGColorRef whiteColor = [UIColor colorWithRed:255.0 green:255.0 
        blue:255.0 alpha:1.0].CGColor;
    CGColorRef pinkColor = [UIColor colorWithRed:119.0/255.00 green:73.0/255.00 
        blue:150.0/255.00 alpha:1.0].CGColor;

    // Using Path to draw rectangle
    // CGContextSetFillColorWithColor(ctx, pinkColor);
    // CGContextMoveToPoint(ctx, x*swidth+1, y*itemHeight+headHeight);
    // CGContextAddLineToPoint(ctx, x*swidth+swidth+2, y*itemHeight+headHeight);
    // CGContextAddLineToPoint(ctx, x*swidth+swidth+2, y*itemHeight+headHeight+itemHeight);
    // CGContextAddLineToPoint(ctx, x*swidth+1, y*itemHeight+headHeight+itemHeight);
    // CGContextFillPath(ctx);  
    
    
    //---- Drawing a rectangle using CGRectMake is much simpler ---
    int tileWidth = 45;
    int tileHeight = 45;
    
    //TODO: set tileWidth to 48 if the tile is the 7th row

    CGRect tileRect = CGRectMake (x*swidth+1, y*itemHeight+headHeight, tileWidth, tileHeight);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = [NSArray arrayWithObjects:(id)pinkColor, (id)whiteColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, 
               (CFArrayRef) colors, locations);
     
    CGPoint startPoint = CGPointMake(CGRectGetMidX(tileRect), CGRectGetMinY(tileRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(tileRect), CGRectGetMaxY(tileRect));
       
    CGContextSaveGState(ctx);
    CGContextAddRect(ctx, tileRect);
    CGContextClip(ctx);
      
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(ctx);
     
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);   
    
    //----
		
		if(todayFlag==1)
		{
			CGContextSetRGBFillColor(ctx, 0, 0, 1, 1);
			CGContextMoveToPoint	(ctx, x*swidth+4,			y*itemHeight+headHeight+3);
			CGContextAddLineToPoint	(ctx, x*swidth+swidth-1,	y*itemHeight+headHeight+3);
			CGContextAddLineToPoint	(ctx, x*swidth+swidth-1,	y*itemHeight+headHeight+itemHeight-3);
			CGContextAddLineToPoint	(ctx, x*swidth+4,			y*itemHeight+headHeight+itemHeight-3);
			CGContextFillPath(ctx);	
		}
		
		CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);

		UIFont *weekfont=[UIFont boldSystemFontOfSize:12];
		NSString *date=[[[NSString alloc] initWithFormat:@"%2d",currentSelectDate.day] autorelease];
		[date drawAtPoint:CGPointMake(x*swidth+10,y*itemHeight+headHeight+10) withFont:[UIFont boldSystemFontOfSize:dateFontSize]];
		
		int retFlag = [self.calendarViewDelegate getDayFlag:today];
		if (retFlag!=0)
		{
			[@"." drawAtPoint:CGPointMake(x*swidth+19,y*itemHeight+headHeight+6) withFont:[UIFont boldSystemFontOfSize:dateFontSize]];
		}
		
	}
}

- (void) touchAtDate:(CGPoint) touchPoint{
	int x;
	int y;
	int width=self.frame.size.width;
	int weekday=[self getMonthWeekday:currentMonthDate];
	int monthDayCount=[self getDayCountOfaMonth:currentMonthDate];
	x=touchPoint.x*7/width;
	y=(touchPoint.y-headHeight)/itemHeight;
	int monthday=x+y*7-weekday+1;

	if(monthday>0 && monthday<monthDayCount+1)
	{
		currentSelectDate.year=currentMonthDate.year;
		currentSelectDate.month=currentMonthDate.month;
		currentSelectDate.day=monthday;
		currentSelectDate.hour=0;
		currentSelectDate.minute=0;
		currentSelectDate.second=1;
		if ([self.calendarViewDelegate respondsToSelector:@selector(selectDateChanged:)]) {
			[self.calendarViewDelegate selectDateChanged:currentSelectDate];
		}
		[self setNeedsDisplay];
	}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    int width=self.frame.size.width;
	UITouch* touch=[touches anyObject];
	CGPoint touchPoint=[touch locationInView:self];
	if(touchPoint.x<40 && touchPoint.y<headHeight)
		[self movePrevMonth];
	else if(touchPoint.x>width-40 && touchPoint.y<headHeight)
		[self moveNextMonth];
	else if(touchPoint.y>headHeight)
	{
		[self touchAtDate:touchPoint];
	}
}

- (void)drawRect:(CGRect)rect{

	static int once=0;
	currentTime=CFAbsoluteTimeGetCurrent();
	
	[self drawTopGradientBar];
	[self drawTopBarWords];
	[self drawGridLines];
	
	if(once==0)
	{
		once=1;
		float height;
		int row_Count=([self getDayCountOfaMonth:currentMonthDate]+[self getMonthWeekday:currentMonthDate]-2)/7+1;
		height=row_Count*itemHeight+headHeight;
		if ([self.calendarViewDelegate respondsToSelector:@selector(monthChanged:viewLeftTop:height:)]) {
			[calendarViewDelegate monthChanged:currentMonthDate viewLeftTop:self.frame.origin height:height];
		}
		if ([self.calendarViewDelegate respondsToSelector:@selector(beforeMonthChange:willto:)]) {		
			[calendarViewDelegate beforeMonthChange:self willto:currentMonthDate];
		}
	}
	[self drawDateWords];
	[self drawToday];
	[self drawCurrentSelectDate];
	
}

- (void)dealloc {
    [super dealloc];
	free(monthFlagArray);
}


@end
