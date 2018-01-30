LPARAMETERS loForm
LOCAL lcName
lcName = 'Sample'+ALLTRIM(STR(RECNO()))
loForm.ADDOBJECT(lcName, "Sample", loForm)
RETURN EVALUATE('loForm.'+lcName)
DEFINE CLASS SAMPLE AS CONTAINER
	RECNO = 0
	MyPictureVal = ''
	FUNCTION INIT
		LPARAMETERS loForm
		WITH THIS
			.WIDTH = loForm.WIDTH
			.Height = loForm.SampleHeight

			.RECNO = RECNO()

			.ADDOBJECT ('Label', 'label')
			.LABEL.CAPTION = ALLTRIM(STR(RECNO())) +". "+ALLTRIM(Category) + ": " +ALLTRIM(CAPTION)
			.LABEL.LEFT = 5
			.LABEL.TOP = 2
			.LABEL.FONTBOLD=.T.
			.LABEL.FONTUNDERLINE=.T.
			.LABEL.VISIBLE = .T.
			.LABEL.AUTOSIZE = .T.

			.ADDOBJECT ('Chart', 'image')
			.Chart.WIDTH=200
			.Chart.Stretch = 2
			.Chart.HEIGHT = .HEIGHT
			.Chart.LEFT = .WIDTH - .Chart.WIDTH -1
			.Chart.Pictureval = Chart
			.Chart.VISIBLE=not EMPTY(Chart)
			BINDEVENT(.Chart,'Click', THIS, 'Run')
			BINDEVENT(.Chart,'RightClick', THIS, 'Edit')
			TEXT TO .Chart.ToolTipText
Click - run form			
RightClick - edit form
			ENDTEXT

			.ADDOBJECT ('Notes', 'EditBox')
			.Notes.VALUE = ALLTRIM(Notes)
			.Notes.TOOLTIPTEXT = ALLTRIM(Notes)
			.Notes.LEFT = 2
			.Notes.TOP = .LABEL.TOP + .LABEL.HEIGHT +2
			.Notes.WIDTH = .WIDTH - IIF(.Chart.VISIBLE,.Chart.WIDTH,0) -3
			.Notes.VISIBLE = .T.

			.ADDOBJECT ('cmdEdit', 'CommandButton')
			.cmdEdit.CAPTION = "Edit..."
			.cmdEdit.WIDTH = 60
			.cmdEdit.LEFT = .WIDTH - .Chart.WIDTH - .cmdEdit.WIDTH -1
			.cmdEdit.VISIBLE=.T.
			BINDEVENT(.cmdEdit,'Click', THIS, 'Edit')

			.ADDOBJECT ('cmdRun', 'CommandButton')
			.cmdRun.CAPTION = "Run..."
			.cmdRun.WIDTH = 60
			.cmdRun.LEFT = .WIDTH - .Chart.WIDTH - .cmdEdit.WIDTH  - .cmdRun.WIDTH -1
			.cmdRun.VISIBLE=.T.
			BINDEVENT(.cmdRun,'Click', THIS, 'Run')

		ENDWITH

	FUNCTION RUN
		SELECT samples1_4x
		GO THIS.RECNO
		IF NOT EMPTY(Runcmd)
			=EXECSCRIPT(Runcmd)
		ENDIF
	FUNCTION Edit
		SELECT samples1_4x
		GO THIS.RECNO
		IF NOT EMPTY(Editcmd)
			=EXECSCRIPT(Editcmd)
		ENDIF
ENDDEFINE

