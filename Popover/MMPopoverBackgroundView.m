//
//  MMPopoverBackgroundView.m
//  Popover
//
//  Created by user12 on 01.07.14.
//  Copyright (c) 2014 Level UP. All rights reserved.
//

#import "MMPopoverBackgroundView.h"

@interface MMPopoverBackgroundView ()

@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, readwrite) UIPopoverArrowDirection arrowDirection;
@property (nonatomic, readwrite) CGFloat arrowOffset;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end//ihiuguygjhb

@implementation MMPopoverBackgroundView

@synthesize arrowDirection, arrowOffset;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

// основание стрелки (arrow base)
+ (CGFloat)arrowBase {
    // возвращаем ширину изображения
    return [UIImage imageNamed:@"strelka4.png"].size.width;
}

// высота стрелки (arrow height)
+ (CGFloat)arrowHeight {
    // возвращаем высоту изображения
    return [UIImage imageNamed:@"strelka4.png"].size.height;
}

+ (UIEdgeInsets)contentViewInsets {
    // отступы от краев контента до краев фона
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

// инициализация
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    // создаем image view для стрелки
    self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"strelka4.png"]];
    [self addSubview:_arrowImageView];
    
    UIEdgeInsets bgCapInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    UIImage *bgImage = [[UIImage imageNamed:@"008krasnii.jpg"] resizableImageWithCapInsets:bgCapInsets];
//    self.backgroundImageView = [[UIImageView alloc] initWithImage:bgImage];
//    [self addSubview:self.backgroundImageView];
//    
//    self.backgroundImageView.layer.cornerRadius = 100.0f;
//    self.backgroundImageView.layer.masksToBounds = YES;
    
    return self;
}

#pragma mark - Subviews Layout
// расположение элементов, вызывается в ответ на setNeedsLayout и другие события
- (void)layoutSubviews {
    // выбираем правильные размер и позицию для стрелки и фона
    
    // фон
    CGRect bgRect = self.bounds;
    // используем направление стрелки, чтобы знать с какой стороны нужно "урезать" фон
    // сначала, вычтем высоту/ширину стрелки, если это необходимо
    BOOL cutWidth = (self.arrowDirection == UIPopoverArrowDirectionLeft || self.arrowDirection == UIPopoverArrowDirectionRight);
    // если стрелка слева или справа, вычитаем ее высоту из ширины фона
    bgRect.size.width -= cutWidth * [self.class arrowHeight];
    BOOL cutHeight = (self.arrowDirection == UIPopoverArrowDirectionUp || self.arrowDirection == UIPopoverArrowDirectionDown);
    // если стрелка сверху или снизу, вычитаем ее высоту из высоты фона
    bgRect.size.height -= cutHeight * [self.class arrowHeight];
    
    // далее, подправим координаты origin point (левый верхний угол)
    // для случаев когда стрелка вверху (опускаем вниз) или слева (сдвигаем вправо)
    if (self.arrowDirection == UIPopoverArrowDirectionUp) {
        bgRect.origin.y += [self.class arrowHeight];
    } else if (self.arrowDirection == UIPopoverArrowDirectionLeft) {
        bgRect.origin.x += [self.class arrowHeight];
    }
    
    // применим новые размер и позицию к фону
    self.backgroundImageView.frame = bgRect;
    
    // стрелка - используем ее направление (arrowDirection) и смещение (arrowOffset) для окончательного раположения
    // в силу того, что мы используем однин image view для отрисовки всех направлений стрелки
    // мы будет использовать афинные преобразования (трансформации или transformations), а именно отражение и поворот
    // важно: рассчитывать размеры и позицию стрелки нужно после применения преобразований
    CGRect arrowRect = CGRectZero;
    UIEdgeInsets bgCapInsets = UIEdgeInsetsMake(12, 12, 12, 12);	// отступы использованные для фонового изображения
    switch (self.arrowDirection) {
        case UIPopoverArrowDirectionUp:
            _arrowImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
            //_arrowImageView.transform = CGAffineTransformMakeScale(1, 1);   // отменим какие-либо преобразования
            // важно: используем frame, а не bounds, потому что bounds не изменяется после трасформаций
            arrowRect = _arrowImageView.frame;
            // используем смещение для вычисления origin
            arrowRect.origin.x = self.bounds.size.width / 2 + self.arrowOffset - arrowRect.size.width / 2;
            arrowRect.origin.y = arrowRect.size.height;
            break;
        case UIPopoverArrowDirectionDown:
            _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI_2); // поворот на 90 градусов против часовой стрелки
            //_arrowImageView.transform = CGAffineTransformMakeScale(1, -1);  // отразим по вертикали (переворот)
            arrowRect = _arrowImageView.frame;
            // используем смещение для вычисления origin
            arrowRect.origin.x = self.bounds.size.width / 2 + self.arrowOffset - arrowRect.size.width / 2;
            arrowRect.origin.y = self.bounds.size.height - arrowRect.size.height * 2;
            break;
        case UIPopoverArrowDirectionLeft:
            //_arrowImageView.transform = CGAffineTransformMakeRotation(-M_PI_2); // поворот на 90 градусов против часовой стрелки
            _arrowImageView.transform = CGAffineTransformMakeScale(-1, 1);
            arrowRect = _arrowImageView.frame;
            // используем смещение для вычисления origin
            arrowRect.origin.x = arrowRect.size.width;
            arrowRect.origin.y = self.bounds.size.height / 2 + self.arrowOffset - arrowRect.size.height / 2;
            // последняя проверка - убедимся что стрелка не осталась под поповером
            // такое случается когда на экране появляется клавиатура, при этом уменьшая размеры поповера
            // дополнительно, учитываем нижний отступ bgCapInsets.bottom, чтобы все стыковалось как следует
            // со скругленными углами
            arrowRect.origin.y = fminf(self.bounds.size.height - arrowRect.size.height - bgCapInsets.bottom, arrowRect.origin.y);
            // похожая корректировка на случай если стрелка вылезла слишком высоко вверх
            arrowRect.origin.y = fmaxf(bgCapInsets.top, arrowRect.origin.y);
            break;
        case UIPopoverArrowDirectionRight:
            //_arrowImageView.transform = CGAffineTransformMakeRotation(M_PI_2);  // поворот на 90 градусов по часовой стрелке
            _arrowImageView.transform = CGAffineTransformMakeScale(1, -1);
            arrowRect = _arrowImageView.frame;
            arrowRect.origin.x = self.bounds.size.width - arrowRect.size.width * 2;
            arrowRect.origin.y = self.bounds.size.height / 2 + self.arrowOffset - arrowRect.size.height / 2;
            // по аналогии со случаем UIPopoverArrowDirectionLeft
            arrowRect.origin.y = fminf(self.bounds.size.height - arrowRect.size.height  - bgCapInsets.bottom, arrowRect.origin.y);
            arrowRect.origin.y = fmaxf(bgCapInsets.top, arrowRect.origin.y);
            break;
            
        default:
            break;
    }
    
    // задаем стрелке новые позицию и размер
    _arrowImageView.frame = arrowRect;
}
@end
