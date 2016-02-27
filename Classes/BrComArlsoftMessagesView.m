/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2014 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */

#import "BrComArlsoftMessagesView.h"

#define IS_OS_7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define ID NSStringFromClass([BrComArlsoftMessagesView class])

@implementation BrComArlsoftMessagesView

bool viewInitialized = NO;

+(void)myLog:(NSString*) format, ...
{
    va_list argList;
    va_start(argList, format);
    NSString* formattedMessage = [[NSString alloc] initWithFormat: format arguments: argList];
    va_end(argList);
    NSLog(@"[INFO] %@", formattedMessage);
}

-(void)dealloc
{
    //NSLog(@"[INFO] %@ dealloc", ID);
    
    viewInitialized = NO;
    
    [controller viewWillDisappear:YES];
    [controller viewDidDisappear:YES];

    controller.collectionView.delegate = nil;
    controller.collectionView.dataSource = nil;
    controller.delegateTextView = nil;
    controller.delegate = nil;
    view = nil;
    controller = nil;

	messageDataForIndex = nil;
	messageDataCount = nil;

    cellAvatarCustomization = nil;
    cellTimestampCustomization = nil;
    cellSenderNameCustomization = nil;
    cellBubbleCustomization = nil;
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    //NSLog(@"[INFO] %@ willMoveToSuperview", ID);
}

-(void)initializeState
{
	// This method is called right after allocating the view and
	// is useful for initializing anything specific to the view
	
	[super initializeState];
	
    //NSLog(@"[INFO] %@ initializeState", ID);
    
    [self viewDidLoad];

    messageDataForIndex = [self.proxy valueForKey:@"messageDataForIndex"];
    messageDataCount = [self.proxy valueForKey:@"messageDataCount"];
    
    cellAvatarCustomization = [self.proxy valueForKey:@"cellAvatarCustomization"];
    cellTimestampCustomization = [self.proxy valueForKey:@"cellTimestampCustomization"];
    cellSenderNameCustomization = [self.proxy valueForKey:@"cellSenderNameCustomization"];
    cellBubbleCustomization = [self.proxy valueForKey:@"cellBubbleCustomization"];

    self.sender = nil;
    self.loadingAvatar = @"...";
    self.unableToLoadAvatar = @"X";
    self.showOutgoingAvatar = YES;
    self.showIncomingAvatar = YES;
    self.showBubbles = YES;
    self.showSenderName = YES;
    self.showTimestamp = YES;
    self.playMessageSentSound = YES;
    self.playMessageReceivedSound = YES;
    self.showTypingIndicator = NO;
    self.showLoadEarlierMessagesHeader = NO;
    self.outgoingTextColor = [UIColor blackColor];
    self.incomingTextColor = [UIColor whiteColor];
    self.incomingTextAlignment = NSTextAlignmentLeft;
    self.outgoingTextAlignment = NSTextAlignmentLeft;
    self.bubbleKind = @"min";
    self.showSendButton = YES;
    self.showAccessoryButton = NO;
    self.sendButtonWidth = 50.0f;
    self.accessoryButtonWidth = 34.0f;
    self.accessoryButtonEnabled = YES;
    self.avatarSize = 0.0f;
    self.buttonNormalColor = [UIColor jsq_messageBubbleBlueColor];
    self.buttonHighlightedColor = [[UIColor jsq_messageBubbleBlueColor] jsq_colorByDarkeningColorWithValue:0.1f];
    self.buttonDisabledColor = [UIColor lightGrayColor];
    self.buttonWithSolidColor = YES;
    self.textAvatarBackgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
    self.textAvatarColor = [UIColor colorWithWhite:0.60f alpha:1.0f];
    self.textAvatarFont = [UIFont systemFontOfSize:14.0f];
    self.showInputBar = YES;
    self.inputBarDefaultHeight = 44.0f;
    self.timestampHeight = 20.0f;
    self.timestampColor = [UIColor lightGrayColor];
    self.timestampFont = [UIFont systemFontOfSize:12.0f];
    self.timestampPrefixFont = [UIFont boldSystemFontOfSize:12.0f];
    self.senderNameHeight = 20.0f;
    self.senderNameColor = [UIColor lightGrayColor];
    self.senderNameFont = [UIFont systemFontOfSize:12.0f];
    self.showSystemTimestamp = YES;
    self.showSystemBubbles = YES;
    self.systemBubbleKind = @"system";
    self.systemTextColor = [UIColor jsq_messageBubbleGreenColor];
    self.systemTextAlignment = NSTextAlignmentCenter;
}

-(void)configurationSet
{
	// This method is called right after all view properties have
	// been initialized from the view proxy. If the view is dependent
	// upon any properties being initialized then this is the method
	// to implement the dependent functionality.
	
	[super configurationSet];
	
    //NSLog(@"[INFO] %@ configurationSet", ID);
    
    if (self.sender == nil || [self.sender isEqualToString:@""]) {
        NSLog(@"[ERROR] Sender required.");
    }
    if (messageDataForIndex == nil) {
        NSLog(@"[ERROR] MessageDataForIndex delegate required.");
    }
    if (messageDataCount == nil) {
        NSLog(@"[ERROR] MessageDataCount delegate required.");
    }

    if (outgoingBubbleImageView == nil)
    {
        if (self.outgoingBubbleColor == nil)
        {
            self.outgoingBubbleColor = [UIColor jsq_messageBubbleLightGrayColor];
        }
        outgoingBubbleImageView = [JSQMessagesBubbleImageFactory
                                        outgoingMessageBubbleImageViewWithColor:self.outgoingBubbleColor
                                        kind:self.bubbleKind];
    }
    
    if (incomingBubbleImageView == nil)
    {
        if (self.incomingBubbleColor == nil)
        {
            self.incomingBubbleColor = [UIColor jsq_messageBubbleGreenColor];
        }
        incomingBubbleImageView = [JSQMessagesBubbleImageFactory
                                        incomingMessageBubbleImageViewWithColor:self.incomingBubbleColor
                                        kind:self.bubbleKind];
    }

    if (systemBubbleImageView == nil)
    {
        if (self.systemBubbleColor == nil)
        {
            self.systemBubbleColor = [UIColor jsq_messageBubbleLightGrayColor];
        }
        systemBubbleImageView = [JSQMessagesBubbleImageFactory
                                   systemMessageBubbleImageViewWithColor:self.systemBubbleColor
                                   kind:self.systemBubbleKind];
    }

    if (self.buttonNormalColor == nil) {
        self.buttonNormalColor = [UIColor jsq_messageBubbleBlueColor];
    }
    
    [JSQMessagesToolbarButtonFactory setNormalColor:self.buttonNormalColor];
    
    if (self.buttonHighlightedColor == nil) {
        self.buttonHighlightedColor = [[UIColor jsq_messageBubbleBlueColor] jsq_colorByDarkeningColorWithValue:0.1f];
    }
    
    [JSQMessagesToolbarButtonFactory setHighlightedColor:self.buttonHighlightedColor];
    
    if (self.buttonDisabledColor == nil) {
        self.buttonDisabledColor = [UIColor lightGrayColor];
    }
    
    [JSQMessagesToolbarButtonFactory setDisabledColor:self.buttonDisabledColor];
    
    [JSQMessagesToolbarButtonFactory setWithSolidColor:self.buttonWithSolidColor];
    
    if (self.customSendButton == nil) {
        controller.inputToolbar.contentView.rightBarButtonItem = [JSQMessagesToolbarButtonFactory defaultSendButtonItem];
    } else {
        UIButton* customBtn = [JSQMessagesToolbarButtonFactory imageButtonItem:self.customSendButton];
        if (customBtn == nil)
        {
            customBtn = [JSQMessagesToolbarButtonFactory textButtonItem:self.customSendButton];
        }
        controller.inputToolbar.contentView.rightBarButtonItem = customBtn;
    }
    
    if (self.customAccessoryButton == nil) {
        controller.inputToolbar.contentView.leftBarButtonItem = [JSQMessagesToolbarButtonFactory defaultAccessoryButtonItem];
    } else {
        UIButton* customBtn = [JSQMessagesToolbarButtonFactory imageButtonItem:self.customAccessoryButton];
        if (customBtn == nil)
        {
            customBtn = [JSQMessagesToolbarButtonFactory textButtonItem:self.customAccessoryButton];
        }
        controller.inputToolbar.contentView.leftBarButtonItem = customBtn;
    }
    
    controller.inputToolbar.contentView.rightBarButtonItemWidth = self.showSendButton ? self.sendButtonWidth : 0.0f;
    controller.inputToolbar.contentView.rightBarButtonVisible = self.showSendButton;
    
    controller.inputToolbar.contentView.leftBarButtonItemWidth = self.showAccessoryButton ? self.accessoryButtonWidth : 0.0f;
    controller.inputToolbar.contentView.leftBarButtonVisible = self.showAccessoryButton;

    [controller.inputToolbar toggleSendButtonEnabled];
    controller.inputToolbar.contentView.leftBarButtonEnabled = self.accessoryButtonEnabled;
    
    controller.inputToolbarDefaultHeight = self.inputBarDefaultHeight;
    [controller showInputToolbar:self.showInputBar isStartup:YES];
    
    [JSQMessagesTimestampFormatter setTextColor:self.timestampColor];
    [JSQMessagesTimestampFormatter setTextFont:self.timestampFont];
    [JSQMessagesTimestampFormatter setTextPrefixFont:self.timestampPrefixFont];

    [controller viewWillAppear:YES];
    [controller viewDidAppear:YES];
    [self addSubview:view];

    viewInitialized = YES;
}

-(UIView*)view
{
    //NSLog(@"[INFO] %@ view", ID);
    return view;
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
    [super frameSizeChanged:frame bounds:bounds];
    
	// You must implement this method for your view to be sized correctly.
	// This method is called each time the frame / bounds / center changes
	// within Titanium.
	
    //NSLog(@"[INFO] %@ frameSizeChanged", ID);
    
	if (view != nil) {
		
		// You must call the special method 'setView:positionRect' against
		// the TiUtils helper class. This method will correctly layout your
		// child view within the correct layout boundaries of the new bounds
		// of your view.
		
		[TiUtils setView:view positionRect:bounds];
        
        [controller.collectionView.collectionViewLayout receiveDeviceOrientation];
	}
}

#pragma Public APIs

- (void)setSender_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);

    //NSLog(@"[INFO] %@ setSender_", ID);
	
	if (controller != nil) {
        
        NSString *sender = [TiUtils stringValue:value];
        self.sender = sender;
        controller.sender = sender;
    }
}

- (void)setDefaultIncomingAvatar_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setDefaultIncomingAvatar_", ID);
	
    self.defaultIncomingAvatar = [TiUtils stringValue:value];
}

- (void)setDefaultOutgoingAvatar_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setDefaultOutgoingAvatar_", ID);
    
    self.defaultOutgoingAvatar = [TiUtils stringValue:value];
}

- (void)setLoadingAvatar_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setLoadingAvatar_", ID);
    
    self.loadingAvatar = [TiUtils stringValue:value];
}

- (void)setUnableToLoadAvatar_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setDefaultOutgoingAvatar_", ID);
    
    self.unableToLoadAvatar = [TiUtils stringValue:value];
}

- (void)setInputText_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);

    //NSLog(@"[INFO] %@ setInputText_", ID);
	
	if (controller != nil) {
        
        NSString *inputText = [TiUtils stringValue:value];
        controller.inputToolbar.contentView.textView.text = inputText;
    }
}

- (void)setOutgoingBubbleColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setOutgoingBubbleColor_", ID);
	
    self.outgoingBubbleColor = [[TiUtils colorValue:value] _color];
    
    if (self.outgoingBubbleColor == nil)
    {
        self.outgoingBubbleColor = [UIColor jsq_messageBubbleLightGrayColor];
    }
    outgoingBubbleImageView = [JSQMessagesBubbleImageFactory
                                    outgoingMessageBubbleImageViewWithColor:self.outgoingBubbleColor
                                    kind:self.bubbleKind];
}

- (void)setIncomingBubbleColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setIncomingBubbleColor_", ID);
	
    self.incomingBubbleColor = [[TiUtils colorValue:value] _color];
    
    if (self.incomingBubbleColor == nil)
    {
        self.incomingBubbleColor = [UIColor jsq_messageBubbleGreenColor];
    }
    incomingBubbleImageView = [JSQMessagesBubbleImageFactory
                                    incomingMessageBubbleImageViewWithColor:self.incomingBubbleColor
                                    kind:self.bubbleKind];
}

- (void)setShowOutgoingAvatar_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setShowOutgoingAvatar_", ID);
	
    self.showOutgoingAvatar = [TiUtils boolValue:value];
    
    if (self.showOutgoingAvatar) {
        controller.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(34.0f, 34.0f);
    } else {
        controller.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    }
}

- (void)setShowIncomingAvatar_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setShowIncomingAvatar_", ID);
	
    self.showIncomingAvatar = [TiUtils boolValue:value];

    if (self.showIncomingAvatar) {
        controller.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(34.0f, 34.0f);
    } else {
        controller.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    }
}

- (void)setShowBubbles_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setShowBubbles_", ID);
	
    self.showBubbles = [TiUtils boolValue:value];
}

- (void)setShowSenderName_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setShowSenderName_", ID);
	
    self.showSenderName = [TiUtils boolValue:value];
}

- (void)setShowTimestamp_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setShowTimestamp_", ID);
	
    self.showTimestamp = [TiUtils boolValue:value];
}

- (void)setPlayMessageSentSound_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setPlayMessageSentSound_", ID);
	
    self.playMessageSentSound = [TiUtils boolValue:value];
}

- (void)setPlayMessageReceivedSound_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setPlayMessageReceivedSound_", ID);
	
    self.playMessageReceivedSound = [TiUtils boolValue:value];
}

- (void)setShowTypingIndicator_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setShowTypingIndicator_", ID);
	
    self.showTypingIndicator = [TiUtils boolValue:value];

    if (controller != nil) {
        controller.showTypingIndicator = self.showTypingIndicator;
    }
}

- (void)setShowLoadEarlierMessagesHeader_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setShowLoadEarlierMessagesHeader_", ID);
	
    self.showLoadEarlierMessagesHeader = [TiUtils boolValue:value];
    
    if (controller != nil) {
        controller.showLoadEarlierMessagesHeader = self.showLoadEarlierMessagesHeader;
    }
}

- (void)setOutgoingTextColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setOutgoingTextColor_", ID);
	
    self.outgoingTextColor = [[TiUtils colorValue:value] _color];
    
    if (self.outgoingTextColor == nil)
    {
        self.outgoingTextColor = [UIColor blackColor];
    }
}

- (void)setIncomingTextColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setIncomingTextColor_", ID);
	
    self.incomingTextColor = [[TiUtils colorValue:value] _color];
    
    if (self.incomingTextColor == nil)
    {
        self.incomingTextColor = [UIColor whiteColor];
    }
}

- (void)setOutgoingTextAlignment_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setOutgoingTextAlignment_", ID);
    
    NSString* alignName = [TiUtils stringValue:value];
    if ([alignName isEqualToString:@"center"])
        self.outgoingTextAlignment = NSTextAlignmentCenter;
    else if ([alignName isEqualToString:@"right"])
        self.outgoingTextAlignment = NSTextAlignmentRight;
    else
        self.outgoingTextAlignment = NSTextAlignmentLeft;
}

- (void)setIncomingTextAlignment_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setIncomingTextAlignment_", ID);
    
    NSString* alignName = [TiUtils stringValue:value];
    if ([alignName isEqualToString:@"center"])
        self.incomingTextAlignment = NSTextAlignmentCenter;
    else if ([alignName isEqualToString:@"right"])
        self.incomingTextAlignment = NSTextAlignmentRight;
    else
        self.incomingTextAlignment = NSTextAlignmentLeft;
}

- (void)setBubbleFont_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSDictionary);
    
    self.bubbleFont = nil;

    WebFont* bubbleWebFont = [TiUtils fontValue:value];
    if (bubbleWebFont != nil) {
        self.bubbleFont = [bubbleWebFont font];
    }

    if (controller != nil)
    {
        if (self.bubbleFont != nil) {
            controller.collectionView.collectionViewLayout.messageBubbleFont = self.bubbleFont;
        }
    }
}

- (void)setBackgroundColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setBackgroundColor_", ID);
	
    self.backgroundColor = [[TiUtils colorValue:value] _color];
    
    if (self.backgroundColor == nil)
    {
        self.backgroundColor = [UIColor whiteColor];
    }

    if (controller != nil)
    {
        controller.collectionView.backgroundColor = self.backgroundColor;
    }
}

- (void)setBubbleKind_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setBubbleKind_", ID);
	
    NSString *bubbleKind = [TiUtils stringValue:value];
    self.bubbleKind = bubbleKind;

    if (self.outgoingBubbleColor == nil)
    {
        self.outgoingBubbleColor = [UIColor jsq_messageBubbleLightGrayColor];
    }
    outgoingBubbleImageView = [JSQMessagesBubbleImageFactory
                                    outgoingMessageBubbleImageViewWithColor:self.outgoingBubbleColor
                                    kind:self.bubbleKind];

    if (self.incomingBubbleColor == nil)
    {
        self.incomingBubbleColor = [UIColor jsq_messageBubbleGreenColor];
    }
    incomingBubbleImageView = [JSQMessagesBubbleImageFactory
                                    incomingMessageBubbleImageViewWithColor:self.incomingBubbleColor
                                    kind:self.bubbleKind];
}

- (void)setInputBarBackgroundColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setInputBarBackgroundColor_", ID);
	
    self.inputBarBackgroundColor = [[TiUtils colorValue:value] _color];
    
    if (self.inputBarBackgroundColor == nil)
    {
        self.inputBarBackgroundColor = [UIColor clearColor];
    }
    
    if (controller != nil){
        controller.inputToolbar.contentView.backgroundColor = self.inputBarBackgroundColor;
    }
}

- (void)setInputFieldBackgroundColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setInputFieldBackgroundColor_", ID);
	
    self.inputFieldBackgroundColor = [[TiUtils colorValue:value] _color];
    
    if (self.inputFieldBackgroundColor == nil)
    {
        self.inputFieldBackgroundColor = [UIColor whiteColor];
    }
    
    if (controller != nil){
        controller.inputToolbar.contentView.textView.backgroundColor = self.inputFieldBackgroundColor;
    }
}

- (void)setInputFieldBorderColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setInputFieldBorderColor_", ID);
	
    self.inputFieldBorderColor = [[TiUtils colorValue:value] _color];
    
    if (self.inputFieldBorderColor == nil)
    {
        self.inputFieldBorderColor = [UIColor lightGrayColor];
    }
    
    if (controller != nil){
        controller.inputToolbar.contentView.textView.layer.borderColor = self.inputFieldBorderColor.CGColor;
    }
}

- (void)setInputFieldTextColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setInputFieldTextColor_", ID);
	
    self.inputFieldTextColor = [[TiUtils colorValue:value] _color];
    
    if (self.inputFieldTextColor == nil)
    {
        self.inputFieldTextColor = [UIColor blackColor];
    }
    
    if (controller != nil){
        controller.inputToolbar.contentView.textView.textColor = self.inputFieldTextColor;
    }
}

- (void)setInputFieldFont_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSDictionary);
    
    self.inputFieldFont = nil;
    
    WebFont* inputFieldFont = [TiUtils fontValue:value];
    if (inputFieldFont != nil) {
        self.inputFieldFont = [inputFieldFont font];
    }

    if (self.inputFieldFont == nil)
    {
        self.inputFieldFont = [UIFont systemFontOfSize:16.0f];
    }
    
    if (controller != nil)
    {
        controller.inputToolbar.contentView.textView.font = self.inputFieldFont;
    }
}

- (void)setInputFieldPlaceHolderTextColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setInputFieldPlaceHolderTextColor_", ID);
	
    self.inputFieldPlaceHolderTextColor = [[TiUtils colorValue:value] _color];
    
    if (self.inputFieldPlaceHolderTextColor == nil)
    {
        self.inputFieldPlaceHolderTextColor = [UIColor blackColor];
    }
    
    if (controller != nil){
        controller.inputToolbar.contentView.textView.placeHolderTextColor = self.inputFieldPlaceHolderTextColor;
    }
}

- (void)setInputFieldPlaceHolderText_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setInputFieldPlaceHolderText_", ID);
    
    self.inputFieldPlaceHolderText = [TiUtils stringValue:value];
    
    if (controller != nil){
        controller.inputToolbar.contentView.textView.placeHolder = self.inputFieldPlaceHolderText;
    }
}

- (void)setCustomSendButton_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setCustomSendButton_ = %@", ID, value);
    
    self.customSendButton = [TiUtils stringValue:value];

    if (controller != nil) {
        if (self.customSendButton == nil) {
            controller.inputToolbar.contentView.rightBarButtonItem = [JSQMessagesToolbarButtonFactory defaultSendButtonItem];
        } else {
            UIButton* customBtn = [JSQMessagesToolbarButtonFactory imageButtonItem:self.customSendButton];
            if (customBtn == nil)
            {
                customBtn = [JSQMessagesToolbarButtonFactory textButtonItem:self.customSendButton];
            }
            controller.inputToolbar.contentView.rightBarButtonItem = customBtn;
        }
        
        controller.inputToolbar.contentView.rightBarButtonItemWidth = self.showSendButton ? self.sendButtonWidth : 0.0f;
        controller.inputToolbar.contentView.rightBarButtonVisible = self.showSendButton;
    }
}

- (void)setCustomAccessoryButton_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setCustomAccessoryButton_ = %@", ID, value);
    
    self.customAccessoryButton = [TiUtils stringValue:value];
    
    if (controller != nil) {
        if (self.customAccessoryButton == nil) {
            controller.inputToolbar.contentView.leftBarButtonItem = [JSQMessagesToolbarButtonFactory defaultAccessoryButtonItem];
        } else {
            UIButton* customBtn = [JSQMessagesToolbarButtonFactory imageButtonItem:self.customAccessoryButton];
            if (customBtn == nil)
            {
                customBtn = [JSQMessagesToolbarButtonFactory textButtonItem:self.customAccessoryButton];
            }
            controller.inputToolbar.contentView.leftBarButtonItem = customBtn;
        }
        
        controller.inputToolbar.contentView.leftBarButtonItemWidth = self.showAccessoryButton ? self.accessoryButtonWidth : 0.0f;
        controller.inputToolbar.contentView.leftBarButtonVisible = self.showAccessoryButton;
    }
}

- (void)setShowSendButton_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setShowSendButton_", ID);
    
    self.showSendButton = [TiUtils boolValue:value];

    if (controller != nil) {
        controller.inputToolbar.contentView.rightBarButtonItemWidth = self.showSendButton ? self.sendButtonWidth : 0.0f;
        controller.inputToolbar.contentView.rightBarButtonVisible = self.showSendButton;
    }
}

- (void)setShowAccessoryButton_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setShowAccessoryButton_", ID);
    
    self.showAccessoryButton = [TiUtils boolValue:value];
    
    if (controller != nil) {
        controller.inputToolbar.contentView.leftBarButtonItemWidth = self.showAccessoryButton ? self.accessoryButtonWidth : 0.0f;
        controller.inputToolbar.contentView.leftBarButtonVisible = self.showAccessoryButton;
    }
}

- (void)setSendButtonWidth_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setSendButtonWidth_", ID);
    
    self.sendButtonWidth = [TiUtils floatValue:value];
    
    if (controller != nil) {
        controller.inputToolbar.contentView.rightBarButtonItemWidth = self.showSendButton ? self.sendButtonWidth : 0.0f;
    }
}

- (void)setAccessoryButtonWidth_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setAccessoryButtonWidth_", ID);
    
    self.accessoryButtonWidth = [TiUtils floatValue:value];
    
    if (controller != nil) {
        controller.inputToolbar.contentView.leftBarButtonItemWidth = self.showAccessoryButton ? self.accessoryButtonWidth : 0.0f;
    }
}

- (void)setAccessoryButtonEnabled_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setAccessoryButtonEnabled_", ID);
    
    self.accessoryButtonEnabled = [TiUtils boolValue:value];
    
    if (controller != nil) {
        controller.inputToolbar.contentView.leftBarButtonEnabled = self.accessoryButtonEnabled;
    }
}

- (void)setAvatarSize_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setAvatarSize_", ID);
    
    self.avatarSize = [TiUtils floatValue:value];
}

- (void)setAvatarOverlay_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setAvatarOverlay_", ID);
    
    NSString* avatarOverlayFile = [TiUtils stringValue:value];
    
    NSString *path = [[[NSBundle mainBundle] resourcePath]
                      stringByAppendingPathComponent:@"modules/br.com.arlsoft.messages/"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    NSString *imageName = [bundle pathForResource:avatarOverlayFile ofType:@"png"];
    UIImage *avatarImage = (imageName == nil) ? nil : [[UIImage alloc] initWithContentsOfFile:imageName];
    
    if (imageName == nil || avatarImage == nil){
        imageName = [[NSBundle mainBundle] pathForResource:avatarOverlayFile ofType:@"png"];
        avatarImage = (imageName == nil) ? nil : [[UIImage alloc] initWithContentsOfFile:imageName];
    }
    
    if (imageName == nil || avatarImage == nil){
        self.avatarOverlay = nil;
    } else {
        self.avatarOverlay = avatarImage;
    }
}

- (void)setButtonNormalColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setButtonNormalColor_", ID);
    
    self.buttonNormalColor = [[TiUtils colorValue:value] _color];
}

- (void)setButtonHighlightedColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setButtonHighlightedColor_", ID);
    
    self.buttonHighlightedColor = [[TiUtils colorValue:value] _color];
}

- (void)setButtonDisabledColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setButtonDisabledColor_", ID);
    
    self.buttonDisabledColor = [[TiUtils colorValue:value] _color];
}

- (void)setButtonWithSolidColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setButtonWithSolidColor_", ID);
    
    self.buttonWithSolidColor = [TiUtils boolValue:value];
}

- (void)setTextAvatarBackgroundColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setTextAvatarBackgroundColor_", ID);
    
    self.textAvatarBackgroundColor = [[TiUtils colorValue:value] _color];
    
    if (self.textAvatarBackgroundColor == nil)
    {
        self.textAvatarBackgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
    }
}

- (void)setTextAvatarColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setTextAvatarColor_", ID);
    
    self.textAvatarColor = [[TiUtils colorValue:value] _color];
    
    if (self.textAvatarColor == nil)
    {
        self.textAvatarColor = [UIColor colorWithWhite:0.60f alpha:1.0f];
    }
}

- (void)setTextAvatarFont_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSDictionary);
    
    self.textAvatarFont = nil;
    
    WebFont* textAvatarFont = [TiUtils fontValue:value];
    if (textAvatarFont != nil) {
        self.textAvatarFont = [textAvatarFont font];
    }
    
    if (self.textAvatarFont == nil)
    {
        self.textAvatarFont = [UIFont systemFontOfSize:14.0f];
    }
}

- (void)setShowInputBar_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setShowInputBar_", ID);
    
    self.showInputBar = [TiUtils boolValue:value];
    
    if (controller != nil && viewInitialized) {
        [controller showInputToolbar:self.showInputBar isStartup:NO];
    }
}

- (void)setInputBarDefaultHeight_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setInputBarDefaultHeight_", ID);
    
    self.inputBarDefaultHeight = [TiUtils floatValue:value];
}

- (void)setTimestampHeight_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setTimestampHeight_", ID);
    
    self.timestampHeight = [TiUtils floatValue:value];
}

- (void)setTimestampColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setTimestampColor_", ID);
    
    self.timestampColor = [[TiUtils colorValue:value] _color];

    if (self.timestampColor == nil)
    {
        self.timestampColor = [UIColor lightGrayColor];
    }
}

- (void)setTimestampFont_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSDictionary);
    
    self.timestampFont = nil;
    
    WebFont* textTimestampFont = [TiUtils fontValue:value];
    if (textTimestampFont != nil) {
        self.timestampFont = [textTimestampFont font];
    }
    
    if (self.timestampFont == nil)
    {
        self.timestampFont = [UIFont systemFontOfSize:12.0f];
    }
}

- (void)setTimestampPrefixFont_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSDictionary);
    
    self.timestampPrefixFont = nil;
    
    WebFont* textTimestampPrefixFont = [TiUtils fontValue:value];
    if (textTimestampPrefixFont != nil) {
        self.timestampPrefixFont = [textTimestampPrefixFont font];
    }
    
    if (self.timestampPrefixFont == nil)
    {
        self.timestampPrefixFont = [UIFont boldSystemFontOfSize:12.0f];
    }
}

- (void)setSenderNameHeight_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setSenderNameHeight_", ID);
    
    self.senderNameHeight = [TiUtils floatValue:value];
}

- (void)setSenderNameColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setSenderNameColor_", ID);
    
    self.senderNameColor = [[TiUtils colorValue:value] _color];
    
    if (self.senderNameColor == nil)
    {
        self.senderNameColor = [UIColor lightGrayColor];
    }
}

- (void)setSenderNameFont_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSDictionary);
    
    self.senderNameFont = nil;
    
    WebFont* textSenderNameFont = [TiUtils fontValue:value];
    if (textSenderNameFont != nil) {
        self.senderNameFont = [textSenderNameFont font];
    }
    
    if (self.senderNameFont == nil)
    {
        self.senderNameFont = [UIFont systemFontOfSize:12.0f];
    }
}

- (void)setShowSystemTimestamp_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setShowSystemTimestamp_", ID);
    
    self.showSystemTimestamp = [TiUtils boolValue:value];
}

- (void)setShowSystemBubbles_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSNumber);
    
    //NSLog(@"[INFO] %@ setShowSystemBubbles_", ID);
    
    self.showSystemBubbles = [TiUtils boolValue:value];
}

- (void)setSystemBubbleKind_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setSystemBubbleKind_", ID);
    
    NSString *bubbleKind = [TiUtils stringValue:value];
    self.systemBubbleKind = bubbleKind;
    
    if (self.systemBubbleColor == nil)
    {
        self.systemBubbleColor = [UIColor jsq_messageBubbleBlueColor];
    }
    systemBubbleImageView = [JSQMessagesBubbleImageFactory
                               systemMessageBubbleImageViewWithColor:self.systemBubbleColor
                               kind:self.systemBubbleKind];
}

- (void)setSystemBubbleColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setSystemBubbleColor_", ID);
    
    self.systemBubbleColor = [[TiUtils colorValue:value] _color];
    
    if (self.systemBubbleColor == nil)
    {
        self.systemBubbleColor = [UIColor jsq_messageBubbleBlueColor];
    }
    systemBubbleImageView = [JSQMessagesBubbleImageFactory
                               systemMessageBubbleImageViewWithColor:self.systemBubbleColor
                               kind:self.systemBubbleKind];
}

- (void)setSystemTextColor_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setSystemTextColor_", ID);
    
    self.systemTextColor = [[TiUtils colorValue:value] _color];
    
    if (self.systemTextColor == nil)
    {
        self.systemTextColor = [UIColor jsq_messageBubbleGreenColor];
    }
}

- (void)setSystemTextAlignment_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSString);
    
    //NSLog(@"[INFO] %@ setSystemTextAlignment_", ID);
    
    NSString* alignName = [TiUtils stringValue:value];
    if ([alignName isEqualToString:@"center"])
        self.systemTextAlignment = NSTextAlignmentCenter;
    else if ([alignName isEqualToString:@"right"])
        self.systemTextAlignment = NSTextAlignmentRight;
    else
        self.systemTextAlignment = NSTextAlignmentLeft;
}

- (void)setSystemBubbleFont_:(id)value
{
    ENSURE_SINGLE_ARG(value,NSDictionary);
    
    self.systemBubbleFont = nil;
    
    WebFont* bubbleWebFont = [TiUtils fontValue:value];
    if (bubbleWebFont != nil) {
        self.systemBubbleFont = [bubbleWebFont font];
    }

    if (controller != nil)
    {
        if (self.systemBubbleFont != nil) {
            controller.collectionView.collectionViewLayout.systemMessageBubbleFont = self.systemBubbleFont;
        }
    }
}

- (void)finishSendingMessage
{
    if (controller != nil) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if (self.playMessageSentSound)
            {
                [JSQSystemSoundPlayer jsq_playMessageSentSound];
            }
            
            [self->controller finishSendingMessage];
        });
    }
}

- (void)finishReceivingMessage
{
    if (controller != nil) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if (self.playMessageReceivedSound)
            {
                [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
            }
            
            [self->controller finishReceivingMessage];
        });
    }
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    if (controller != nil) {
        [self->controller scrollToBottomAnimated:animated];
    }
}

- (void)finishLoadEarlierMessages:(NSInteger)index
{
    if (controller != nil) {
        [self->controller finishLoadEarlierMessages:index];
    }
}

- (void)reloadAvatar:(NSString*)avatar
{
    if (controller != nil) {
        [avatars removeObjectForKey:avatar];
        [controller.collectionView reloadData];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    if (!IS_OS_7_OR_LATER)
    {
        NSLog(@"[ERROR] iOS 7 or later required.");
    }
    else
    {
        if (controller == nil)
        {
            //NSLog(@"[INFO] viewDidLoad");
            viewInitialized = NO;

            controller = [[JSQMessagesViewController alloc] init];

            [controller viewDidLoad];
            
            view = controller.view;
            controller.delegate = self;
            controller.delegateTextView = self;
            controller.collectionView.dataSource = self;
            controller.collectionView.delegate = self;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    //if (controller) [controller viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    //if (controller) [controller viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //if (controller) [controller viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    //if (controller) [controller viewDidDisappear:animated];
}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)getMessageAtIndex:(long)idx
{
    if (messageDataForIndex == nil) return nil;

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:idx],@"index",nil];
    id result = [messageDataForIndex call:[NSArray arrayWithObjects: dict, nil] thisObject:nil];

    if (result == nil) return nil;
    
    id textId = [result objectForKey:@"message"];
    NSString *text = (textId == nil) ? @"" : [TiUtils stringValue:textId];
    if (text == nil) return nil;
    
    id senderId = [result objectForKey:@"sender"];
    
    //ENABLE OR DISABLE SYSTEM MESSAGES WITH OR WITHOUT USE OF DEFAULT SENDER
    NSString *sender = (senderId == nil) ? self.sender : [TiUtils stringValue:senderId];
    if (sender == nil) sender = self.sender;
    if (sender == nil) return nil;
    //NSString *sender = [TiUtils stringValue:senderId];
    
    NSString* defaultAvatar = nil;
    if ([sender isEqualToString:self.sender]) {
        defaultAvatar = self.defaultOutgoingAvatar;
    } else {
        defaultAvatar = self.defaultIncomingAvatar;
    }
    
    id avatarId = [result objectForKey:@"avatar"];
    NSString *avatar = (avatarId == nil) ? defaultAvatar : [TiUtils stringValue:avatarId];
    
    NSDate* date = nil;
    id dateId = [result objectForKey:@"date"];
    if (dateId != nil)
    {
        NSString *dateStr = [TiUtils stringValue:dateId];
        if (dateStr != nil){
            date = [TiUtils dateForUTCDate:dateStr];
        }
    }
    
    return [[JSQMessage alloc] initWithText:text sender:sender avatar:avatar date:date];
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getMessageAtIndex:indexPath.item];
}

- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView bubbleImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     */
    
    /**
     *  Reuse created bubble images, but create new imageView to add to each cell
     *  Otherwise, each cell would be referencing the same imageView and bubbles would disappear from cells
     */
    
    id<JSQMessageData> message = [self getMessageAtIndex:indexPath.item];
    if (message == nil) return nil;
    
    BOOL isSystemMessage = message.sender == nil || [message.sender isEqualToString:@""];
    BOOL isOutgoingMessage = [message.sender isEqualToString:self.sender];
    
    if (isSystemMessage) {
        if (!self.showSystemBubbles) return nil;
        return [[UIImageView alloc] initWithImage:systemBubbleImageView.image
                                 highlightedImage:systemBubbleImageView.highlightedImage];
    }
    
    if (!self.showBubbles) return nil;
    
    if (isOutgoingMessage) {
        return [[UIImageView alloc] initWithImage:outgoingBubbleImageView.image
                                 highlightedImage:outgoingBubbleImageView.highlightedImage];
    }
    
    return [[UIImageView alloc] initWithImage:incomingBubbleImageView.image
                             highlightedImage:incomingBubbleImageView.highlightedImage];
}

- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Reuse created avatar images, but create new imageView to add to each cell
     *  Otherwise, each cell would be referencing the same imageView and avatars would disappear from cells
     *
     *  Note: these images will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    
    id<JSQMessageData> message = [self getMessageAtIndex:indexPath.item];
    if (message == nil) return nil;
    
    BOOL isSystemMessage = message.sender == nil || [message.sender isEqualToString:@""];
    BOOL isOutgoingMessage = [message.sender isEqualToString:self.sender];
    
    if (isSystemMessage) return nil;
    
    BOOL cellShowOutgoingAvatar = self.showOutgoingAvatar;
    BOOL cellShowIncomingAvatar = self.showIncomingAvatar;
    
    id customResult = nil;
    if (cellAvatarCustomization != nil) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:indexPath.item],@"index",nil];
        customResult = [cellAvatarCustomization call:[NSArray arrayWithObjects: dict, nil] thisObject:nil];
        if (customResult != nil && customResult != [NSNull null]) {
            if (isOutgoingMessage) {
                if ([[customResult allKeys] containsObject:@"showAvatar"]) {
                    cellShowOutgoingAvatar = [TiUtils boolValue:@"showAvatar" properties:customResult def:YES];
                }
            } else {
                if ([[customResult allKeys] containsObject:@"showAvatar"]) {
                    cellShowIncomingAvatar = [TiUtils boolValue:@"showAvatar" properties:customResult def:YES];
                }
            }
        };
    };

    if (isOutgoingMessage && !cellShowOutgoingAvatar) return nil;
    if (!isOutgoingMessage && !cellShowIncomingAvatar) return nil;
    
    /**
     *  Create avatar images once.
     *
     *  Be sure to create your avatars one time and reuse them for good performance.
     *
     *  If you are not using avatars, ignore this.
     */
    if (avatars == nil) avatars = [[NSMutableDictionary alloc]init];
    
    UIImage *avatarImage = [avatars objectForKey:message.avatar];
    if (avatarImage != nil) {
        return [[UIImageView alloc] initWithImage:avatarImage];
    }

    CGFloat cellAvatarSize = self.avatarSize;
    UIImage* cellAvatarOverlay = self.avatarOverlay;
    UIColor* cellTextAvatarBackgroundColor = self.textAvatarBackgroundColor;
    UIColor* cellTextAvatarColor = self.textAvatarColor;
    UIFont* cellTextAvatarFont = self.textAvatarFont;
    
    if (customResult != nil && customResult != [NSNull null]) {
        if ([[customResult allKeys] containsObject:@"avatarSize"]) {
            cellAvatarSize = [TiUtils floatValue:@"avatarSize" properties:customResult def:0.0f];
        }
        if ([[customResult allKeys] containsObject:@"avatarOverlay"]) {
            NSString* avatarOverlayFile = [TiUtils stringValue:@"avatarOverlay" properties:customResult];
            
            NSString *path = [[[NSBundle mainBundle] resourcePath]
                              stringByAppendingPathComponent:@"modules/br.com.arlsoft.messages/"];
            NSBundle *bundle = [NSBundle bundleWithPath:path];
            NSString *imageName = [bundle pathForResource:avatarOverlayFile ofType:@"png"];
            UIImage *avatarImage = (imageName == nil) ? nil : [[UIImage alloc] initWithContentsOfFile:imageName];
            
            if (imageName == nil || avatarImage == nil){
                imageName = [[NSBundle mainBundle] pathForResource:avatarOverlayFile ofType:@"png"];
                avatarImage = (imageName == nil) ? nil : [[UIImage alloc] initWithContentsOfFile:imageName];
            }
            
            if (imageName == nil || avatarImage == nil){
                cellAvatarOverlay = nil;
            } else {
                cellAvatarOverlay = avatarImage;
            }
        }
        if ([[customResult allKeys] containsObject:@"textAvatarBackgroundColor"]) {
            cellTextAvatarBackgroundColor = [[TiUtils colorValue:@"textAvatarBackgroundColor" properties:customResult] _color];
        }
        if ([[customResult allKeys] containsObject:@"textAvatarColor"]) {
            cellTextAvatarColor = [[TiUtils colorValue:@"textAvatarColor" properties:customResult] _color];
        }
        if ([[customResult allKeys] containsObject:@"textAvatarFont"]) {
            id dictTextAvatarFont = customResult[@"textAvatarFont"];
            if (dictTextAvatarFont != nil) {
                WebFont* textAvatarFont = [TiUtils fontValue:dictTextAvatarFont];
                if (textAvatarFont != nil) {
                    cellTextAvatarFont = [textAvatarFont font];
                }
            }
        }
    };

    CGFloat avatarSize = controller.collectionView.collectionViewLayout.incomingAvatarViewSize.width;
    if (isOutgoingMessage) {
        avatarSize = controller.collectionView.collectionViewLayout.outgoingAvatarViewSize.width;
    }
    if (cellAvatarSize > 0)
        avatarSize = cellAvatarSize;
    
    if (emptyAvatar == nil) {
        emptyAvatar = [UIImage imageNamed:self.loadingAvatar];
        if (emptyAvatar == nil) {
            emptyAvatar = [JSQMessagesAvatarFactory avatarWithUserInitials:self.loadingAvatar
                                                           backgroundColor:cellTextAvatarBackgroundColor
                                                                 textColor:cellTextAvatarColor
                                                                      font:cellTextAvatarFont
                                                                  diameter:avatarSize
                                                                customMask:cellAvatarOverlay];
        }
    }
    
    if (notFoundAvatar == nil) {
        notFoundAvatar = [UIImage imageNamed:self.unableToLoadAvatar];
        if (notFoundAvatar == nil) {
            notFoundAvatar = [JSQMessagesAvatarFactory avatarWithUserInitials:self.unableToLoadAvatar
                                                              backgroundColor:cellTextAvatarBackgroundColor
                                                                    textColor:cellTextAvatarColor
                                                                         font:cellTextAvatarFont
                                                                     diameter:avatarSize
                                                                   customMask:cellAvatarOverlay];
        }
    }
    
    UIImage *imageAvatar = [UIImage imageNamed:message.avatar];
    if (imageAvatar == nil) {
        if ([message.avatar hasPrefix:@"http"]) {
            [self loadAvatarFromURLAsync:message.avatar avatarSize:avatarSize retryCounter:10 avatarOverlay:cellAvatarOverlay];
            [avatars setObject:emptyAvatar forKey:message.avatar];
            
            return [[UIImageView alloc] initWithImage:emptyAvatar];
        }
    }
    
    if (imageAvatar == nil)
    {
        avatarImage = [JSQMessagesAvatarFactory avatarWithUserInitials:message.avatar
                                                       backgroundColor:cellTextAvatarBackgroundColor
                                                             textColor:cellTextAvatarColor
                                                                  font:cellTextAvatarFont
                                                              diameter:avatarSize
                                                            customMask:cellAvatarOverlay];
    }
    else
    {
        avatarImage = [JSQMessagesAvatarFactory avatarWithImage:imageAvatar
                                                       diameter:avatarSize
                                                     customMask:cellAvatarOverlay];
    }

    return [[UIImageView alloc] initWithImage:avatarImage];
}

- (void)loadAvatarFromURLAsync:(NSString *)avatarURL avatarSize:(CGFloat)avatarSize retryCounter:(int)retryCounter avatarOverlay:(UIImage*)avatarOverlay
{
    if (retryCounter == 0) {
        NSLog(@"[WARN] Unable to load avatar image from : %@", avatarURL);
        
        [avatars setObject:notFoundAvatar forKey:avatarURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            [controller.collectionView reloadData];
        });
        return;
    }
    retryCounter--;
    
    __weak __typeof(self)weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL successLoad = NO;
        @try {
            UIImage *imageAvatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:avatarURL]]];
            if (imageAvatar != nil) {
                UIImage *avatarImage = [JSQMessagesAvatarFactory avatarWithImage:imageAvatar
                                                                        diameter:avatarSize
                                                                     customMask:avatarOverlay];
                if (avatarImage != nil) {
                    [avatars setObject:avatarImage forKey:avatarURL];
                    successLoad = YES;
                }
            }
        }
        @catch (NSException *exception) {
            successLoad = NO;
        }
        if (successLoad) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [controller.collectionView reloadData];
            });
        } else {
            [NSThread sleepForTimeInterval:2.0];
            [weakSelf loadAvatarFromURLAsync:avatarURL avatarSize:avatarSize retryCounter:retryCounter avatarOverlay:avatarOverlay];
        }
    });
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     */
    
    BOOL cellShowTimestamp = self.showTimestamp;
    BOOL customCellShowTimestamp = NO;
    
    UIColor* cellTimestampColor = self.timestampColor;
    UIFont* cellTimestampFont = self.timestampFont;
    UIFont* cellTimestampPrefixFont = self.timestampPrefixFont;
    
    NSString* cellRelativeDate = nil;
    NSString* cellTime = nil;

    NSDictionary* cellDateTextAttributes = [JSQMessagesTimestampFormatter sharedFormatter].dateTextAttributes;
    NSDictionary* cellTimeTextAttributes = [JSQMessagesTimestampFormatter sharedFormatter].timeTextAttributes;

    id customResult = nil;
    if (cellTimestampCustomization != nil) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:indexPath.item],@"index",nil];
        customResult = [cellTimestampCustomization call:[NSArray arrayWithObjects: dict, nil] thisObject:nil];
        if (customResult != nil && customResult != [NSNull null]) {
            if ([[customResult allKeys] containsObject:@"showTimestamp"]) {
                cellShowTimestamp = [TiUtils boolValue:@"showTimestamp" properties:customResult def:YES];
                customCellShowTimestamp = YES;
            }
            
            if ([[customResult allKeys] containsObject:@"timestampColor"] || [[customResult allKeys] containsObject:@"timestampFont"] || [[customResult allKeys] containsObject:@"timestampPrefixFont"]) {
                
                if ([[customResult allKeys] containsObject:@"timestampColor"]) {
                    cellTimestampColor = [[TiUtils colorValue:@"timestampColor" properties:customResult] _color];
                }
                if ([[customResult allKeys] containsObject:@"timestampFont"]) {
                    id dictFont = customResult[@"timestampFont"];
                    if (dictFont != nil) {
                        WebFont* textFont = [TiUtils fontValue:dictFont];
                        if (textFont != nil) {
                            cellTimestampFont = [textFont font];
                        }
                    }
                }
                if ([[customResult allKeys] containsObject:@"timestampPrefixFont"]) {
                    id dictFont = customResult[@"timestampPrefixFont"];
                    if (dictFont != nil) {
                        WebFont* textFont = [TiUtils fontValue:dictFont];
                        if (textFont != nil) {
                            cellTimestampPrefixFont = [textFont font];
                        }
                    }
                }
                
                NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                paragraphStyle.alignment = NSTextAlignmentCenter;
                
                cellDateTextAttributes = @{ NSFontAttributeName : cellTimestampPrefixFont,
                                            NSForegroundColorAttributeName : cellTimestampColor,
                                            NSParagraphStyleAttributeName : paragraphStyle };
                
                cellTimeTextAttributes = @{ NSFontAttributeName : cellTimestampFont,
                                            NSForegroundColorAttributeName : cellTimestampColor,
                                            NSParagraphStyleAttributeName : paragraphStyle };
            }

            if ([[customResult allKeys] containsObject:@"timestampContent"]) {
                cellTime = [TiUtils stringValue:@"timestampContent" properties:customResult];
            }
            if ([[customResult allKeys] containsObject:@"timestampPrefixContent"]) {
                cellRelativeDate = [TiUtils stringValue:@"timestampPrefixContent" properties:customResult];
            }
        };
    };
    
    if (customCellShowTimestamp && !cellShowTimestamp) return nil;
    
    NSString* senderName = nil;

    if (cellTime == nil || cellRelativeDate == nil) {
        id<JSQMessageData> message = [self getMessageAtIndex:indexPath.item];
        if (message == nil) return nil;
        senderName = message.sender;
        if (message.date == nil) return nil;
        if (cellRelativeDate == nil) {
            cellRelativeDate = [[JSQMessagesTimestampFormatter sharedFormatter] relativeDateForDate:message.date];
        }
        if (cellTime == nil) {
            cellTime = [[JSQMessagesTimestampFormatter sharedFormatter] timeForDate:message.date];
        }
    }
    
    if (!customCellShowTimestamp) {
        BOOL isSystemMessage = senderName == nil || [senderName isEqualToString:@""];
        BOOL isOutgoingMessage = [senderName isEqualToString:self.sender];

        cellShowTimestamp = isSystemMessage ? self.showSystemTimestamp : self.showTimestamp;
    }
    
    if (!cellShowTimestamp) return nil;
    
    NSMutableAttributedString *timestamp = nil;
    
    if (cellRelativeDate == nil || [cellRelativeDate isEqualToString:@""]) {
        timestamp = [[NSMutableAttributedString alloc] initWithString:cellTime attributes:cellTimeTextAttributes];
    } else {
        timestamp = [[NSMutableAttributedString alloc] initWithString:cellRelativeDate attributes:cellDateTextAttributes];
        if (cellTime != nil && ![cellTime isEqualToString:@""]) {
            [timestamp appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
            [timestamp appendAttributedString:[[NSAttributedString alloc] initWithString:cellTime attributes:cellTimeTextAttributes]];
        }
    }
    
    return [[NSAttributedString alloc] initWithAttributedString:timestamp];
    
    //return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL cellShowSenderName = self.showSenderName;
    BOOL customCellShowSenderName = NO;
    UIColor* cellSenderNameColor = self.senderNameColor;
    UIFont* cellSenderNameFont = self.senderNameFont;
    NSString* cellSenderNameContent = nil;
    
    if (cellSenderNameCustomization != nil) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:indexPath.item],@"index",nil];
        id customResult = [cellSenderNameCustomization call:[NSArray arrayWithObjects: dict, nil] thisObject:nil];
        if (customResult != nil && customResult != [NSNull null]) {
            if ([[customResult allKeys] containsObject:@"showSenderName"]) {
                cellShowSenderName = [TiUtils boolValue:@"showSenderName" properties:customResult def:YES];
                customCellShowSenderName = YES;
            }
            if ([[customResult allKeys] containsObject:@"senderNameColor"]) {
                cellSenderNameColor = [[TiUtils colorValue:@"senderNameColor" properties:customResult] _color];
            }
            if ([[customResult allKeys] containsObject:@"senderNameFont"]) {
                id dictFont = customResult[@"senderNameFont"];
                if (dictFont != nil) {
                    WebFont* textFont = [TiUtils fontValue:dictFont];
                    if (textFont != nil) {
                        cellSenderNameFont = [textFont font];
                    }
                }
            }
            if ([[customResult allKeys] containsObject:@"senderNameContent"]) {
                cellSenderNameContent = [TiUtils stringValue:@"senderNameContent" properties:customResult];
            }
        };
    };
    
    if (customCellShowSenderName && !cellShowSenderName) return nil;

    if (cellSenderNameContent == nil) {
        id<JSQMessageData> message = [self getMessageAtIndex:indexPath.item];
        if (message == nil) return nil;
        
        BOOL isSystemMessage = message.sender == nil || [message.sender isEqualToString:@""];
        BOOL isOutgoingMessage = [message.sender isEqualToString:self.sender];

        if (isSystemMessage) {
            return nil;
        }

        if (isOutgoingMessage) {
            return nil;
        }
        
        if (indexPath.item - 1 > 0) {
            
            id<JSQMessageData> previousMessage = [self getMessageAtIndex:indexPath.item - 1];
            if (previousMessage == nil) return nil;
            
            if ([[previousMessage sender] isEqualToString:message.sender]) {
                return nil;
            }
        }
        cellSenderNameContent = message.sender;
    }

    if (!cellShowSenderName) return nil;

    /**
     *  Don't specify attributes to use the defaults.
     */
    
    if (cellSenderNameContent == nil) return nil;

    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary* cellTextAttributes = @{ NSFontAttributeName : cellSenderNameFont,
                                NSForegroundColorAttributeName : cellSenderNameColor,
                                NSParagraphStyleAttributeName : paragraphStyle };
    NSMutableAttributedString *cellText = [[NSMutableAttributedString alloc] initWithString:cellSenderNameContent attributes:cellTextAttributes];
    return [[NSAttributedString alloc] initWithAttributedString:cellText];

    //return [[NSAttributedString alloc] initWithString:message.sender];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (messageDataCount == nil)
    {
        return 0;
    }
    
    id result = [messageDataCount call:nil thisObject:nil];
    NSParameterAssert(result != nil);
    int count = [TiUtils intValue:result];
    return count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    //JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[controller collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    id<JSQMessageData> messageData = [collectionView.dataSource collectionView:collectionView messageDataForItemAtIndexPath:indexPath];
    NSParameterAssert(messageData != nil);
    
    NSString *messageSender = [messageData sender];
    //NSParameterAssert(messageSender != nil);
    
    BOOL isSystemMessage = messageSender == nil || [messageSender isEqualToString:@""];
    BOOL isOutgoingMessage = [messageSender isEqualToString:self.sender];
    
    //NSString *cellIdentifier = isOutgoingMessage ? controller.outgoingCellIdentifier : controller.incomingCellIdentifier;
    NSString *cellIdentifier = isSystemMessage ? controller.systemCellIdentifier : isOutgoingMessage ? controller.outgoingCellIdentifier : controller.incomingCellIdentifier;
    
    JSQMessagesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = collectionView;
    
    NSString *messageText = [messageData text];
    NSParameterAssert(messageText != nil);
    
    cell.textView.text = messageText;
    cell.messageBubbleImageView = [collectionView.dataSource collectionView:collectionView bubbleImageViewForItemAtIndexPath:indexPath];
    cell.avatarImageView = [collectionView.dataSource collectionView:collectionView avatarImageViewForItemAtIndexPath:indexPath];
    cell.cellTopLabel.attributedText = [collectionView.dataSource collectionView:collectionView attributedTextForCellTopLabelAtIndexPath:indexPath];
    cell.messageBubbleTopLabel.attributedText = [collectionView.dataSource collectionView:collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:indexPath];
    cell.cellBottomLabel.attributedText = [collectionView.dataSource collectionView:collectionView attributedTextForCellBottomLabelAtIndexPath:indexPath];

    if (isOutgoingMessage) {
        cell.avatarImageView.bounds = CGRectMake(CGRectGetMinX(cell.avatarImageView.bounds),
                                                 CGRectGetMinY(cell.avatarImageView.bounds),
                                                 collectionView.collectionViewLayout.outgoingAvatarViewSize.width,
                                                 collectionView.collectionViewLayout.outgoingAvatarViewSize.height);
    }
    else {
        cell.avatarImageView.bounds = CGRectMake(CGRectGetMinX(cell.avatarImageView.bounds),
                                                 CGRectGetMinY(cell.avatarImageView.bounds),
                                                 collectionView.collectionViewLayout.incomingAvatarViewSize.width,
                                                 collectionView.collectionViewLayout.incomingAvatarViewSize.height);
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    CGFloat bubbleTopLabelInset = 60.0f;
    
    if (isSystemMessage) {
        cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsZero;
    }
    else if (isOutgoingMessage) {
        cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, bubbleTopLabelInset);
    }
    else {
        cell.messageBubbleTopLabel.textInsets = UIEdgeInsetsMake(0.0f, bubbleTopLabelInset, 0.0f, 0.0f);
    }
    
    cell.textView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */

    if (isSystemMessage) {
        cell.textView.font = self.systemBubbleFont != nil ? self.systemBubbleFont : collectionView.collectionViewLayout.systemMessageBubbleFont;
        cell.textView.textColor = [self systemTextColor];
        cell.textView.textAlignment = [self systemTextAlignment];
    }
    else {
        cell.textView.font = self.bubbleFont != nil ? self.bubbleFont : collectionView.collectionViewLayout.messageBubbleFont;
        if (isOutgoingMessage) {
            cell.textView.textColor = [self outgoingTextColor];
            cell.textView.textAlignment = [self outgoingTextAlignment];
        }
        else {
            cell.textView.textColor = [self incomingTextColor];
            cell.textView.textAlignment = [self incomingTextAlignment];
        }
    }
    
    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    
    if (cellBubbleCustomization != nil) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:indexPath.item],@"index",nil];
        id customResult = [cellBubbleCustomization call:[NSArray arrayWithObjects: dict, nil] thisObject:nil];
        if (customResult != nil && customResult != [NSNull null]) {

            NSString* alignName = nil;
            NSString* cellBubbleKind = nil;
            UIColor* cellBubbleColor = nil;
            UIImageView* cellBubbleImageView = nil;

            if ([[customResult allKeys] containsObject:@"bubbleKind"]) {
                cellBubbleKind = [TiUtils stringValue:@"bubbleKind" properties:customResult];
            }
            if ([[customResult allKeys] containsObject:@"bubbleFont"]) {
                id dictTextAvatarFont = customResult[@"bubbleFont"];
                if (dictTextAvatarFont != nil) {
                    WebFont* textAvatarFont = [TiUtils fontValue:dictTextAvatarFont];
                    if (textAvatarFont != nil) {
                        cell.textView.font = [textAvatarFont font];
                    }
                }
            }

            if ([[customResult allKeys] containsObject:@"bubbleColor"]) {
                cellBubbleColor = [[TiUtils colorValue:@"bubbleColor" properties:customResult] _color];
            }
            if ([[customResult allKeys] containsObject:@"textAlignment"]) {
                alignName = [TiUtils stringValue:@"textAlignment" properties:customResult];
            }
            if ([[customResult allKeys] containsObject:@"textColor"]) {
                cell.textView.textColor = [[TiUtils colorValue:@"textColor" properties:customResult] _color];
            }

            if (isOutgoingMessage) {
                cellBubbleImageView = outgoingBubbleImageView;
            } else {
                cellBubbleImageView = incomingBubbleImageView;
            }
            
            BOOL customBubbleImageView = NO;
            if (cellBubbleKind != nil || cellBubbleColor != nil) {
                if (cellBubbleKind == nil) cellBubbleKind = (isSystemMessage) ? self.systemBubbleKind : self.bubbleKind;
                if (cellBubbleColor == nil) {
                    if (isSystemMessage) {
                        cellBubbleColor = [UIColor jsq_messageBubbleLightGrayColor];
                    } else if (isOutgoingMessage) {
                        cellBubbleColor = [UIColor jsq_messageBubbleLightGrayColor];
                    } else {
                        cellBubbleColor = [UIColor jsq_messageBubbleGreenColor];
                    }
                }
                if (isSystemMessage) {
                    cellBubbleImageView = [JSQMessagesBubbleImageFactory
                                           systemMessageBubbleImageViewWithColor:cellBubbleColor
                                           kind:cellBubbleKind];
                } else if (isOutgoingMessage) {
                    cellBubbleImageView = [JSQMessagesBubbleImageFactory
                                           outgoingMessageBubbleImageViewWithColor:cellBubbleColor
                                           kind:cellBubbleKind];
                } else {
                    cellBubbleImageView = [JSQMessagesBubbleImageFactory
                                           incomingMessageBubbleImageViewWithColor:cellBubbleColor
                                           kind:cellBubbleKind];
                }
                customBubbleImageView = YES;
            }

            if ([[customResult allKeys] containsObject:@"showBubbles"]) {
                if ([TiUtils boolValue:@"showBubbles" properties:customResult def:YES]) {
                    if (customBubbleImageView) {
                        cell.messageBubbleImageView = cellBubbleImageView;
                    } else {
                        if (cell.messageBubbleImageView == nil) {
                            UIImageView* bubbleImageView = nil;
                            if (isSystemMessage) {
                                bubbleImageView = [[UIImageView alloc] initWithImage:systemBubbleImageView.image
                                                                    highlightedImage:systemBubbleImageView.highlightedImage];
                            }
                            else if (isOutgoingMessage) {
                                bubbleImageView = [[UIImageView alloc] initWithImage:outgoingBubbleImageView.image
                                                                                 highlightedImage:outgoingBubbleImageView.highlightedImage];
                            } else {
                                bubbleImageView = [[UIImageView alloc] initWithImage:incomingBubbleImageView.image
                                                                    highlightedImage:incomingBubbleImageView.highlightedImage];
                            }
                            cell.messageBubbleImageView = bubbleImageView;
                        }
                    }
                } else {
                    cell.messageBubbleImageView = nil;
                }
            } else {
                if (cell.messageBubbleImageView != nil && customBubbleImageView) {
                    cell.messageBubbleImageView = cellBubbleImageView;
                }
            }

            if (alignName != nil)
            {
                if ([alignName isEqualToString:@"center"]) {
                    cell.textView.textAlignment = NSTextAlignmentCenter;
                }
                else if ([alignName isEqualToString:@"right"])
                    cell.textView.textAlignment = NSTextAlignmentRight;
                else
                    cell.textView.textAlignment = NSTextAlignmentLeft;
            }
        };
    };
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(JSQMessagesCollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if (self.showTypingIndicator && [kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return [collectionView dequeueTypingIndicatorFooterViewIncoming:YES
                                                     withIndicatorColor:[controller.typingIndicatorColor jsq_colorByDarkeningColorWithValue:0.3f]
                                                            bubbleColor:controller.typingIndicatorColor
                                                           forIndexPath:indexPath];
    }
    else if (self.showLoadEarlierMessagesHeader && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [collectionView dequeueLoadEarlierMessagesViewHeaderForIndexPath:indexPath];
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (!self.showTypingIndicator) {
        return CGSizeZero;
    }
    
    return CGSizeMake([collectionViewLayout itemWidth], kJSQMessagesTypingIndicatorFooterViewHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (!self.showLoadEarlierMessagesHeader) {
        return CGSizeZero;//Make([collectionViewLayout itemWidth], 1);
    }
    
    return CGSizeMake([collectionViewLayout itemWidth], kJSQMessagesLoadEarlierHeaderViewHeight);
}

#pragma mark - Collection view delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    controller.selectedIndexPathForMenu = indexPath;
    
    //  textviews are selectable to allow data detectors
    //  however, this allows the 'copy, define, select' UIMenuController to show
    //  which conflicts with the collection view's UIMenuController
    //  temporarily disable 'selectable' to prevent this issue
    JSQMessagesCollectionViewCell *selectedCell = (JSQMessagesCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    selectedCell.textView.selectable = NO;
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)) {
        return YES;
    }
    
    return NO;
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)) {
        id<JSQMessageData> messageData = [controller collectionView:collectionView messageDataForItemAtIndexPath:indexPath];
        [[UIPasteboard generalPasteboard] setString:[messageData text]];
    }
}

#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGSize)collectionView:(JSQMessagesCollectionView *)collectionView
                  layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<JSQMessageData> messageData = [collectionView.dataSource collectionView:collectionView messageDataForItemAtIndexPath:indexPath];

    NSString *messageSender = [messageData sender];
    BOOL isSystemMessage = messageSender == nil || [messageSender isEqualToString:@""];
    BOOL isOutgoingMessage = [messageSender isEqualToString:self.sender];

    UIFont* bubbleFont = nil;
    if (isSystemMessage) {
        bubbleFont = self.systemBubbleFont != nil ? self.systemBubbleFont : collectionViewLayout.systemMessageBubbleFont;
    } else {
        bubbleFont = self.bubbleFont != nil ? self.bubbleFont : collectionViewLayout.messageBubbleFont;
    }
    
    id customResult = nil;
    if (cellBubbleCustomization != nil) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:indexPath.item],@"index",nil];
        customResult = [cellBubbleCustomization call:[NSArray arrayWithObjects: dict, nil] thisObject:nil];
        if (customResult != nil && customResult != [NSNull null]) {
            if ([[customResult allKeys] containsObject:@"bubbleFont"]) {
                id dictFont = customResult[@"bubbleFont"];
                if (dictFont != nil) {
                    WebFont* textFont = [TiUtils fontValue:dictFont];
                    if (textFont != nil) {
                        bubbleFont = [textFont font];
                    }
                }
            }
        };
    };

    CGSize bubbleSize = [collectionViewLayout messageBubbleSizeForItemAtIndexPath:indexPath messageBubbleFont:bubbleFont text:[messageData text]];
    CGFloat bubbleHeight = bubbleSize.height;

    CGFloat heightCellTop = [self collectionView:collectionView layout:collectionViewLayout heightForCellTopLabelAtIndexPath:indexPath];
    CGFloat heightMessage = [self collectionView:collectionView layout:collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:indexPath];
    CGFloat heightCellBottom = [self collectionView:collectionView layout:collectionViewLayout heightForCellBottomLabelAtIndexPath:indexPath];
    
    CGFloat cellHeight = bubbleHeight;
    cellHeight += heightCellTop;
    cellHeight += heightMessage;
    cellHeight += heightCellBottom;
    
    return CGSizeMake(collectionViewLayout.itemWidth, cellHeight);
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     */
    
    BOOL cellShowTimestamp = self.showTimestamp;
    BOOL customCellShowTimestamp = NO;
    CGFloat cellTopLabelHeight = self.timestampHeight;
    NSString* cellTime = nil;
    NSString* cellRelativeDate = nil;
    
    if (cellTimestampCustomization != nil) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:indexPath.item],@"index",nil];
        id customResult = [cellTimestampCustomization call:[NSArray arrayWithObjects: dict, nil] thisObject:nil];
        if (customResult != nil && customResult != [NSNull null]) {
            if ([[customResult allKeys] containsObject:@"showTimestamp"]) {
                cellShowTimestamp = [TiUtils boolValue:@"showTimestamp" properties:customResult def:YES];
                customCellShowTimestamp = YES;
            }
            if ([[customResult allKeys] containsObject:@"timestampHeight"]) {
                cellTopLabelHeight = [TiUtils floatValue:@"timestampHeight" properties:customResult];
            }
            if ([[customResult allKeys] containsObject:@"timestampContent"]) {
                cellTime = [TiUtils stringValue:@"timestampContent" properties:customResult];
            }
            if ([[customResult allKeys] containsObject:@"timestampPrefixContent"]) {
                cellRelativeDate = [TiUtils stringValue:@"timestampPrefixContent" properties:customResult];
            }
        };
    };
    
    if (customCellShowTimestamp && !cellShowTimestamp) return 0.0f;

    NSString* senderName = nil;
    
    if (cellTime == nil || cellRelativeDate == nil) {
        id<JSQMessageData> message = [self getMessageAtIndex:indexPath.item];
        if (message == nil) return 0.0f;
        senderName = message.sender;
        if (message.date == nil) return 0.0f;
    }

    if (!customCellShowTimestamp) {
        BOOL isSystemMessage = senderName == nil || [senderName isEqualToString:@""];
        BOOL isOutgoingMessage = [senderName isEqualToString:self.sender];

        cellShowTimestamp = isSystemMessage ? self.showSystemTimestamp : self.showTimestamp;
    }
    
    if (!cellShowTimestamp) return 0.0f;

    return cellTopLabelHeight;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    BOOL cellShowSenderName = self.showSenderName;
    BOOL customCellShowSenderName = NO;
    CGFloat cellSenderNameHeight = self.senderNameHeight;
    NSString* cellSenderNameContent = nil;
    
    if (cellSenderNameCustomization != nil) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:indexPath.item],@"index",nil];
        id customResult = [cellSenderNameCustomization call:[NSArray arrayWithObjects: dict, nil] thisObject:nil];
        if (customResult != nil && customResult != [NSNull null]) {
            if ([[customResult allKeys] containsObject:@"showSenderName"]) {
                cellShowSenderName = [TiUtils boolValue:@"showSenderName" properties:customResult def:YES];
                customCellShowSenderName = YES;
            }
            if ([[customResult allKeys] containsObject:@"senderNameHeight"]) {
                cellSenderNameHeight = [TiUtils floatValue:@"senderNameHeight" properties:customResult];
            }
            if ([[customResult allKeys] containsObject:@"senderNameContent"]) {
                cellSenderNameContent = [TiUtils stringValue:@"senderNameContent" properties:customResult];
            }
        };
    };

    if (customCellShowSenderName && !cellShowSenderName) return 0.0f;

    if (cellSenderNameContent == nil) {
        id<JSQMessageData> currentMessage = [self getMessageAtIndex:indexPath.item];
        if (currentMessage == nil) return 0.0f;

        BOOL isSystemMessage = currentMessage.sender == nil || [currentMessage.sender isEqualToString:@""];
        BOOL isOutgoingMessage = [currentMessage.sender isEqualToString:self.sender];

        if (isSystemMessage) {
            return 0.0f;
        }

        if (isOutgoingMessage) {
            return 0.0f;
        }
        
        if (indexPath.item - 1 > 0) {
            id<JSQMessageData> previousMessage = [self getMessageAtIndex:indexPath.item - 1];
            if (previousMessage == nil) return 0.0f;
            
            if ([[previousMessage sender] isEqualToString:[currentMessage sender]]) {
                return 0.0f;
            }
        }
    }

    if (!cellShowSenderName) return 0.0f;

    return cellSenderNameHeight;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
	if ([self.proxy _hasListeners:@"tappedAvatar"]) {
        BOOL loadedAvatar = !(avatarImageView == nil || avatarImageView.image == nil || avatarImageView.image == emptyAvatar || avatarImageView.image == notFoundAvatar);
        BOOL loadingAvatar = avatarImageView != nil && avatarImageView.image != nil && avatarImageView.image == emptyAvatar;
        
        NSMutableDictionary *event = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:indexPath.item],@"index",nil];
        [event setObject:[NSNumber numberWithInt:loadedAvatar] forKey:@"loaded"];
        [event setObject:[NSNumber numberWithInt:loadingAvatar] forKey:@"loading"];

		[self.proxy fireEvent:@"tappedAvatar" withObject:event];
	}
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    if( [controller.inputToolbar.contentView.textView isFirstResponder] )
    {
        [controller.inputToolbar.contentView.textView resignFirstResponder];
    }
    
	if ([self.proxy _hasListeners:@"tappedBubble"]) {
        NSMutableDictionary *event = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:indexPath.item],@"index",nil];

		[self.proxy fireEvent:@"tappedBubble" withObject:event];
	}
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    if( [controller.inputToolbar.contentView.textView isFirstResponder] )
    {
        [controller.inputToolbar.contentView.textView resignFirstResponder];
    }
    
	if ([self.proxy _hasListeners:@"tappedCell"]) {
        NSMutableDictionary *event = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:indexPath.item],@"index",nil];
        
		[self.proxy fireEvent:@"tappedCell" withObject:event];
	}
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
	if ([self.proxy _hasListeners:@"tappedLoadEarlier"]) {
		[self.proxy fireEvent:@"tappedLoadEarlier" withObject:nil];
	}
}

#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	if ([self.proxy _hasListeners:@"textBeginEditing"]) {
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:textView.text,@"message",nil];
		[self.proxy fireEvent:@"textBeginEditing" withObject:event];
	}
}

- (void)textViewDidChange:(UITextView *)textView
{
	if ([self.proxy _hasListeners:@"textDidChange"]) {
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:textView.text,@"message",nil];
		[self.proxy fireEvent:@"textDidChange" withObject:event];
	}
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	if ([self.proxy _hasListeners:@"textEndEditing"]) {
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:textView.text,@"message",nil];
		[self.proxy fireEvent:@"textEndEditing" withObject:event];
	}
}

#pragma mark - Input toolbar buttons

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                    sender:(NSString *)sender
                      date:(NSDate *)date
{
	if ([self.proxy _hasListeners:@"sendPressed"]) {
        NSMutableDictionary *event = [NSMutableDictionary dictionaryWithObjectsAndKeys:text,@"message",nil];
        [event setObject:sender forKey:@"sender"];
        [event setObject:date forKey:@"date"];
        
		[self.proxy fireEvent:@"sendPressed" withObject:event];
	}
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    /**
     *  Accessory button has no default functionality, yet.
     */

	if ([self.proxy _hasListeners:@"accessoryPressed"]) {
		[self.proxy fireEvent:@"accessoryPressed" withObject:nil];
	}
}

@end