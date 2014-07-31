! Copyright (C) 2014 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel math math.order accessors ui ui.gadgets ui.gadgets.canvas 
       ui.render opengl.gl random sequences io fry arrays 
       namespaces literals ui.pixel-formats prettyprint ;
IN: random-walk


! insert-sort
: is_greatest ( seq elt -- new_seq )
    swap
    2dup [ < ] with find drop over length or swap insert-nth
;

: ins-sort ( seq -- seq seq )
    dup
    { }
    swap
    [
        is_greatest
    ] each
;

CONSTANT: width         400
CONSTANT: height        400
CONSTANT: line-width    3

SYMBOL: x
SYMBOL: y
SYMBOL: walk-counter

: init ( -- ) 
    width 2 /i x set 
    height 2 /i y set 
    line-width 2 - glLineWidth
    line-width 2 - glPointSize
    1.0 1.0 1.0 1.0 glColor4d
;

: draw-line ( -- ) 
    GL_LINE_STRIP glBegin
    x get y get
    x get y get [ 3 random 1 - + ] bi@
    4dup
    [ glVertex2d ] 2bi@
    y set x set 2drop
    glEnd
    walk-counter get 1 + walk-counter set 
;

: main-loop ( -- )
    0 walk-counter set 
    [ walk-counter get 100000 < ]
    [ draw-line ]
    while 
;

: random-walk ( n -- ) 
    drop
    main-loop
;

TUPLE: walk-window < canvas ;

: <walk-window> ( -- gadget ) walk-window new-canvas ;

: n ( gadget -- n ) dim>> first2 min line-width /i ;

M: walk-window layout* delete-canvas-dlist ;

M: walk-window draw-gadget* [ n random-walk ] init draw-canvas ;

M: walk-window pref-dim* drop { $ width $ height } ;

MAIN-WINDOW: win { { title "Random walk" } }
    <walk-window> >>gadgets ;

MAIN: win
