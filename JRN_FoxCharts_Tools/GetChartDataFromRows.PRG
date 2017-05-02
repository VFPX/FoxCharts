*** JRN 07/30/2009 
* 	Takes chart data that is stored in rows, rather than columns
*	and transforms it so that it is usable by FoxCharts:
*
*	Two cursors (tables) are used:
*		<tcDataAlias>:
*			Each record corresponds to one data series (that it, what would normally appear as a field in <SourceAlias>)
*			Thus, the 'Browse' of this cursor lays out the data much as it would appear in a line or bar chart.
*			Other (optional) fields in this cursor:
*				- side legend names <tcFieldSideLegend>			= .Legends(N).Legend
*				- custom colors <tcFieldColor>					= .Legends(N).Color
*				- line cap shapes <tcFieldShape)				= .Legends(N).Shape
*		<tcRowAlias>
*			Each record is used to select a field from <tcDataAlias> for data.  Two fields in this cursor:
*				- the name of a data field in <tcDataAlias> ... <tcFieldRow>
*				- the text of the X-Axis legend corresponding to the data field ... <tcFieldAxisLegend>

Lparameters 				;
	toFoxChart,				;
	tcDataAlias,			;
	tcFieldSideLegend,		;
	;
	tcRowAlias,				;
	tcFieldRow,				;
	tcFieldAxisLegend,		;
	;
	tcFieldColor,			;
	tcFieldShape

****************************************************************
* Parameters
*	toFoxChart			= the FoxCharts container

*	tcDataAlias			= the name of the cursor containing the data to be charted
*	tcFieldSideLegend	= the name of the field in <tcDataAlias> containing the side legend name (optional)

*	tcRowAlias			= the name of the cursor containing info about what columns from <tcDataAlias> contain data
*	tcFieldRow			= the name of the field in <tcRowAlias> containing the name of the field in <tcDataAlias> that has chart data
*	tcFieldAxisLegend	= the name of the field in <tcRowAlias> containing the text used as X-Axis legends (optional)

*	tcFieldColor		= the name of the field in <tcDataAlias> containing the custom color (optional)
*	tcFieldShape		= the name of the field in <tcDataAlias> containing the line cap shape (optional)

Local Array laFields[1]
Local lcSourceAlias, lnRow, lcDataType, lcFieldName

With toFoxChart

	lcSourceAlias = tcDataAlias + "_Transposed"
	If Used (lcSourceAlias)
		Use In &lcSourceAlias
	Endif

	Select * 									;
		From (tcRowAlias)						;
		Into Cursor (lcSourceAlias) Readwrite

	.SourceAlias = lcSourceAlias
	If Not Empty (tcFieldAxisLegend)
		.FieldAxis2  = tcFieldAxisLegend
	Endif

	Afields(laFields, tcDataAlias)
	lnRow = Ascan(laFields, Trim(&tcFieldRow), -1, -1, 1, 15)
	lcDataType = laFields(lnRow,2) + "(" + Transform(laFields(lnRow,3)) + Iif(laFields(lnRow,2) = 'N', "," + Transform(laFields(lnRow,4)), '') + ")"

	Select (tcDataAlias)
	.ChartsCount = Reccount()
	Scan
		With .Fields(Recno())
			lcFieldName 	= 'Value' + Transform(Recno())
			.FieldValue 	= lcFieldName
			Alter Table (lcSourceAlias) Add Column (lcFieldName) &lcDataType Null

			If Not Empty (tcFieldSideLegend)
				.Legend		= Alltrim (&tcFieldSideLegend)
			Endif

			If Not Empty (tcFieldColor)
				.Color		= &tcFieldColor
			Endif

			If Not Empty (tcFieldShape)
				.Shape		= &tcFieldShape
			Endif

			Select (lcSourceAlias)
			Scan
				lcSourceField = &tcFieldRow
				Replace &lcFieldName With &tcDataAlias..&lcSourceField
			Endscan

		Endwith
	Endscan

Endwith

Return
