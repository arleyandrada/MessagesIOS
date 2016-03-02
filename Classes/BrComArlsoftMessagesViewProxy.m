/**
 * MIT License
 * Copyright (c) 2014-present
 * ArlSoft Tecnologia <contato@arlsoft.com.br>
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

#import "BrComArlsoftMessagesViewProxy.h"
#import "BrComArlsoftMessagesView.h"
#import "TiUtils.h"

#define ID NSStringFromClass([BrComArlsoftMessagesViewProxy class])

@implementation BrComArlsoftMessagesViewProxy

bool viewWillAttachFired = NO;
bool viewWillDetachFired = NO;

-(id)init
{
	// This is the designated initializer method and will always be called
	// when the view proxy is created.
	
	//NSLog(@"[INFO] VIEWPROXY LIFECYCLE EVENT init");
	
	return [super init];
}

-(void)_destroy
{
	// This method is called from the dealloc method and is good place to
	// release any objects and memory that have been allocated for the view proxy.
	
	//NSLog(@"[INFO] VIEWPROXY LIFECYCLE EVENT _destroy");
	
	messageDataForIndex = nil;
	messageDataCount = nil;

    cellAvatarCustomization = nil;
    cellTimestampCustomization = nil;
    cellSenderNameCustomization = nil;
    cellBubbleCustomization = nil;

	attributedTextForCellTopLabelAtIndexPath = nil;
	attributedTextForMessageBubbleTopLabelAtIndexPath = nil;
	attributedTextForCellBottomLabelAtIndexPath = nil;

    heightForCellTopLabelAtIndexPath = nil;
	heightForMessageBubbleTopLabelAtIndexPath = nil;
	heightForCellBottomLabelAtIndexPath = nil;
    
	[super _destroy];
}

-(void)dealloc
{
	// This method is called when the view proxy is being deallocated. The superclass
	// method calls the _destroy method.
	
	//NSLog(@"[INFO] VIEWPROXY LIFECYCLE EVENT dealloc");
}

-(id)_initWithPageContext:(id<TiEvaluator>)context
{
	// This method is one of the initializers for the view proxy class. If the
	// proxy is created without arguments then this initializer will be called.
	// This method is also called from the other _initWithPageContext method.
	// The superclass method calls the init and _configure methods.
	
	//NSLog(@"[INFO] VIEWPROXY LIFECYCLE EVENT _initWithPageContext (no arguments)");

	return [super _initWithPageContext:context];
}

-(id)_initWithPageContext:(id<TiEvaluator>)context_ args:(NSArray*)args
{
	// This method is one of the initializers for the view proxy class. If the
	// proxy is created with arguments then this initializer will be called.
	// The superclass method calls the _initWithPageContext method without
	// arguments.
	
	//NSLog(@"[INFO] VIEWPROXY LIFECYCLE EVENT _initWithPageContext %@", args);
	
	return [super _initWithPageContext:context_ args:args];
}

-(void)_configure
{
	// This method is called from _initWithPageContext to allow for
	// custom configuration of the module before startup. The superclass
	// method calls the startup method.
	
	//NSLog(@"[INFO] VIEWPROXY LIFECYCLE EVENT _configure");
	
	[super _configure];
}

-(void)_initWithProperties:(NSDictionary *)properties
{
	// This method is called from _initWithPageContext if arguments have been
	// used to create the view proxy. It is called after the initializers have completed
	// and is a good point to process arguments that have been passed to the
	// view proxy create method since most of the initialization has been completed
	// at this point.
	
	//NSLog(@"[INFO] VIEWPROXY LIFECYCLE EVENT _initWithProperties %@", properties);
	
	[super _initWithProperties:properties];
}

-(void)viewWillAttach
{
	// This method is called right before the view is attached to the proxy
	
	//NSLog(@"[INFO] VIEWPROXY LIFECYCLE EVENT viewWillAttach");

    if (view != nil && !viewWillAttachFired) {
        //NSLog(@"[INFO] VIEWPROXY LIFECYCLE EVENT viewWillAttach!!");
        [((BrComArlsoftMessagesView*)view) viewWillAppear:YES];
        viewWillAttachFired = YES;
    }
}

-(void)viewDidAttach
{
	// This method is called right after the view has attached to the proxy
    
    if (view != nil && !viewWillAttachFired) {
        //NSLog(@"[INFO] VIEWPROXY LIFECYCLE EVENT viewWillAttach!!");
        [((BrComArlsoftMessagesView*)view) viewWillAppear:YES];
        viewWillAttachFired = YES;
    }

	//NSLog(@"[INFO] VIEWPROXY LIFECYCLE EVENT viewDidAttach");

    if (view != nil) {
        //NSLog(@"[INFO] VIEWPROXY LIFECYCLE EVENT viewDidAttach!!");
        [((BrComArlsoftMessagesView*)view) viewDidAppear:YES];
    }
}

-(void)viewDidDetach
{
	// This method is called right before the view is detached from the proxy
	
	//NSLog(@"[INFO] VIEWPROXY LIFECYCLE EVENT viewDidDetach");

    if (view != nil) {
        //NSLog(@"[INFO] VIEWPROXY LIFECYCLE EVENT viewDidDetach!!");
        [((BrComArlsoftMessagesView*)view) viewDidDisappear:YES];
    }

    if (view != nil && !viewWillDetachFired) {
        //NSLog(@"[INFO] VIEWPROXY LIFECYCLE EVENT viewWillDetach!!");
        [((BrComArlsoftMessagesView*)view) viewWillDisappear:YES];
        viewWillDetachFired = YES;
    }
}

-(void)viewWillDetach
{
	// This method is called right after the view has detached from the proxy
	
	//NSLog(@"[INFO] VIEWPROXY LIFECYCLE EVENT viewWillDetach");

    if (view != nil && !viewWillDetachFired) {
        //NSLog(@"[INFO] VIEWPROXY LIFECYCLE EVENT viewWillDetach!!");
        [((BrComArlsoftMessagesView*)view) viewWillDisappear:YES];
        viewWillDetachFired = YES;
    }
}

#pragma Public APIs

-(void)finishSendingMessage:(id)args
{
    if (view != nil) {
        [((BrComArlsoftMessagesView*)view) finishSendingMessage];
    }
}

-(void)finishReceivingMessage:(id)args
{
    if (view != nil) {
        [((BrComArlsoftMessagesView*)view) finishReceivingMessage];
    }
}

-(void)scrollToBottomAnimated:(id)args
{
    ENSURE_SINGLE_ARG(args,NSNumber);

    if (view != nil) {
        [((BrComArlsoftMessagesView*)view) scrollToBottomAnimated:[TiUtils boolValue:args]];
    }
}

- (void)finishLoadEarlierMessages:(id)args
{
    //ENSURE_UI_THREAD_1_ARG(args);
    if (![NSThread isMainThread]) {
        TiThreadPerformOnMainThread(^{[self finishLoadEarlierMessages:args];}, NO);
        return;
    }
    
    ENSURE_SINGLE_ARG(args,NSNumber);

    if (view != nil) {
        [((BrComArlsoftMessagesView*)view) finishLoadEarlierMessages:[TiUtils intValue:args]];
    }
}

- (void)reloadAvatar:(id)args
{
    //ENSURE_UI_THREAD_1_ARG(args);
    if (![NSThread isMainThread]) {
        TiThreadPerformOnMainThread(^{[self reloadAvatar:args];}, NO);
        return;
    }
    
    ENSURE_SINGLE_ARG(args,NSString);
    
    if (view != nil) {
        [((BrComArlsoftMessagesView*)view) reloadAvatar:[TiUtils stringValue:args]];
    }
}

@end
