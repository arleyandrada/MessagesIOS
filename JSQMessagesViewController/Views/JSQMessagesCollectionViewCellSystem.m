//
//  Created by Jesse Squires
//  http://www.hexedbits.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQMessagesCollectionViewCellSystem.h"

@implementation JSQMessagesCollectionViewCellSystem

#pragma mark - Overrides

+ (UINib *)nib
{
    //ARLEY WAS HERE...
    NSString *className = NSStringFromClass([JSQMessagesCollectionViewCellSystem class]);
    NSString *path = [[[NSBundle mainBundle] resourcePath]
                      stringByAppendingPathComponent:@"modules/br.com.arlsoft.messages/"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    return [UINib nibWithNibName:className bundle:bundle];
    
    //return [UINib nibWithNibName:NSStringFromClass([JSQMessagesCollectionViewCellSystem class])
    //                      bundle:[NSBundle mainBundle]];
}

+ (NSString *)cellReuseIdentifier
{
    return NSStringFromClass([JSQMessagesCollectionViewCellSystem class]);
}

#pragma mark - Initialization

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.messageBubbleTopLabel.textAlignment = NSTextAlignmentLeft;
    self.cellBottomLabel.textAlignment = NSTextAlignmentLeft;
}

@end
