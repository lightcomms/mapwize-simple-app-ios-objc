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
@property (atomic) BOOL beaconsFromServerAvailable;
@property (atomic,strong) id beacons;
@end

@implementation LVLCIndoorLocationProvider

-(instancetype)init{
    self =[super init];
    self.lastIndoorLocation=[[ILIndoorLocation alloc]init];
    _beaconsFromServerAvailable = false;
    dispatch_async([self getBackgroundQueue], ^{
        NSError * error =nil;
        NSURL *url = [NSURL URLWithString:@"https://api.mapwize.io/v1/beacons?api_key=e2af1248a493cd196fe54b1dbdba8ba8&venueId=5a8b1432c0b1600013546407"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        _beacons = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
        if (error) _beaconsFromServerAvailable = false;
        else _beaconsFromServerAvailable = true;
    });
    
    
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

-(ILIndoorLocation*) locationFromServer:(NSString*) vlcid{
    if (!_beacons) return nil;
    ILIndoorLocation * innerIndoorLocation = [[ILIndoorLocation alloc]init];
    for (id beacon in self.beacons) {
        // do something with object
        if([(NSString *) [beacon objectForKey:@"type"] isEqualToString:@"vlc"]
           && [(NSString *) [[beacon objectForKey:@"properties"] objectForKey:@"lightId" ] hasPrefix:[vlcid substringToIndex:3]]){
            [innerIndoorLocation setAccuracy:0];
            [innerIndoorLocation setLongitude:[[[beacon objectForKey:@"location"] valueForKey:@"lon" ] doubleValue] ] ;
            [innerIndoorLocation setLatitude:[[[beacon objectForKey:@"location"] valueForKey:@"lat" ] doubleValue] ] ;
            [innerIndoorLocation setFloor: [NSNumber numberWithInteger:[[beacon valueForKey:@"floor"] integerValue]]];
            return innerIndoorLocation;
        }
    }
    return nil;
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
    
    ILIndoorLocation * localIndoorLocation ;
    if (self.beaconsFromServerAvailable)
        localIndoorLocation=[self locationFromServer:self.vlcID];
    else
        localIndoorLocation=[self locationFromHardVLCTable:self.vlcID];
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
