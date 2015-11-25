function solveQuadraticEq(a, b, c) {
    var d = Math.pow(b,2) - 4*a*c;
    var x1 = 0;
    var x2 = 0;
    if (d > 0) {
        x1 = (-b + Math.sqrt(d))/(2*a);
        x2 = (-b - Math.sqrt(d))/(2*a);
    }
    return [x1, x2];
}

function getPoints(sx, sy, px, py, thickness) {
    var r = thickness/2;
    var a = px - sx;
    var b = py - sy;
    var c = (-a)*sx - b*sy;
    var k = -(a/b);
    var q = -(c/b);

    var o = q - sy;

    var result = solveQuadraticEq(
        1 + Math.pow(k,2),
        2*k*o - 2*sx,
        Math.pow(sx,2) + Math.pow(o,2) - Math.pow(r,2));

    var x1 = result[0];
    var x2 = result[1];
    var y1 = k*x1 + q;
    var y2 = k*x2 + q;

    return [x1,y1,x2,y2];
}
