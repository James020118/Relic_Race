//
//  Circle.swift
//  Maze-Snake
//
//  Created by Patrick Biel on 2019-08-07.
//  Copyright © 2019 YBMW. All rights reserved.
//

import Foundation
import SpriteKit

// based on the math here:
// http://math.stackexchange.com/a/1367732

// x1,y1 is the center of the first circle, with radius r1
// x2,y2 is the center of the second ricle, with radius r2
func intersectTwoCircles(c1: Circle, c2: Circle) -> [CGPoint] {
    let centerdx = c1.x - c2.x;
    let centerdy = c1.y - c2.y;
    let R = sqrt(centerdx * centerdx + centerdy * centerdy)
    if (!(abs(c1.r - c2.r) <= R && R <= c1.r + c2.r)) { // no intersection
        return []; // empty list of results
    }
    // intersection(s) should exist
    
    let R2 = R*R;
    let R4 = R2*R2;
    let a = (c1.r * c1.r - c2.r * c2.r) / (2 * R2);
    let r2r2 = (c1.r * c1.r - c2.r * c2.r);
    let c = sqrt(2 * (c1.r * c1.r + c2.r * c2.r) / R2 - (r2r2 * r2r2) / R4 - 1);
    
    let fx = (c1.x + c2.x) / 2 + a * (c2.x - c1.x);
    let gx = c * (c2.y - c1.y) / 2;
    let ix1 = fx + gx;
    let ix2 = fx - gx;
    
    let fy = (c1.y + c2.y) / 2 + a * (c2.y - c1.y);
    let gy = c * (c1.x - c2.x) / 2;
    let iy1 = fy + gy;
    let iy2 = fy - gy;
    
    // note if gy == 0 and gx == 0 then the circles are tangent and there is only one solution
    if gy == 0 && gx == 0 {
        return [CGPoint(x: ix1, y: iy1)]
    }
    
    return [CGPoint(x: ix1, y: iy1), CGPoint(x: ix2, y: iy2)];
}

struct Circle {
    let x: CGFloat
    let y: CGFloat
    let r: CGFloat
}
