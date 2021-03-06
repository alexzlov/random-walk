! Copyright (C) 2014 Your name.
! See http://factorcode.org/license.txt for BSD license.
USING:  kernel              math                math.order 
        accessors           ui                  ui.gadgets 
        ui.gadgets.canvas   ui.render           opengl.gl 
        random              sequences           io 
        fry                 arrays              namespaces 
        literals            ui.pixel-formats    prettyprint ;
IN: random-walk

CONSTANT: width         400
CONSTANT: height        400
CONSTANT: line-width    3

: init ( -- )  
    line-width 2 - glLineWidth
    line-width 2 - glPointSize
    1.0 1.0 1.0 1.0 glColor4d
;

! @TODO: make animated random-walk
! @TODO: Another approach: make lazy array of random steps
: draw-line ( x y -- x' y' ) 
    GL_LINE_STRIP glBegin
    2dup
    [ 3 random 1 - + ] bi@
    4dup
    [ glVertex2d ] 2bi@
    [ 2drop ] 2dip
    glEnd
;

: main-loop ( -- )
    ! init counter
    0
    ! starting from the center
    width 2 / height 2 /
    ! main loop                
    [ [ dup 10000 < ] 2dip rot ]
    [ 
        draw-line 
        ! increment counter
        [ 1 + ] 2dip 
    ]
    while
    ! cleaning
    3drop
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
