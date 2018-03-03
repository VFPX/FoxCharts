LPARAMETERS loObj,lnPosition
LOCAL lnReturn, lnColumn, lnGrdLeft, lnGridLeft, lnLeft, lnNext, lnRight, loNext
IF NOT BETWEEN(lnPosition,2,3)
	RETURN OBJTOCLIENT(loObj,lnPosition)
ENDIF

IF LEFT(VERSION(4),11)='09.00.0000.' AND VAL(GETWORDNUM(VERSION(4),4,'.'))>3504	; && Service Pack 2
	AND LOWER(loObj.BASECLASS)='column'	&& Колонка грида
	DO CASE
		CASE lnPosition=2 && Left
			lnReturn = OBJTOCLIENT(loObj,2) - OBJTOCLIENT(loObj.PARENT,2)
		CASE lnPosition=3 && Width
			lnGridLeft = OBJTOCLIENT(loObj.PARENT,2)
			lnLeft       = OBJTOCLIENT(loObj,2) - lnGridLeft
			IF lnLeft=0
				RETURN 0
			ENDIF
			lnColumn =  VAL(SUBSTR(loObj.NAME,7))
			IF lnColumn =loObj.PARENT.LOCKCOLUMNS
				lnGrdLeft=OBJTOCLIENT(loObj.PARENT,2)
				FOR lnNext= lnColumn +1 TO loObj.PARENT.COLUMNCOUNT
					IF OBJTOCLIENT(loObj.PARENT.COLUMNS(lnNext),2)>lnGrdLeft
						EXIT
					ENDIF
				NEXT
			ELSE
				lnNext = lnColumn +1
			ENDIF
			IF lnNext<=loObj.PARENT.COLUMNCOUNT
				loNext=loObj.PARENT.COLUMNS(lnNext)
				lnRight= OBJTOCLIENT(loNext,2)-loObj.PARENT.LEFT
				IF lnRight>0
					RETURN lnRight - lnLeft -  IIF(lnColumn=loObj.PARENT.LOCKCOLUMNS,2,1)
				ENDIF
			ENDIF
			lnRight= lnGridLeft + loObj.PARENT.WIDTH - IIF(loObj.PARENT.SCROLLBARS>1,SYSMETRIC(15),0) - 1
			RETURN lnRight - lnLeft - IIF(lnColumn=loObj.PARENT.LOCKCOLUMNS,2,1)
	ENDCASE
ELSE
	lnReturn = OBJTOCLIENT(loObj,lnPosition)
ENDIF
IF lnPosition=2 && Left
	DO WHILE NOT UPPER(m.loObj.BASECLASS) == [FORM]
		IF UPPER(m.loObj.BASECLASS) == [PAGE]
			IF m.loObj.PARENT.TABORIENTATION = 2 && Left
				m.lnReturn = m.lnReturn + ;
					m.loObj.PARENT.WIDTH - ;
					m.loObj.PARENT.PAGEWIDTH - ;
					m.loObj.PARENT.BORDERWIDTH * 2
			ELSE
				m.lnReturn = m.lnReturn - 1
			ENDIF
		ENDIF
		m.loObj = m.loObj.PARENT
	ENDDO
ENDIF
RETURN lnReturn
