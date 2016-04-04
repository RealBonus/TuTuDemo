//
//  AppDelegate.m
//  TutuDemo
//
//  Created by Павел Анохов on 31.03.16.
//  Copyright © 2016 IndependentLabs. All rights reserved.
//

#import "AppDelegate.h"
#import "TTDDemoDataController.h"

static NSString *const kInMemoryStore = @"inMemoryStore";
static NSString *const kStoreName = @"db.sqlite";
static NSString *const kManagedObjectModelName = @"Model";

@interface AppDelegate ()

@end

@implementation AppDelegate {
    TTDDemoDataController *_dataController;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BOOL inMemoryStore = [[[NSProcessInfo processInfo] arguments] containsObject:kInMemoryStore];
    
    _dataController = [[TTDDemoDataController alloc] init];
    NSError *error = nil;
    
    if (inMemoryStore) {
        if (![_dataController createInMemoryStoreWithModel:[AppDelegate modelURL] error:&error]) {
            NSLog(@"Error creating inMemmory store: %@", error);
        }
    } else {
        if (![_dataController openStore:[AppDelegate storeURL] withModel:[AppDelegate modelURL] error:&error]) {
            NSLog(@"Error opening store: %ld, %@, %@", (long)error.code, error.domain, error.userInfo);
            abort();
        }
    }
    
    NSString *demoDataPath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"json"];
    [_dataController loadDataFrom:demoDataPath];
    
    if ([self.window.rootViewController conformsToProtocol:@protocol(TTDDataControllerUser)]) {
        [(id<TTDDataControllerUser>)self.window.rootViewController setDataController:_dataController];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [_dataController saveContext];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [_dataController saveContext];
}


#pragma mark - Application URLs
+ (NSURL*)storeURL
{
    NSError *error;
    NSURL* documentsDirectory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    
    if (error)
        NSLog(@"Error opening/creating store: %@", error);
    
    return [documentsDirectory URLByAppendingPathComponent:kStoreName];
}

+ (NSURL*)modelURL
{
    return [[NSBundle mainBundle] URLForResource:kManagedObjectModelName withExtension:@"momd"];
}

@end
