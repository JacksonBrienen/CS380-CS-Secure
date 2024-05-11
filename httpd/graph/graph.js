class NodeStyle {

    constructor(borderColor, borderWidth, backgroundColor, textColor, font, minHRad, minVRad, hpadding, vpadding) {
        this.borderColor = borderColor;
        this.borderWidth = borderWidth;
        this.backgroundColor = backgroundColor;
        this.textColor = textColor;
        this.font = font;
        this.minHRad = minHRad;
        this.minVRad = minVRad;
        this.hpadding = hpadding;
        this.vpadding = vpadding;
    }

    copy() {
        return new NodeStyle(
            this.borderColor, this.borderWidth, this.backgroundColor,
            this.textColor, this.font, this.minHRad, this.minVRad,
            this.hpadding, this.vpadding
        );
    }

    static #defaultStyle = new NodeStyle(
      'black', 2, 'white',
        'black', '400 24px Roboto', 10,
        10, 15, 15
    );

    static default() {
        return NodeStyle.#defaultStyle;
    }

}

class Node {
    static #ctx = document.createElement('canvas').getContext('2d');

    /**
     * @type {NodeStyle}
     */
    #style = NodeStyle.default();
    #text = '';
    #textw = 0;
    #texth = 0;

    /**
     * @param {Vector} center
     */
    constructor(center) {
        this.ellipse = new Ellipse(center, this.#style.minHRad, this.#style.minVRad);
    }

    /**
     * @param {String} text
     */
    setText(text) {
        if(!text || /^\s*$/.test(text)) {
            this.#text = '';
            this.#textw = 0;
            this.#texth = 0;
        } else {
            this.#text = text;

            Node.#ctx.font = this.#style.font;

            const fontBounds = Node.#ctx.measureText(this.#text);
            this.#textw = fontBounds.width;
            this.#texth = fontBounds.actualBoundingBoxAscent + fontBounds.actualBoundingBoxDescent;

            this.ellipse.hrad = this.#textw / 2 + this.#style.hpadding;
            this.ellipse.vrad = this.#texth / 2 + this.#style.vpadding;
        }
    }

    /**
     * @param {CanvasRenderingContext2D} ctx
     */
    draw(ctx) {
        // if text width or height is undefined, calculate it
        // draw ellipse background

        ctx.fillStyle = this.#style.borderColor;
        ctx.beginPath();
        this.ellipse.path(ctx);
        ctx.fill();

        ctx.fillStyle = this.#style.backgroundColor;
        ctx.beginPath();
        this.ellipse.hrad -= this.#style.borderWidth;
        this.ellipse.vrad -= this.#style.borderWidth;
        this.ellipse.path(ctx);
        this.ellipse.hrad += this.#style.borderWidth;
        this.ellipse.vrad += this.#style.borderWidth;
        ctx.fill();

        ctx.font = this.#style.font;
        // draw text
        ctx.fillStyle = this.#style.textColor;
        ctx.fillText(this.#text,
                  this.ellipse.center.x - this.#textw / 2,
                  this.ellipse.center.y + this.#texth / 2);
    }

    /**
     * @param {NodeStyle} style
     */
    setStyle(style) {

        if(this.#style.font !== style.font) {
            this.#textw = undefined;
            this.#texth = undefined;
        }

        if(this.ellipse.vrad < style.minVRad) {
            this.ellipse.vrad = style.minVRad;
        }

        if(this.ellipse.hrad < style.minHRad) {
            this.ellipse.hrad = style.minHRad;
        }

        this.#style = style;
    }

    resetStyle() {
        this.setStyle(NodeStyle.default());
    }

}

class EdgeStyle {

    constructor(edgeColor, edgeWidth, arrowColor, arrowWidth, arrowLength, arrowAngle, arrowFill) {
        this.edgeColor = edgeColor;
        this.edgeWidth = edgeWidth;
        this.arrowColor = arrowColor;
        this.arrowWidth = arrowWidth;
        this.arrowLength = arrowLength;
        this.arrowAngle = arrowAngle;
        this.arrowFill = arrowFill;
    }

    copy() {
        return new EdgeStyle(
            this.edgeColor, this.edgeWidth, this.arrowColor,
            this.arrowWidth, this.arrowLength, this.arrowAngle, this.arrowFill
        );
    }

    static #defaultStyle = new EdgeStyle(
        'black', 1.5, 'black', 1.5,
        10, Math.PI/8, false
    );

    static default() {
        return EdgeStyle.#defaultStyle;
    }

}

class Edge {

    #style = EdgeStyle.default();

    /**
     * @param {Node} from
     * @param {Node} to
     */
    constructor(from, to) {
        this.from = from;
        this.to = to;
    }

    setStyle(style) {
        this.#style = style;
    }

    /**
     * @param {CanvasRenderingContext2D} ctx
     */
    draw(ctx) {
        const line = new Line(this.from.ellipse.center, this.to.ellipse.center);
        const intersection = lineEllipseIntersection(line, this.to.ellipse);

        const v = line.start.sub(intersection).normalize().mul(this.#style.arrowLength);

        const right = rotationMatrix(this.#style.arrowAngle).mul(v).add(intersection);
        const left = rotationMatrix(-this.#style.arrowAngle).mul(v).add(intersection);

        // draw the edge's line
        ctx.strokeStyle = this.#style.edgeColor;
        ctx.lineWidth = this.#style.edgeWidth;
        ctx.beginPath();
        ctx.moveTo(line.start.x, line.start.y);
        ctx.lineTo(line.end.x, line.end.y);
        ctx.stroke();

        // draw the edge's arrow
        ctx.strokeStyle = this.#style.arrowColor;
        ctx.fillStyle = this.#style.arrowColor;
        ctx.lineWidth = this.#style.arrowWidth;
        ctx.beginPath();

        if(this.#style.arrowFill) {
            ctx.moveTo(intersection.x, intersection.y);
            ctx.lineTo(right.x, right.y);
            ctx.lineTo(left.x, left.y);
            ctx.moveTo(intersection.x, intersection.y);
            ctx.fill();
        } else {
            ctx.beginPath();
            ctx.moveTo(intersection.x, intersection.y);
            ctx.lineTo(right.x, right.y);
            ctx.stroke();

            ctx.beginPath();
            ctx.moveTo(intersection.x, intersection.y);
            ctx.lineTo(left.x, left.y);
            ctx.stroke();
        }
    }

}