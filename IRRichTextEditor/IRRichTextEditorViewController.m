//
//  IRRichTextEditorViewController.m
//  IRRichTextEditor
//
//  Created by Evadne Wu on 4/6/12.
//  Copyright (c) 2012 Iridia Productions. All rights reserved.
//

#import <objc/runtime.h>
#import "IRRichTextEditorViewController.h"
#import "IRRichTextEditorView.h"
#import "IRRichTextEditorDocumentView.h"


@interface IRRichTextEditorViewController ()

@property (nonatomic, readwrite, strong) id keyboardFrameChangeHandler;
- (void) handleKeyboardWillChangeFrame:(NSNotification *)note;

@end


@implementation IRRichTextEditorViewController
@dynamic view;
@synthesize keyboardFrameChangeHandler = _keyboardFrameChangeHandler;

- (void) loadView {

	if (self.nibName) {
		
		[super loadView];
		
	} else {
		
		self.view = [[IRRichTextEditorView alloc] initWithFrame:CGRectZero];
		
	}
	
	[self keyboardFrameChangeHandler];
	
}

- (void) setView:(UIView *)view {

	[super setView:view];

	if (!view) {
		
		[[NSNotificationCenter defaultCenter] removeObserver:_keyboardFrameChangeHandler];
		_keyboardFrameChangeHandler = nil;
		
	}

}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	
}

- (void) dealloc {

	if ([self isViewLoaded]) {
		
		[[NSNotificationCenter defaultCenter] removeObserver:_keyboardFrameChangeHandler];
		_keyboardFrameChangeHandler = nil;
		
	}
	
}

- (id) keyboardFrameChangeHandler {

	if (!_keyboardFrameChangeHandler) {

		__weak IRRichTextEditorViewController * const wSelf = self;
		
		_keyboardFrameChangeHandler = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
			
			[wSelf handleKeyboardWillChangeFrame:note];
			
		}];
	
	}
	
	return _keyboardFrameChangeHandler;
	
}

- (void) handleKeyboardWillChangeFrame:(NSNotification *)note {

	NSCParameterAssert([self isViewLoaded]);
	
	NSDictionary *userInfo = [note userInfo];
	CGRect fromRect = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
	CGRect toRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
	
	CGRect fromKeyboardRectInBounds = [self.view convertRect:fromRect fromView:nil];
	CGRect toKeyboardRectInBounds = [self.view convertRect:toRect fromView:nil];
	
	CGRect (^maxRectBySubtractingRect)(CGRect, CGRect) = ^ (CGRect r1, CGRect r2) {
	
		CGRect answer = CGRectZero;
		
		CGFloat (^amount)(CGRectEdge) = ^ (CGRectEdge edge) {
			switch (edge) {
				case CGRectMinXEdge:
					return MAX(0, (CGRectGetMaxX(r2) - CGRectGetMinX(r1)));
				case CGRectMinYEdge:
					return MAX(0, (CGRectGetMaxY(r2) - CGRectGetMinY(r1)));
				case CGRectMaxXEdge:
					return MAX(0, (CGRectGetMaxX(r1) - CGRectGetMinX(r2)));
				case CGRectMaxYEdge:
					return MAX(0, (CGRectGetMaxY(r1) - CGRectGetMinY(r2)));
			}
		};
		
		for (CGRectEdge edge = CGRectMinXEdge; edge <= CGRectMaxYEdge; edge++) {
			
			CGRect slice = CGRectNull, remainder = CGRectNull;
			CGFloat sliceAmount = amount(edge);
			
			CGRectDivide(r1, &slice, &remainder, sliceAmount, edge);
			
			if ((CGRectGetWidth(remainder) * CGRectGetHeight(remainder)) > (CGRectGetWidth(answer) * CGRectGetHeight(answer)))
				answer = remainder;
			
		}
		
		return answer;

	};
	
	CGRect fromBounds = maxRectBySubtractingRect(self.view.bounds, fromKeyboardRectInBounds);
	CGRect toBounds = maxRectBySubtractingRect(self.view.bounds, toKeyboardRectInBounds);
	
	UIViewAnimationOptions curveOption = ((UIViewAnimationOptions[]){
		[UIViewAnimationCurveEaseIn] = UIViewAnimationOptionCurveEaseIn,
		[UIViewAnimationCurveEaseOut] = UIViewAnimationOptionCurveEaseOut,
		[UIViewAnimationCurveEaseInOut] = UIViewAnimationOptionCurveEaseInOut,
		[UIViewAnimationCurveLinear] = UIViewAnimationOptionCurveLinear
	})[animationCurve];
	
	IRRichTextEditorDocumentView * const dv = self.view.documentView;
	
	dv.frame = fromBounds;

	[UIView animateWithDuration:duration delay:0.0f options:curveOption animations:^{
	
		dv.frame = toBounds;
		
	} completion:nil];

}

@end
