LPARAMETERS tnExportType, tcProperties, tcPictureObject
*********************************************
*	tnExportType :
*	0 (or each empty value) - Copy to Clipboard
*	1	- Save As
*	2	- MS Excel
*	3	- MS Word
*	4	- OO Writer
*	5	- HTML
*	6	- Print
*   7   - Report
*********************************************
* Create Foxcharts object
LOCAL loChart
IF NOT 'ALIAS FOXCHARTSBETa' $ SET('Class')
	SET CLASSLIB TO Source\foxchartsbeta.VCX ADDI
ENDIF
loChart = CREATEOBJECT('foxchartsbeta.FoxCharts')


* Next step is to Setup loChart

WITH loChart
	=EXECSCRIPT(tcProperties)
* Draw the chart

	.DrawChart()
	DO CASE
		CASE EMPTY(tnExportType)
			.oBmp.ToClipboard()
		CASE tnExportType=1
			LOCAL lcFile
*!*				lcImgFormatTypes
*!*				m.lcImgFormatTypes = "bmp;jpg;gif;png;tif"
** Koen: since PNG is default, have put this option at number 1 place
			m.lcFile = PUTFILE("Save as ...", "", "PNG (*.png);bmp;jpg;gif;TIFF (*.tiff)")
			IF EMPTY(m.lcFile) && Invalid File Name
				RETURN .F.
			ENDIF
			.SaveToFile(m.lcFile)
		CASE tnExportType=2
			.ToXLS()
		CASE tnExportType=3
			.ToWord()
		CASE tnExportType=4
			.ToWriter()
		CASE tnExportType=5
			ToHTML(loChart)
		CASE tnExportType=6
			.oBmp.ToPrinter()
		CASE tnExportType=7
			.Chart2Report()
	ENDCASE
ENDWITH


FUNCTION ToHTML
	LPARAMETERS loChart
	LOCAL lcDir, lcHtml, lcHTMLname, lcPicture
	m.lcDir = ADDBS(GETENV("TEMP"))

	m.lcHTMLname = m.lcDir + 'Charts.html'
	m.lcHtml=''

	m.lcPicture = m.lcDir + '_TempChart.PNG'
	m.loChart.SaveToFile(m.lcPicture)

	SET TEXTMERGE ON

	TEXT TO m.lcHtml ADDITIVE NOSHOW

<html>
<head>
<title>Charts</title>

<META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=Windows-1251">
</head>

<style type="text/css">
table.border tr td,
table.border tr th {border:1px solid black;}
table.border {border-collapse:collapse;}
</style>

<body>
<p></p>
<font face="tahoma, arial, times new roman">

<p><b><h1 align="center"><<loChart.Title.Caption>></h1></b></p>

<table align="center" class="border">
<tr>
<th width=70>-</th>

	ENDTEXT


* AddTable

	SELECT * FROM (m.loChart._datacursor) INTO CURSOR MainCursor
	SELECT MainCursor
	LOCAL lnCharts, lnRow, lnChart, lnCol
	m.lnCharts = m.loChart.ChartsCount
	m.lnRow = m.loChart.ChartRow

	FOR m.lnChart = 1 TO m.lnCharts

		TEXT TO m.lcHtml ADDITIVE NOSHOW
<th width=70><<EVL(m.loChart.Fields(m.lnChart).Legend,'-')>></th>
<<IIF(m.lnChart=m.lnCharts,'</tr>'+CHR(13)+CHR(10),'')>>
		ENDTEXT
	NEXT

	SCAN

		TEXT TO m.lcHtml ADDITIVE NOSHOW
<tr>
<th><<ALLTRIM(MainCursor.cLegend)>></th>

		ENDTEXT

		FOR m.lnCol = 1 TO m.lnCharts

			TEXT TO m.lcHtml ADDITIVE NOSHOW
<td align="center"<<IIF((m.lnCol = m.lnRow AND m.loChart.SingleData), ' bgcolor=#f3f0ff>','>')>><<TRANSFORM(EVALUATE('nValue'+TRANSFORM(m.lnCol)))>></td>
<<IIF(m.lnCol = m.lnCharts,'</tr>' + CHR(13) + CHR(10),'')>>
			ENDTEXT

		NEXT

	ENDSCAN

	TEXT TO m.lcHtml ADDITIVE NOSHOW
</table>
<p></p>

<table align="center"><tr>
<IMG src="<<m.lcPicture>>">
</tr></table>

</font>
</body>
</html>
	ENDTEXT

	m.lcPicture=''

	STRTOFILE(m.lcHtml,m.lcHTMLname,0)

	LOCAL loIE
	m.loIE = CREATEOBJECT("InternetExplorer.Application")
	m.loIE.VISIBLE=.T.
	m.loIE.NAVIGATE(m.lcHTMLname,4)
