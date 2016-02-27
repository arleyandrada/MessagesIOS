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

#import "JSQMessage.h"

@implementation JSQMessage

#pragma mark - Initialization

+ (instancetype)messageWithText:(NSString *)text sender:(NSString *)sender avatar:(NSString *)avatar
{
    return [[JSQMessage alloc] initWithText:text sender:sender avatar:avatar date:[NSDate date]];
}

- (instancetype)initWithText:(NSString *)text
                      sender:(NSString *)sender
                      avatar:(NSString *)avatar
                        date:(NSDate *)date
{
    NSParameterAssert(text != nil);
    //NSParameterAssert(sender != nil);
    
    self = [self init];
    if (self) {
        _text = text;
        _sender = sender;
        _avatar = avatar;
        _date = date;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _text = @"";
        _sender = @"";
        _date = [NSDate date];
    }
    return self;
}

- (void)dealloc
{
    _text = nil;
    _sender = nil;
    _avatar = nil;
    _date = nil;
}

#pragma mark - JSQMessage

- (BOOL)isEqualToMessage:(JSQMessage *)aMessage
{
    return [self.text isEqualToString:aMessage.text]
            && [self.sender isEqualToString:aMessage.sender]
            && ((self.avatar == nil && aMessage.avatar == nil)
                || (self.avatar != nil && aMessage.avatar != nil && [self.avatar isEqualToString:aMessage.avatar]))
            && ([self.date compare:aMessage.date] == NSOrderedSame);
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self isEqualToMessage:(JSQMessage *)object];
}

- (NSUInteger)hash
{
    if (self.avatar == nil)
    {
        return [self.text hash] ^ [self.sender hash] ^ [self.date hash];
    }
    else
    {
        return [self.text hash] ^ [self.sender hash] ^ [self.avatar hash] ^ [self.date hash];
    }
}

- (NSString *)description
{
    if (self.avatar == nil)
    {
        return [NSString stringWithFormat:@"<%@>[ %@, %@, %@ ]", [self class], self.sender, self.date, self.text];
    }
    else
    {
        return [NSString stringWithFormat:@"<%@>[ %@, %@, %@, %@ ]", [self class], self.sender, self.avatar, self.date, self.text];
    }
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _text = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(text))];
        _sender = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(sender))];
        _avatar = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(avatar))];
        _date = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(date))];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:NSStringFromSelector(@selector(text))];
    [aCoder encodeObject:self.sender forKey:NSStringFromSelector(@selector(sender))];
    [aCoder encodeObject:self.avatar forKey:NSStringFromSelector(@selector(avatar))];
    [aCoder encodeObject:self.date forKey:NSStringFromSelector(@selector(date))];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithText:[self.text copy]
                                                    sender:[self.sender copy]
                                                    avatar:[self.sender copy]
                                                      date:[self.date copy]];
}

@end
