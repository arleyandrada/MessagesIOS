/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2014 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiViewProxy.h"
#import "TiViewController.h"

@interface BrComArlsoftMessagesViewProxy : TiViewProxy {

    KrollCallback *messageDataForIndex;
    KrollCallback *messageDataCount;

    KrollCallback *cellAvatarCustomization;
    KrollCallback *cellTimestampCustomization;
    KrollCallback *cellSenderNameCustomization;
    KrollCallback *cellBubbleCustomization;

    KrollCallback *attributedTextForCellTopLabelAtIndexPath;
    KrollCallback *attributedTextForMessageBubbleTopLabelAtIndexPath;
    KrollCallback *attributedTextForCellBottomLabelAtIndexPath;
    KrollCallback *heightForCellTopLabelAtIndexPath;
    KrollCallback *heightForMessageBubbleTopLabelAtIndexPath;
    KrollCallback *heightForCellBottomLabelAtIndexPath;

@private

}

@end