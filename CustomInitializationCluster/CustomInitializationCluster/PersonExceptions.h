//
//  PersonExceptions.h
//  CustomInitializationCluster
//
//  Created by Dan Zinngrabe on 9/28/15.
//  Copyright © 2015 Dan Zinngrabe. All rights reserved.
//

#ifndef __PersonExceptions_h__
#define __PersonExceptions_h__

#ifdef CLANG_ENABLE_MODULES
@import CoreFoundation;
@import Foundation;
#else
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#endif

#include <os/activity.h>
#include <os/trace.h>

#ifdef __cplusplus
extern "C" {
#endif
    
#pragma mark Function prototypes
    
    void SubclassResponsibility(void) __attribute__((weak));
    
#pragma mark Macros
    
#ifndef SubclassResponsibility
#define SubclassResponsibility() \
_SubclassResponsibility(_cmd,self,__FILE__,__LINE__); __builtin_unreachable()
#endif
    
#pragma mark Inline functions
    
    static inline void _SubclassResponsibility(SEL selector,id object,const char *file,int line) {
        os_trace_fault("Invalid abstract invocation exception on line: %d", line);
        [NSException raise:NSInvalidArgumentException
                    format:@"-%s only defined for abstract class. Define -[%@ %s] in %s:%d!",
         sel_getName (selector),[object class], sel_getName (selector),file,line];
    }
    
    
#ifdef __cplusplus
}
#endif

#endif


