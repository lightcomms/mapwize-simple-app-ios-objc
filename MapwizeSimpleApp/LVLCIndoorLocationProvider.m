//
//  LVLCIndoorLocationProvider.m
//  MapwizeSimpleApp
//
//  Created by Melendez Xavier on 22/02/2018.
//  Copyright © 2018 Etienne Mercier. All rights reserved.
//
#import "LVLCIndoorLocationProvider.h"
#import <libvlc/VLCCallbackDelegate.h>
#import <libvlc/VLCSequencer.hpp>

#define TimeStamp [[NSDate date] timeIntervalSince1970]


@interface LVLCIndoorLocationProvider () <VLCCallbackDelegate>
@property (atomic,strong) dispatch_queue_t backgroundQueue;
@property (atomic,strong) ILIndoorLocation* lastIndoorLocation;
@property (atomic,strong) NSString * vlcID;
@end

@implementation LVLCIndoorLocationProvider

-(instancetype)init{
    self =[super init];
    self.lastIndoorLocation=[[ILIndoorLocation alloc]init];
    return self;
}
#pragma mark - Memory/Thread management
-(dispatch_queue_t )getBackgroundQueue{
    if (_backgroundQueue ==nil)
        _backgroundQueue = dispatch_queue_create("io.slms.decoding_queue.vlc", DISPATCH_QUEUE_SERIAL);
    return _backgroundQueue;
}
#pragma mark - start/stop ILLocationProvider implementation
-(void)start{
    [VLCSequencer start:[self getBackgroundQueue] withListener:self];
}

-(void)stop{
    [VLCSequencer stop:[self getBackgroundQueue] withListener:self];
}

-(ILIndoorLocation*) locationFromHardVLCTable:(NSString*) vlcid{
    ILIndoorLocation * innerIndoorLocation = [[ILIndoorLocation alloc]init];
    if([vlcid hasPrefix:@"0x71"]){
        [innerIndoorLocation setAccuracy:0];
        [innerIndoorLocation setLongitude:2.168635725975037];
        [innerIndoorLocation setLatitude:48.887988338992166];
        [innerIndoorLocation setFloor: [NSNumber numberWithInteger:7]];
        return innerIndoorLocation;
    }else if ([vlcid hasPrefix:@"0x68"]){
        [innerIndoorLocation setAccuracy:0];
        [innerIndoorLocation setLongitude:2.1684533357620244];
        [innerIndoorLocation setLatitude:48.8880923937327];
        [innerIndoorLocation setFloor: [NSNumber numberWithInteger:7]];
        return innerIndoorLocation;
    }else {
        return nil;
    }
    
}
#pragma mark - VLCCallbacks
-(void)onError:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(message)
        {
            [self dispatchDidFailWithError:nil];
        }
    });
    
}
-(void)onNewMessage:(NSString *)message
{
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    self.vlcID = [json valueForKey:@"data"];
    
    ILIndoorLocation * localIndoorLocation = [self locationFromHardVLCTable:self.vlcID];
    if (localIndoorLocation==nil) return;
    if (([localIndoorLocation floor]!=[self.lastIndoorLocation floor])
        ||([localIndoorLocation longitude]!=[self.lastIndoorLocation longitude])
        ||([localIndoorLocation latitude]!=[self.lastIndoorLocation latitude])
        ){
        [self.lastIndoorLocation setFloor:localIndoorLocation.floor];
        [self.lastIndoorLocation setLatitude:localIndoorLocation.latitude];
        [self.lastIndoorLocation setLongitude:localIndoorLocation.longitude];
        [self.lastIndoorLocation setTimestamp:[NSDate date] ];
        dispatch_async(dispatch_get_main_queue(), ^{
            @synchronized(self.lastIndoorLocation)
            {
                [self dispatchDidUpdateLocation:self.lastIndoorLocation];
            }
        });
    }else{
        [self.lastIndoorLocation setTimestamp:[NSDate date] ];
    }
}

-(void)onProcessStarted:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(message)
        {
            [self dispatchDidStart];
        }
    });
}
-(void)onProcessStopped:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(message)
        {
            [self dispatchDidStop];
        }
    });
}

@end
