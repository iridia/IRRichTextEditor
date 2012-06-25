//
//  IRRichTextEditorView.m
//  IRRichTextEditor
//
//  Created by Evadne Wu on 4/6/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import "IRRichTextEditorView.h"
#import <objc/runtime.h>

@interface IRRichTextEditorView ()

- (void) commonInit;

@end


@implementation IRRichTextEditorView {
	
	@package
	BOOL _hasLoadedContent;
	BOOL _hasSwizzledInputAccessoryView;
	
}

- (void) didMoveToSuperview {

	[super didMoveToSuperview];
	[self commonInit];

}

- (void) commonInit {

	if (_hasLoadedContent)
		return;
	
	_hasLoadedContent = YES;
	
	self.backgroundColor = [UIColor whiteColor];
	self.scalesPageToFit = NO;
	
	for (UIView *aSV in self.scrollView.subviews)
		if ([aSV isKindOfClass:[UIImageView class]])
			aSV.hidden = YES;
	
	#if TARGET_IPHONE_SIMULATOR

		//	Enables local remote inspector if running on the Simulator.
		//	Note: seems broken on OS X 12A154q
		//	Note: WebSockets draft implementation changed, latest Chrome won’t work, get older ones
			
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			[NSClassFromString(@"WebView") performSelector:@selector(_enableRemoteInspector)];
		});
		
	#endif
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"IRRichTextEditor" ofType:@"html" inDirectory:@"IRRichTextEditor.bundle"];
	NSParameterAssert(path);
	
	NSURL *url = [NSURL fileURLWithPath:path];
	NSParameterAssert(url);

	[self loadRequest:[NSURLRequest requestWithURL:url]];

}

- (void) layoutSubviews {

	[super layoutSubviews];
	
	static NSString * uniqueSuffix;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		uniqueSuffix = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, CFUUIDCreate(NULL));
	});

	for (UIView *aView in self.scrollView.subviews) {
	
		Class ownClass = [aView class];
		NSString *className = NSStringFromClass(ownClass);
	
		if (![className hasSuffix:uniqueSuffix]) {
			
			NSString *newClassName = [className stringByAppendingString:uniqueSuffix];
			Class newClass = objc_allocateClassPair(ownClass, [newClassName UTF8String], 0);
			IMP nilImp = [self methodForSelector:@selector(methodReturningNil)];
			class_addMethod(newClass, @selector(inputAccessoryView), nilImp, "@@:");
			if (newClass) {
				objc_registerClassPair(newClass);
				object_setClass(aView, newClass);
			}
		
		}
	
	}

}

- (id) methodReturningNil {

	return nil;

}

- (NSString *) htmlString {

	//	TBD

	return nil;

}

- (void) setHtmlString:(NSString *)htmlString {

	[self commonInit];
	
	//	TBD

}

@end
