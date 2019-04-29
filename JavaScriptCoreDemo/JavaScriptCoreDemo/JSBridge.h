//
//  BLEBridge.h
//  test
//
//  Created by xuanyan.lyw on 16/4/1.
//  Copyright © 2016年 xuanyan.lyw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "Person.h"


@interface JSBridge : NSObject


- (void)regiestJSFunctionInContext:(JSContext *) jsContext;

- (NSString *)callJSHello:(NSString *)name;

@end


