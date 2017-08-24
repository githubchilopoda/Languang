//
//  NSDate+Different.m
//  eCloud
//
//  Created by Dave William on 2017/8/14.
//  Copyright © 2017年 网信. All rights reserved.
//

#import "NSDate+Different.h"

@implementation NSDate (Different)


/**
 
 *  是否为今天
 
 */

- (BOOL)isToday

{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    
    
    // 1.获得当前时间的年月日
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    
    
    // 2.获得self的年月日
    
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return
    
    (selfCmps.year == nowCmps.year) &&
    
    (selfCmps.month == nowCmps.month) &&
    
    (selfCmps.day == nowCmps.day);
    
}


/**
 
 *  是否为昨天
 
 */

- (BOOL)isYesterday

{
    
    // 2014-05-01
    
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    
    
    // 2014-04-30
    
    NSDate *selfDate = [self dateWithYMD];
    
    
    
    // 获得nowDate和selfDate的差距
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.day == 1;
    
}


/**
 
 *  是否为今年
 
 */

- (BOOL)isThisYear

{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int unit = NSCalendarUnitYear;
    
    
    
    // 1.获得当前时间的年月日
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    
    
    // 2.获得self的年月日
    
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    
    
    return nowCmps.year == selfCmps.year;
    
}


/**
 
 *  返回一个只有年月日的时间
 
 */

- (NSDate *)dateWithYMD

{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *selfStr = [fmt stringFromDate:self];
    
    return [fmt dateFromString:selfStr];
    
}


/**
 
 *  获得与当前时间的差距
 
 */

- (NSDateComponents *)deltaWithNow

{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
    
}



@end
