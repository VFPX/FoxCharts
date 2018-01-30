SET CLASSLIB TO LOCFILE("FoxCharts.vcx")
SET TALK OFF
SET CONSOLE OFF

LOCAL loChart AS FoxCharts
loChart = CREATEOBJECT("FoxCharts")

WITH loChart AS FoxCharts OF '..\FoxCharts\Source\FoxCharts.vcx'

* Set some fixed properties for the chart object.

	.WIDTH = 600
	.HEIGHT = 450

	.BACKCOLOR          = RGB(255, 255, 255)
	.SubTitle.CAPTION   = ''
	.ShowValuesonShapes = .T.
	.AlphaChannel       = 220
	.BrushType          = 2 && gradient brush
	.ColorType          = 2 && Random colors
	.Depth              = 30

	.Legend1 = "Legend #1"

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

LOCAL N
FOR N = 1 TO 14

	IF N = 3
		N = N + 1
	ENDIF

	loChart.ChartType = N
	loChart.TITLE.CAPTION = "Chart Type: #" + TRANSFORM(N)

	lcfile = FORCEEXT(SYS(2015),"JPG")

* Draw the chart.
	loChart.DrawChart()
	loChart.oBmp.SAVE(lcfile, _SCREEN.SYSTEM.Drawing.Imaging.ImageFormat.Jpeg)

	lcCommand = "RUN /N Explorer.Exe " + lcfile
	&lcCommand

ENDFOR
