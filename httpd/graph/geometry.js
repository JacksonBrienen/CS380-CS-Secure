/**
 * Classes and functions for geometric shapes, their manipulations
 */

'use strict';

class Ellipse {

    /**
     * @param {Vector} center
     * @param {number} hrad
     * @param {number} vrad
     */
    constructor(center, hrad, vrad) {
        this.center = center;
        this.hrad = hrad;
        this.vrad = vrad;
    }

    /**
     * @param {CanvasRenderingContext2D} ctx
     */
    path(ctx) {
        ctx.ellipse(this.center.x, this.center.y,
                    this.hrad, this.vrad,
             0, 0, 2 * Math.PI);
    }

    containsVector(v) {
        return (((v.x-this.center.x) ** 2) / (this.hrad ** 2)) + (((v.y-this.center.y) ** 2) / (this.vrad ** 2)) <= 1;
    }

}

class Line {
    /**
     * @param {Vector} start
     * @param {Vector} end
     */
    constructor(start, end) {
        this.start = start;
        this.end = end;
    }
}

/**
 * 2d Vector based around the origin (0,0)
 */
class Vector {
    /**
     * @param {number} x
     * @param {number} y
     */
    constructor(x, y) {
        this.x = x;
        this.y = y;
    }

    normalize() {
        const mag = this.magnitude();
        return new Vector(this.x / mag, this.y / mag);
    }

    magnitude() {
        return Math.sqrt(this.x ** 2 + this.y ** 2);
    }

    difference(v) {
        return Math.sqrt((this.x - v.x)**2 + (this.y - v.y)**2);
    }

    mul(s) {
        return new Vector(this.x * s, this.y * s);
    }

    add(v) {
        return new Vector(this.x + v.x, this.y + v.y);
    }

    sub(v) {
        return new Vector(this.x - v.x, this.y - v.y);
    }
}

class Matrix2x2 {
    /**
     *
     * @param {number[][]} m
     */
    constructor(m) {
        if(m.length !== 2) {
            throw 'Illegal Argument in class Matrix2x2 - parameter m must be a 2x2 array';
        }

        if(m[0].length !== 2) {
            throw 'Illegal Argument in class Matrix2x2 - parameter m must be a 2x2 array';
        }

        this.m = m;
    }

    /**
     * @param {Vector} vec
     * @returns {Vector}
     */
    mul(vec) {
        let v = [2];
        for(let i = 0; i < 2; i++) {
            v[i] = this.m[i][0] * vec.x + this.m[i][1] * vec.y;
        }
        return new Vector(v[0], v[1]);
    }
}

/**
 * @param {number} theta angle of rotation in radians
 */
function rotationMatrix(theta) {
    return new Matrix2x2(
        [[Math.cos(theta), -Math.sin(theta)],
             [Math.sin(theta), Math.cos(theta)]]
    );
}

/**
 * @param {number} deg
 * @returns {number}
 */
function degreesToRadians(deg) {
    return deg * Math.PI / 180;
}

/**
 * @param {number} rads
 * @returns {number}
 */
function radiansToDegrees(rads) {
    return rads * 180 / Math.PI;
}

/**
 * @param {Line} line
 * @param {Ellipse} ellipse
 */
function lineEllipseIntersection(line, ellipse) {
    // get y = mx + b form for line
    let v1, v2;
    if(line.start.x - line.end.x === 0) {
        v1 = new Vector(ellipse.center.x, ellipse.center.y + ellipse.vrad);
        v2 = new Vector(ellipse.center.x, ellipse.center.y - ellipse.vrad);
    } else {
        const m = (line.start.y - line.end.y) / (line.start.x - line.end.x);
        const b = line.start.y - m * line.start.x;

        // useful constants
        const vrad2 = ellipse.vrad ** 2;
        const hrad2 = ellipse.hrad ** 2;
        const cx2   = ellipse.center.x ** 2;
        const cy2   = ellipse.center.y ** 2;

        // compute components of quadratic equation for finding intersecting x and y
        const qa = vrad2 + hrad2 * (m ** 2);
        const qb = (2 * hrad2 * m * (b - ellipse.center.y) - 2 * vrad2 * ellipse.center.x);
        const qc = vrad2 * cx2 + hrad2 * (b ** 2 - 2 * b * ellipse.center.y + cy2) - vrad2 * hrad2;

        // the components of the quadratic equation in for i = -b, j = sqrt(b^2-4ac), k = 2a
        // such that x = (i+j)/k and x = (i-j)/k
        const i = -qb;
        const j = Math.sqrt(qb ** 2 - 4 * qa * qc);
        const k = 2 * qa;

        // create the two intersection vectors
        const x1 = (i + j) / k;
        v1 = new Vector(x1, m * x1 + b);

        const x2 = (i - j) / k;
        v2 = new Vector(x2, m * x2 + b);
    }

    // find the nearest vector to the line start
    if(line.start.difference(v1) < line.start.difference(v2)) {
        return v1;
    }
    return v2;
}