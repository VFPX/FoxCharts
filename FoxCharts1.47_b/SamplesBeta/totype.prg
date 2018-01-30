	LPARAMETERS lu, lcType, lnDefaultLength
	DO CASE
		CASE VARTYPE(lu) = UPPER(lcType)
			RETU lu
		CASE VARTYPE(lu)='T' AND UPPER(lcType)='D'
			RETU IIF(EMPTY(lu), CTOD(''), TTOD(lu))
		CASE VARTYPE(lu)='D' AND UPPER(lcType)='T'
			RETU DTOT(lu)
		OTHERWISE
			RETURN FromText(TRANSFORM(lu), lcType, lnDefaultLength)
	ENDCASE

FUNCTION FromText
	LPARAMETERS luValue, lcType, lnDefaultLength
	LOCAL lcShortType
	IF EMPTY(lcType)
		lcType=UPPER(EVL(lcType,'C'))
	ENDIF
	lcShortType = LEFT(lcType,1)
	DO CASE
		CASE lcShortType='C' AND EMPTY(lnDefaultLength)
			RETURN luValue
		CASE lcShortType='C'
			IF LEN(lcType)=1
				lcType=TEXTMERGE('C(<<lnDefaultLength>>)')
			ENDIF
			RETURN CAST(NVL(luValue,'') AS &lcType)
		CASE lcShortType$'IN'
			IF EMPTY(luValue) OR ISNULL(luValue)
				RETURN 0
			ENDIF
			LOCAL lnVal
			TRY
				lnVal=EVALUATE(luValue)
			CATCH
				lnVal=0
			ENDTRY
			RETURN IIF(lcShortType='I',CAST(lnVal AS I),lnVal)
		CASE lcType='L'
			RETURN IIF(UPPER(ALLTRIM(luValue))$'.T.,TRUE',.T.,.F.)
		CASE lcType='D'
			RETURN CTOD(luValue)
		CASE lcType='T'
			RETURN CTOT(luValue)
	ENDCASE
