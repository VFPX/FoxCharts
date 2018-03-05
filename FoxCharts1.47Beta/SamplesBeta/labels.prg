LPARAMETERS lnType, lnTextLeft, lnTextTop, lnWidth, lnHeight,  lnCenterX, lnCenterY, lnPointerSide, lnPointerSubSide, lnPointerWidth
LOCAL lcPolygon, lcStr, lnBottom, lnCount, lnHalf, lnLine, lnRad, lnRight, lnTop
m.lnHalf = lnHeight/2
lnRad= INT(MAX(MIN( lnWidth, lnHeight)/10,2))
lcPolygon=''
lnTop = lnTextTop	&& -lnHalf
lnBottom = lnTextTop + lnHeight
lnRight = lnTextLeft+lnWidth

lnAwayFromCenter = .15	&& Relative. Halh of height/width
lnPointerWidth =  IIF(VARTYPE(lnPointerWidth)='N',lnPointerWidth,.5)

lnPointerSide = IIF(VARTYPE(lnPointerSide)='N',lnPointerSide,3)
lnPointerSubSide = IIF(VARTYPE(lnPointerSubSide)='N',lnPointerSubSide,1)
lnArrowWidth = lnPointerWidth

lnPointerWidth =  MIN(IIF(lnPointerWidth<=1,lnWidth/2 * lnPointerWidth, lnPointerWidth), lnWidth/4)
lnPointerHeight = MIN( IIF(lnPointerWidth<=1,lnHeight/2 * lnPointerWidth,lnPointerWidth),lnHeight/4)
DO CASE
	CASE lnType = 1	&& Прямоугольник
		lnLeftMargin = 3
		lnTopMargin = 2
		lnRight = lnRight + lnLeftMargin*2
		lnBottom = lnBottom + lnTopMargin * 2

*
*	Left-hand side
*

		IF lnPointerSide # 4
			=NewRow( @lcPolygon, lnTextLeft,lnBottom-lnRad, lnTextLeft,lnTop+lnRad)
		ELSE
			DO CASE
				CASE lnPointerSubSide = 1
					lnPointerTop = lnTextTop + lnHeight/2 + lnHeight/2 *  lnAwayFromCenter
					lnPointerBottom= lnPointerTop +lnPointerHeight
				CASE lnPointerSubSide = 3
					lnPointerTop = lnTextTop + lnHeight/2 - lnPointerHeight/2
					lnPointerBottom= lnPointerTop + lnPointerHeight
				OTHERWISE
					lnPointerTop = lnTextTop + lnHeight/2 - lnHeight/2 *  lnAwayFromCenter - lnPointerHeight
					lnPointerBottom= lnPointerTop + lnPointerHeight
			ENDCASE
			=NewRow( @lcPolygon,lnTextLeft,lnBottom-lnRad,lnTextLeft,lnPointerBottom)
			=NewRow( @lcPolygon,lnTextLeft,lnPointerBottom, lnTextLeft - lnArrowWidth, lnPointerBottom - lnPointerHeight/2)	&& Pointer
			=NewRow( @lcPolygon, lnTextLeft - lnArrowWidth, lnPointerBottom- lnPointerHeight/2, lnTextLeft, lnPointerTop)	&& Pointer
			=NewRow( @lcPolygon, lnTextLeft, lnPointerTop, lnTextLeft,lnTop+lnRad)
		ENDIF
		=NewRow( @lcPolygon, lnTextLeft,lnTop,lnRad*2,lnRad*2,180,90)
*
*	Top
*
		IF lnPointerSide # 1
			=NewRow( @lcPolygon, lnTextLeft+lnRad,lnTop,lnRight - lnRad,lnTop)			&& Top
		ELSE
			DO CASE
				CASE lnPointerSubSide = 1
					lnPointerLeft = lnTextLeft + lnWidth/2 - lnWidth/2 *  lnAwayFromCenter - lnPointerWidth
					lnPointerRight= lnPointerLeft +lnPointerWidth
				CASE lnPointerSubSide = 2
					lnPointerLeft = lnTextLeft + lnWidth/2 + lnWidth/2 *  lnAwayFromCenter
					lnPointerRight= lnPointerLeft +lnPointerWidth
				OTHERWISE
					lnPointerLeft = lnTextLeft + lnWidth/2 - lnPointerWidth/2
					lnPointerRight= lnPointerLeft + lnPointerWidth
			ENDCASE
			=NewRow( @lcPolygon, lnTextLeft+lnRad,lnTop,lnPointerLeft,lnTop)
			=NewRow( @lcPolygon, lnPointerLeft,lnTop,lnPointerLeft + lnPointerWidth/2,lnTop - lnArrowWidth)	&& Pointer
			=NewRow( @lcPolygon, lnPointerLeft + lnPointerWidth/2,lnTop - lnArrowWidth , lnPointerRight, lnTop)	&& Pointer
			=NewRow( @lcPolygon, lnPointerRight, lnTop,lnRight - lnRad,lnTop)
		ENDIF
		=NewRow( @lcPolygon, lnRight-lnRad*2,lnTop ,lnRad*2,lnRad*2, 270, 90)

*
*	Right-hand side
*
		IF lnPointerSide # 2
			=NewRow( @lcPolygon, lnRight, lnTop + lnRad,lnRight,lnBottom-lnRad)		&& Just Right
		ELSE
			DO CASE
				CASE lnPointerSubSide = 1
					lnPointerTop = lnTextTop + lnHeight/2 + lnHeight/2 *  lnAwayFromCenter
					lnPointerBottom= lnPointerTop +lnPointerHeight
				CASE lnPointerSubSide = 2
					lnPointerTop = lnTextTop + lnHeight/2 - lnHeight/2 *  lnAwayFromCenter - lnPointerHeight
					lnPointerBottom= lnPointerTop + lnPointerHeight
				OTHERWISE
					lnPointerTop = lnTextTop + lnHeight/2 - lnPointerHeight/2
					lnPointerBottom= lnPointerTop + lnPointerHeight
			ENDCASE

			=NewRow( @lcPolygon,lnRight, lnTop + lnRad, lnRight, lnPointerTop)
			=NewRow( @lcPolygon,lnRight, lnPointerTop, lnRight + lnArrowWidth, lnPointerTop +lnPointerHeight/2)	&& Pointer
			=NewRow( @lcPolygon,lnRight +  lnArrowWidth, lnPointerTop +lnPointerHeight/2, lnRight, lnPointerBottom)	&& Pointer
			=NewRow( @lcPolygon, lnRight, lnPointerBottom, lnRight,lnBottom-lnRad)
		ENDIF
		=NewRow( @lcPolygon, lnRight-lnRad*2,lnBottom-lnRad*2 ,lnRad*2,lnRad*2, 0, 90)
*
*	Bottom
*
		IF lnPointerSide # 3
			=NewRow( @lcPolygon, lnRight-lnRad,lnBottom,lnTextLeft+lnRad,lnBottom)	&& Bottom
		ELSE
			DO CASE
				CASE lnPointerSubSide = 1
					lnPointerLeft = lnTextLeft + lnWidth/2 - lnWidth/2 *  lnAwayFromCenter - lnPointerWidth
					lnPointerRight= lnPointerLeft +lnPointerWidth
				CASE lnPointerSubSide = 2
					lnPointerLeft = lnTextLeft + lnWidth/2 + lnWidth/2 *  lnAwayFromCenter
					lnPointerRight= lnPointerLeft +lnPointerWidth
				OTHERWISE
					lnPointerLeft = lnTextLeft + lnWidth/2 - lnPointerWidth/2
					lnPointerRight= lnPointerLeft +lnPointerWidth
			ENDCASE

			=NewRow( @lcPolygon, lnRight-lnRad,lnBottom,lnPointerRight,lnBottom)
			=NewRow( @lcPolygon, lnPointerRight,lnBottom,lnPointerRight - lnPointerWidth/2,lnBottom + lnArrowWidth)	&& Pointer
			=NewRow( @lcPolygon, lnPointerRight - lnPointerWidth/2,lnBottom + lnArrowWidth, lnPointerLeft, lnBottom)	&& Pointer
			=NewRow( @lcPolygon, lnPointerLeft, lnBottom,lnTextLeft+lnRad,lnBottom)
		ENDIF

		=NewRow( @lcPolygon, lnTextLeft,lnBottom-lnRad*2,lnRad*2,lnRad*2,90,90)
		lnTextLeft = lnTextLeft + lnLeftMargin
		lnTextTop = lnTextTop + lnTopMargin
		lnWidth = lnWidth + lnLeftMargin * 2
		lnHeight = lnHeight + lnTopMargin*2
	CASE lnType = 2	&& Стрелка вправо
		lnTop = lnTextTop
		lnEndWidth = 30
		lnWidth = lnWidth + lnEndWidth / 2
		lnLeft = lnTextLeft - lnWidth
		=NewRow( @lcPolygon, lnLeft, lnBottom-lnRad, lnLeft, lnTop+lnRad)
		=NewRow( @lcPolygon, lnLeft,lnTop,lnRad*2,lnRad*2,180,90)
		=NewRow( @lcPolygon, lnLeft+lnRad,lnTop,lnLeft + m.lnWidth -lnEndWidth-lnRad,lnTop)
		=NewRow( @lcPolygon,lnLeft + m.lnWidth - lnEndWidth-lnRad*2,lnTop-lnRad*2,lnRad*2,lnRad*2,90,-90)
		=NewRow( @lcPolygon,lnLeft + m.lnWidth - lnEndWidth,lnTop+lnHalf - m.lnHeight+lnRad, lnLeft + m.lnWidth - lnEndWidth ,lnTop+lnHalf - m.lnHeight )

		=NewRow( @lcPolygon,lnLeft + m.lnWidth - lnEndWidth,lnTop+lnHalf - m.lnHeight, lnLeft + m.lnWidth ,lnTop+lnHalf )
		=NewRow( @lcPolygon,lnLeft + m.lnWidth,lnTop+lnHalf ,lnLeft + m.lnWidth - lnEndWidth,lnTop+lnHalf + m.lnHeight )
		=NewRow( @lcPolygon,lnLeft + m.lnWidth - lnEndWidth,lnTop+lnHalf + m.lnHeight,lnLeft + m.lnWidth - lnEndWidth,lnBottom + lnRad)

		=NewRow( @lcPolygon,lnLeft + m.lnWidth - lnEndWidth-lnRad*2,lnBottom,lnRad*2,lnRad*2,0,-90)
		=NewRow( @lcPolygon,lnLeft + m.lnWidth - lnEndWidth-lnRad,lnBottom, lnLeft+lnRad ,lnBottom)
		=NewRow( @lcPolygon,lnLeft,lnBottom-lnRad*2,lnRad*2,lnRad*2,90,90)
		lnTextLeft = lnLeft + lnRad
		lnCenterX = lnLeft+lnWidth
		lnCenterY = lnTop+lnHeight/2
	CASE lnType = 3	&& Стрелка влево
		lnLeft = lnTextLeft
		lnTop = lnTextTop
		lnEndWidth = 30
		lnRight = lnLeft+lnWidth+ lnEndWidth
		=NewRow( @lcPolygon, lnRight, lnBottom-lnRad, lnRight, lnTop+lnRad)
		=NewRow( @lcPolygon, lnRight-lnRad*2,lnTop,lnRad*2,lnRad*2,0,-90)
		=NewRow( @lcPolygon, lnRight -lnRad,lnTop,lnLeft + lnEndWidth+lnRad,lnTop)
		=NewRow( @lcPolygon,lnLeft + lnEndWidth,lnTop-lnRad*2,lnRad*2,lnRad*2,90,90)
		=NewRow( @lcPolygon,lnLeft + lnEndWidth,lnTop-lnRad, lnLeft + m.lnEndWidth , lnTop+lnHalf - m.lnHeight )

		=NewRow( @lcPolygon,lnLeft + lnEndWidth,lnTop+lnHalf - m.lnHeight, lnLeft  ,lnTop+lnHalf )

		=NewRow( @lcPolygon,lnLeft ,lnTop+lnHalf ,lnLeft +  lnEndWidth,lnTop+lnHalf + m.lnHeight )
		=NewRow( @lcPolygon,lnLeft + lnEndWidth,lnTop+lnHalf + m.lnHeight ,lnLeft + lnEndWidth,lnTop + lnHeight+lnRad)
		=NewRow( @lcPolygon,lnLeft + lnEndWidth,lnTop+lnHeight,lnRad*2,lnRad*2,180,90)
		=NewRow( @lcPolygon,lnLeft + lnEndWidth + lnRad,lnTop+lnHeight, lnLeft+lnWidth+lnEndWidth-lnRad ,lnTop+lnHeight)
		=NewRow( @lcPolygon,lnLeft+lnWidth+lnEndWidth-lnRad*2,lnTop+lnHeight-lnRad*2,lnRad*2,lnRad*2,90,-90)
		lnTextLeft = lnLeft + lnEndWidth - lnRad
		lnCenterY = lnTop+lnHeight/2

	CASE lnType = 4
		lnLeft = lnTextLeft
		lnTop = lnTextTop
		lnWidth1 = lnWidth/SQRT(2) * 2
		lnHeight1 = lnHeight / SQRT(2) * 2
		=NewRow( @lcPolygon, lnLeft, lnTop, lnWidth1, lnHeight1,0,360)
*		=NewRow( @lcPolygon, lnLeft, lnTop)
		lnTextLeft = lnLeft + (lnWidth1 - lnWidth) / 2
		lnTextTop = lnTop + (lnHeight1 - lnHeight) / 2

	OTHERWISE
		=NewRow( @lcPolygon, lnTextLeft,lnBottom,lnTextLeft,lnTop)
		=NewRow( @lcPolygon, lnTextLeft,lnTop,lnRight,lnTop)
		=NewRow( @lcPolygon, lnRight,lnTop,lnRight,lnBottom)
		=NewRow( @lcPolygon, lnRight,lnBottom,lnTextLeft,lnBottom)
ENDCASE
RETURN lcPolygon

FUNCTION NewRow
	LPARAMETERS lcText,tcParam1,tcParam2,tcParam3,tcParam4,tcParam5,tcParam6,tcParam7
	lnCount = PCOUNT()
	IF lnCount>3 AND VARTYPE(tcParam3)#'N'
		tcParam3=tcParam1
	ENDIF
	FOR lnLine=1 TO lnCount-1
		lcStr = IIF(lnLine=1, '', lcStr+',') + TRANSFORM(ROUND(EVALUATE('tcParam'+ALLT(STR(lnLine))),0))
	NEXT
	TEXT TO lcText addi
<<lcStr>>

	ENDTEXT
