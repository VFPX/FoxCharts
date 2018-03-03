* Sample from Yousfi Benameur
* It's the sample "FoxChartsOutsideForm.prg" adapted in order to create one HTML with
* the charts created.
******************************************************************************************

SET CLASSLIB TO LOCFILE("FoxCharts.vcx")
SET TALK OFF
SET CONSOLE OFF

LOCAL loChart AS FoxCharts
loChart = CREATEOBJECT("FoxCharts")

LOCAL lcDir
lcDir = ADDBS(GETENV("TEMP"))

DELETE FILE (lcDir + "FoxChartsSample_*.jpg")  && Erase the old pictures created in the path


WITH loChart AS FoxCharts

* Set some fixed properties for the chart object.

	.WIDTH = 800
	.HEIGHT = 600

	.BACKCOLOR          = RGB(255, 255, 255)
	.SubTitle.CAPTION   = ''
	.ShowValuesonShapes = .T.
	.AlphaChannel       = 220
	.BrushType          = 2 && gradient brush
	.ColorType          = 2 && Random colors
	.Depth              = 30


	.ChartsCount = 2
	.ShowSideLegend = .T.

	* Execute the SQL for the chart.

	OPEN DATABASE HOME(1) + 'Samples\Northwind\Northwind'
	SELECT Categories.CategoryName, ;
		SUM(OrderDetails.UnitPrice * OrderDetails.Quantity) AS Sales, ;
		(SUM(OrderDetails.UnitPrice * OrderDetails.Quantity) / 2) AS Sales2 ;
		FROM Products ;
		JOIN Categories ON Products.CategoryID = Categories.CategoryID ;
		JOIN OrderDetails ON Products.ProductID  = OrderDetails.ProductID ;
		GROUP BY 1 ;
		INTO CURSOR ChartData


* Specify the data source for the chart.

	.SourceAlias = 'ChartData'
	.FieldAxis2  = 'CategoryName'

	.FIELDS(1).FieldValue = "Sales"
	.FIELDS(1).Legend = "Sales"

	.FIELDS(2).FieldValue = "Sales2"
	.FIELDS(2).Legend = "Half Sales"

	.FieldLegend = .FieldAxis2

* Specify the chart type and chart and axis captions.
	.TITLE.CAPTION         = 'Sales by Product Category'
	.XAxis.CAPTION         = 'Product Category'
	.YAxis.CAPTION         = 'Total Sales'
	.AxisLegend2.ROTATION = -45
	.AxisLegend2.ALIGNMENT = 1 && Right
	.ScaleLegend.FORMAT    = '@$ 9,999,999.99'
	.ShapeLegend.FORMAT    = '@$ 9,999,999.99'

ENDWITH

LOCAL N, lcText
FOR N = 1 TO 17

	lcText = "Generating chart #" + TRANSFORM(n) + "/14    " + TRANSFORM((n / 14) * 100) + "%"
	WAIT WINDOW lcText NOWAIT 

	loChart.ChartType = N
	loChart.TITLE.CAPTION = "Chart Type: #" + TRANSFORM(N)
	lcFile = lcDir + FORCEEXT("FoxChartsSample_" + TRANSFORM(n),"JPG")

	* Draw the chart.
	loChart.DrawChart()
	loChart.oBmp.Save(lcfile, _SCREEN.SYSTEM.Drawing.Imaging.ImageFormat.Jpeg)
ENDFOR

WAIT CLEAR 

* Create the HTML
LOCAL lcHTML
SET TEXTMERGE ON
SET TEXTMERGE TO MEMVAR lcHTML NOSHOW

TEXT 
<html>
<head>
<title>FoxCharts Sample</title>
</head>

<body bgcolor="#FFFFFF" >
<div align="center">
  <center>
  <table border="0">
    <tr>
      <td><font size="6" color="#0F0F0F"><b><span style="background-color: #FFFFFF">FoxCharts Gallery</span></b></font></td>
    </tr>
  </table>
  </center>
</div>
<br>

<div align="center">
  <center>
  <table border="0" cellpadding="5" width="914">
ENDTEXT

LOCAL lnCharts

FOR n = 1 TO 14
	lcFile = FULLPATH(lcDir + FORCEEXT("FoxChartsSample_" + TRANSFORM(n),"JPG"))
	IF NOT FILE(lcFile)
		LOOP
	ENDIF 
\    <tr>
\      <td width="100%"><img border="0" src="file:///
\\<<lcFile>>
\\" width="800" height="600"></td>
\   </tr>
ENDFOR 
TEXT 
  </table>
  </center>
</div>

</body>

</html>
ENDTEXT

SET TEXTMERGE TO
SET TEXTMERGE OFF

STRTOFILE(lcHTML, "FoxChartsinHTML.htm")

LOCAL loIe as InternetExplorer.Application
loIe = CREATEOBJECT("InternetExplorer.application")
loIe.Navigate(FULLPATH("FoxChartsinHTML.htm"))
WITH loIe
	.menubar = 0
	.STATUSBAR = 0
	.TOOLBAR = 0
	.WIDTH = SYSMETRIC(1)
ENDWITH
DO WHILE loIe.busy OR loIe.ReadyState # 4
ENDDO
loIe.VISIBLE = .T.