//
//  I18nManager.m
//  AMSDK-iOS_Example
//
//  Created by aimo on 2025/4/17.
//  Copyright © 2025 pengbi. All rights reserved.
//

#import "I18nManager.h"



@implementation I18nManager

+ (void)load {
    [self setDefaultLanguage];
}

+ (void)setDefaultLanguage {
    NSString *i18nKey  = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    if (!i18nKey ) {
        [[NSUserDefaults standardUserDefaults] setObject:@[@"language"] forKey:@"en"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)switchLanguage{
    NSString *currentLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
    NSString *newLang;
    if ([currentLang isEqualToString:@"zh-Hans"] || [currentLang isEqualToString:@"zh"]) {
        newLang = @"en";
    } else {
        newLang = @"zh-Hans";
    }

    [[NSUserDefaults standardUserDefaults] setObject:newLang forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)stringWithKey:(NSString *)key {
    NSString *i18nKey  = [[NSUserDefaults standardUserDefaults] objectForKey:@"language"];
     NSString *path = [[NSBundle mainBundle] pathForResource:i18nKey ofType:@"lproj"];
    return [[NSBundle bundleWithPath:path] localizedStringForKey:key value:nil table:@"Localizable"];
}

@end
