--Anime Layout Frame
--author: shynez.com
--version 2.3.0
fileIn "SHYNEZ_TR_Util.ms"


if Util_IsScriptUIOpen "SHYNEZ_TR_LoFrame" do (
    return print "The script instance is already open.\nTry Execute This Script: \nUtil_DeleteScriptUIOpenState \"SHYNEZ_TR_LoFrame\"\n"
)
Util_AddScriptUIOpenState "SHYNEZ_TR_LoFrame"

-- 200 DPI
-- !!! 按格式改名
LO_BM_WIDTH = 160
LO_BM_HEIGHT = 180

layoutFrameWidth_single_DPI200 = 2000
layoutFrameHeight_single_DPI200 = 1124

layoutFrameMarginTop_DPI200 = 350
layoutFrameMarginBottom_DPI200 = 180
layoutFrameMarginLeft_DPI200 = 172
layoutFrameMarginRight_DPI200 = 168

layoutFrameRatioWidth = 16.0
layoutFrameRatioHeight = 9.0

layoutFrameWidth_DPI200 = 2000
layoutFrameHeight_DPI200 = 1124

-- 
isCreated
phys
rect

bmActive
bmMargin
bmBg
bmSnap

snapPoints
finalFramePosition = [LO_BM_WIDTH/2-1,LO_BM_HEIGHT/4-1]
layoutFrameScale = [1,1,1]
readCutData
scaleRatio
frameDist
last_lens_shift_h
last_lens_shift_v
working_date

-- cut data
TR_DATA_Title = "XYMY"
TR_DATA_Scene = "00"
TR_DATA_Episode = "00"
TR_DATA_CutNo = "001"
TR_DATA_TimeFrames = "0"
TR_DATA_Type = "3D-Lo"
TR_DATA_FocalLength = "50"
TR_DATA_DATE = ""

-- fn
InitLoBitmap
DrawMargin
InitSnapPoints
GetSnapPos
UpdateLoImgtag
UpdateLoImgTagSnap
UpdateCutData

-- rollout
SHYNEZ_TR_LoFrame

-- rollout ui imgtag
fn InitLoBitmap = (
    bmActive = bitmap LO_BM_WIDTH LO_BM_HEIGHT color:(color 160 0 0)
    bmMargin = bitmap LO_BM_WIDTH LO_BM_HEIGHT color:(color 128 255 255)
    bmBg = bitmap LO_BM_WIDTH LO_BM_HEIGHT color:(color 80 165 165)
    bmSnap = bitmap 8 4 color:(color 128 255 255)
    pasteBitmap (bitmap 4 4 color:white) bmSnap (box2 0 0 4 4) [4,0]
)

fn DrawMargin = (
    pasteBitmap bmMargin bmBg (box2 0 0 LO_BM_WIDTH 1) [0,0]
    pasteBitmap bmMargin bmBg (box2 0 0 LO_BM_WIDTH 2) [0,LO_BM_HEIGHT/4-1]
    pasteBitmap bmMargin bmBg (box2 0 0 LO_BM_WIDTH 2) [0,LO_BM_HEIGHT/2-1]
    pasteBitmap bmMargin bmBg (box2 0 0 LO_BM_WIDTH 2) [0,LO_BM_HEIGHT*3/4-1]
    pasteBitmap bmMargin bmBg (box2 0 0 LO_BM_WIDTH 1) [0,LO_BM_HEIGHT-1]
    pasteBitmap bmMargin bmBg (box2 0 0 1 LO_BM_HEIGHT) [0,0]
    pasteBitmap bmMargin bmBg (box2 0 0 2 LO_BM_HEIGHT) [LO_BM_WIDTH/2-1,0]
    pasteBitmap bmMargin bmBg (box2 0 0 1 LO_BM_HEIGHT) [LO_BM_WIDTH-1,0]
)

fn InitSnapPoints = (
    snapPoints = #()
    snapUnit = [LO_BM_WIDTH/4.0,LO_BM_HEIGHT/8.0]
    for x = 2 to 4 do (
        for y = 2 to 8 do (
            append snapPoints [snapUnit.x * x - 1, snapUnit.y * y - 1]
        )
    )

    UpdateLoImgTagSnap [0,0]
)

fn GetSnapPos pos = (
    returnPos = pos
    snapDistance = 9999
    for p in snapPoints do (
        dist = distance pos p
        if dist < snapDistance do (
            snapDistance = dist
            returnPos = p
        )
    )
    returnPos
)

fn UpdateLoImgtag pos = (
    InitLoBitmap()
    pasteBitmap bmActive bmBg (box2 0 0 (pos.x+1) (pos.y+1)) [0,0]
    DrawMargin()

    SHYNEZ_TR_LoFrame.imgtag_lo_area.bitmap = bmBg
)

fn UpdateLoImgTagSnap pos = (
    for p in snapPoints do (
        pasteBitmap bmSnap bmBg (box2 0 0 4 4) [p.x-2,p.y-2]
    )
    pasteBitmap bmSnap bmBg (box2 4 0 4 4) [pos.x-2,pos.y-2]

    SHYNEZ_TR_LoFrame.imgtag_lo_area.bitmap = bmBg
)

-- Read cut data
fn ReadCutData = (
    filePropCutData = fileProperties.findProperty #custom "com_shynez_CutData"
    
    if filePropCutData > 0 do (
        dataString = fileProperties.getPropertyValue #custom (fileProperties.findProperty #custom "com_shynez_CutData")
        data = filterString dataString "_"
    
        TR_DATA_Title = data[1]
        TR_DATA_Episode = data[2]
        TR_DATA_Scene = substring data[3] 2 -1
        TR_DATA_CutNo = substring data[4] 2 -1
        TR_DATA_TimeFrames = substring data[5] 2 -1
        TR_DATA_Type = data[6]
        if isValidNode phys do TR_DATA_FocalLength = ((phys.focal_length_mm + 0.5) as integer) as string
    )
)
-- readCutData()

fn InitIfIsValidNode = (
if isValidNode $TR_LO_Phys_Camera and isValidNode $TR_LO_Frame then
	(
		layoutFrameWidth_DPI200 = renderwidth
		layoutFrameHeight_DPI200 = renderheight
		phys = $TR_LO_Phys_Camera
        rect = $TR_LO_Frame
        isCreated = true
	) else isCreated = false
)
InitIfIsValidNode()

callbacks.removeScripts id:#SaveParamsOnFileSave
callbacks.removeScripts id:#SeadParamsOnFileOpen

fn CreateLayoutFrame = (
	outl = Rectangle width:(layoutFrameWidth_single_DPI200+layoutFrameMarginLeft_DPI200+layoutFrameMarginRight_DPI200) length:(layoutFrameHeight_single_DPI200+layoutFrameMarginTop_DPI200+layoutFrameMarginBottom_DPI200) pos:[-(layoutFrameMarginLeft_DPI200-layoutFrameMarginRight_DPI200)/2.0,(layoutFrameMarginTop_DPI200-layoutFrameMarginBottom_DPI200)/2.0,0] name:"TR_LO_Outline" wirecolor:yellow
	outl.render_renderable = false
	rect = Rectangle width:layoutFrameWidth_single_DPI200 length:layoutFrameHeight_single_DPI200 name:"TR_LO_Frame" wirecolor:red
	rect.render_renderable = true
	rect.render_thickness = 3
	rect.objectoffsetpos += [1000,-562,0]
	move rect [-1000,562,0]
	sphe = Sphere radius:25 pos:[-4,830,0] name:"TR_LO_PF_Hole" wirecolor:white
	sphe.scale = [1,1,0.1]
	caps_left = Capsule radius:11 height:103 pos:[-871,830,0] name:"TR_LO_PF_left_Hole" wirecolor:white
	caps_left.scale = [0.1,1,1]
	rotate caps_left (angleaxis 90 [0,1,0])
	caps_right = Capsule radius:11 height:103 pos:[738,830,0] name:"TR_LO_PF_right_Hole" wirecolor:white
	caps_right.scale = [0.1,1,1]
	rotate caps_right (angleaxis 90 [0,1,0])
	rect_left = Plane width:218 length:94 pos:[-813,823,0] name:"TR_LO_PF_left_Bg" wirecolor:black
	rect_right = Plane width:218 length:94 pos:[803,823,0] name:"TR_LO_PF_right_Bg" wirecolor:black
	sphe_rect = Plane width:134 length:94 pos:[-4,823,0] name:"TR_LO_PF_Bg" wirecolor:black
	td_text = text size:100 pos:[1036,-700,0] name:"TR_LO_LOGO" text:"震雷" font:"微软雅黑" wirecolor:red
    addModifier td_text (Turn_to_Poly())

    ProBoolean.createBooleanObject sphe_rect sphe 2 0 0
    ProBoolean.setCookieCut sphe_rect true
    ProBoolean.setUpdateMode sphe_rect 2
    ProBoolean.createBooleanObject rect_left caps_left 2 0 0
    ProBoolean.setCookieCut rect_left true
    ProBoolean.setUpdateMode rect_left 2
    ProBoolean.createBooleanObject rect_right caps_right 2 0 0
    ProBoolean.setCookieCut rect_right true
    ProBoolean.setUpdateMode rect_right 2

    -- Cut Data
    title_text = text size:66 pos:[-880,646,0] name:"TR_LO_T_TITLE" text:("TITLE. " + TR_DATA_Title) font:"微软雅黑" wirecolor:red
    addModifier title_text (Turn_to_Poly())
    epNo_text = text size:66 pos:[-550,646,0] name:"TR_LO_T_EPNO" text:("NO. " + TR_DATA_Episode) font:"微软雅黑" wirecolor:red
    addModifier epNo_text (Turn_to_Poly())
    Scene_text = text size:66 pos:[240,646,0] name:"TR_LO_T_SCENE" text:("S. " + TR_DATA_Scene) font:"微软雅黑" wirecolor:red
    addModifier Scene_text (Turn_to_Poly())
    cutNo_text = text size:66 pos:[480,646,0] name:"TR_LO_T_CUTNO" text:("C. " + TR_DATA_CutNo) font:"微软雅黑" wirecolor:red
    addModifier cutNo_text (Turn_to_Poly())
    tf_sec = ((TR_DATA_TimeFrames as integer) / 24) as string
    tf_fra = ((mod (TR_DATA_TimeFrames as integer) 24) as integer) as string
    timeFrames_text = text size:66 pos:[840,646,0] name:"TR_LO_T_TIME" text:("TIME ( " + tf_sec + " +  " + tf_fra + ")") font:"微软雅黑" wirecolor:red
    addModifier timeFrames_text (Turn_to_Poly())
    focalLength_text = text size:66 pos:[-150,646,0] name:"TR_LO_T_LENS" text:("LEN. " + TR_DATA_FocalLength + "mm") font:"微软雅黑" wirecolor:red
    addModifier focalLength_text (Turn_to_Poly())
    
    date_string = localTime
    date_text = text size:66 pos:[-680,-670,0] name:"TR_LO_T_DATE" text:("DATE. " + date_string) font:"微软雅黑" wirecolor:black
    addModifier date_text (Turn_to_Poly())
    
    mask_left = Plane width:layoutFrameMarginLeft_DPI200 length:layoutFrameHeight_single_DPI200 pos:[-(layoutFrameWidth_single_DPI200+layoutFrameMarginLeft_DPI200)/2.0,0,-1] name:"TR_LO_Mask_Left" wirecolor:white
    mask_right = Plane width:layoutFrameMarginRight_DPI200 length:layoutFrameHeight_single_DPI200 pos:[(layoutFrameWidth_single_DPI200+layoutFrameMarginRight_DPI200)/2.0,0,-1] name:"TR_LO_Mask_Right" wirecolor:white
    mask_top = Plane width:(layoutFrameWidth_single_DPI200+layoutFrameMarginLeft_DPI200+layoutFrameMarginRight_DPI200) length:layoutFrameMarginTop_DPI200 pos:[-2,(layoutFrameHeight_single_DPI200+layoutFrameMarginTop_DPI200)/2.0,-1] name:"TR_LO_Mask_Top" wirecolor:white
    mask_bottom = Plane width:(layoutFrameWidth_single_DPI200+layoutFrameMarginLeft_DPI200+layoutFrameMarginRight_DPI200) length:layoutFrameMarginBottom_DPI200 pos:[-2,-(layoutFrameHeight_single_DPI200+layoutFrameMarginBottom_DPI200)/2.0,-1] name:"TR_LO_Mask_Bottom" wirecolor:white
	mask_left.renderable = off
	mask_left.lengthsegs = 1
	mask_left.widthsegs = 1
	mask_right.renderable = off
	mask_right.lengthsegs = 1
	mask_right.widthsegs = 1
	mask_top.renderable = off
	mask_top.lengthsegs = 1
	mask_top.widthsegs = 1
	mask_bottom.renderable = off
	mask_bottom.lengthsegs = 1
	mask_bottom.widthsegs = 1
	
    stdMat = standard()
    stdMat.diffuse = [0,0,0]
    stdMat.selfIllumAmount = 100
    select #(sphe_rect, rect_left, rect_right, date_text)
    selection.material = stdMat

    stdMat = standard()
    stdMat.diffuse = [255,0,0]
    stdMat.selfIllumAmount = 100
    select #(title_text, epNo_text, Scene_text, cutNo_text, timeFrames_text, focalLength_text, td_text)
    selection.material = stdMat
    
    stdMat = standard()
    stdMat.diffuse = [255,255,255]
    stdMat.selfIllumAmount = 100
    select #(mask_left, mask_right, mask_top, mask_bottom)
    selection.material = stdMat

	outl.parent = rect
	-- sphe.parent = rect
	-- caps_left.parent = rect
	-- caps_right.parent = rect
	rect_left.parent = rect
	rect_right.parent = rect
	sphe_rect.parent = rect
    td_text.parent = rect

    -- Cut Data
    title_text.parent = rect
    epNo_text.parent = rect
    Scene_text.parent = rect
    cutNo_text.parent = rect
    timeFrames_text.parent = rect
    focalLength_text.parent = rect
    date_text.parent = rect

    mask_left.parent = rect
    mask_right.parent = rect
    mask_top.parent = rect
    mask_bottom.parent = rect

	freeze rect
	freeze rect.children
	
	rect.showFrozenInGray = false
	rect.children.showFrozenInGray = false
)

fn CreatePhysCameraNAlignLayoutFrame = (
	phys = Physical name:"TR_LO_Phys_Camera" targeted:off
	--phys.focal_length_mm = 50
	phys.fov = 40
	phys.specify_fov = true
	phys.horizon_on = on
	phys.horizontal_shift = 0
	phys.vertical_shift = 0
	
    if SHYNEZ_TR_LoFrame.checkbox_reset_view.checked do (
        viewport.resetAllViews()
        
        viewport.setType #view_persp_user
        if viewport.numViews > 1 then actionMan.executeAction 0 "50026"
    )
    perspXForm = Inverse(viewport.getTM())
    phys.Transform = perspXForm
    
    if isValidNode $TR_LO_T_LENS do
        $TR_LO_T_LENS.text = "LEN. " + ((floor (phys.focal_length_mm + 0.5)) as integer) as string + "mm"
)

fn CalcFramePos fovAngle d1 x0 y0 loFrameWidth loFrameHeight = (
	--format "params:%,%,%,%,%,%" fovAngle d1 x0 y0 loFrameWidth loFrameHeight
	d0 = loFrameWidth/(2.0*(tan (fovAngle/2.0)))
	--print ("d0: "+(d0 as string))
	scaleRatio = d0/d1
	--format "scale ratio: %d\n"+scaleRatio
	return #([(x0-loFrameWidth/2.0)/scaleRatio,-(y0-loFrameHeight/2.0)/scaleRatio],scaleRatio)
)

fn LensShiftingPhys = (
    phys.horizontal_shift = SHYNEZ_TR_LoFrame.lens_shift_horizontal.value
    phys.vertical_shift = SHYNEZ_TR_LoFrame.lens_shift_vertical.value
)

fn UpdatePhys = (
	if isValidNode phys do (
		phys.specify_fov = true
        phys.fov = SHYNEZ_TR_LoFrame.cam_fov.value
        LensShiftingPhys()
		viewport.setCamera phys
	)
)

fn LensShiftingRect = (
    if isValidNode rect do (
        in coordsys local move rect [-layoutFrameWidth_DPI200*(SHYNEZ_TR_LoFrame.lens_shift_horizontal.value-last_lens_shift_h)/100,-layoutFrameWidth_DPI200*(SHYNEZ_TR_LoFrame.lens_shift_vertical.value-last_lens_shift_v)/100,0]	

        last_lens_shift_h = SHYNEZ_TR_LoFrame.lens_shift_horizontal.value
        last_lens_shift_v = SHYNEZ_TR_LoFrame.lens_shift_vertical.value
    )
)

fn UpdateRenderSize = (
    layoutFrameWidth_DPI200 = layoutFrameWidth_single_DPI200*2 * ((finalFramePosition.x+1) / LO_BM_WIDTH)
    layoutFrameHeight_DPI200 = layoutFrameHeight_single_DPI200*4 * ((finalFramePosition.y+1) / LO_BM_HEIGHT)

    layoutFrameWidth_DPI200 += layoutFrameMarginLeft_DPI200 + layoutFrameMarginRight_DPI200
    layoutFrameHeight_DPI200 += layoutFrameMarginTop_DPI200 + layoutFrameMarginBottom_DPI200
)

fn UpdateLayoutFrame = (
	setTransformLockFlags rect #none
	rect.pos = phys.pos
	rect.scale = [1,1,1]
	--print SHYNEZ_TR_LoFrame
	calcResult = CalcFramePos phys.fov frameDist layoutFrameMarginLeft_DPI200 layoutFrameMarginTop_DPI200 layoutFrameWidth_DPI200 layoutFrameHeight_DPI200
	
	--format "Calc Result: %\n" calcResult
	in coordsys parent move rect [calcResult[1].x,calcResult[1].y,-frameDist]
	in coordsys local scale rect [layoutFrameScale.x/calcResult[2],layoutFrameScale.y/calcResult[2],layoutFrameScale.z/calcResult[2]]

	LensShiftingRect()

    if isValidNode $TR_LO_T_LENS do
        $TR_LO_T_LENS.text = "LEN. " + ((floor (phys.focal_length_mm + 0.5)) as integer) as string + "mm"

	if isValidNode $TR_LO_T_DATE do
		$TR_LO_T_DATE.text = "DATE. " + localTime
)

fn UpdateRollout = (
	if isCreated and SHYNEZ_TR_LoFrame != undefined and (GetDialogSize SHYNEZ_TR_LoFrame).x > 0 do (
		SHYNEZ_TR_LoFrame.frame_dist_spin.value = frameDist
		phys.specify_fov = true
		SHYNEZ_TR_LoFrame.cam_fov.value = phys.fov
		SHYNEZ_TR_LoFrame.lens_shift_horizontal.value = phys.horizontal_shift
		SHYNEZ_TR_LoFrame.lens_shift_vertical.value = phys.vertical_shift
	)
)

fn ReadParamsOnFileOpen = (
	filePropParams = fileProperties.findProperty #custom "com_shynez_AdvancedLayout_params"
	if filePropParams > 0 do (
		params = execute(fileProperties.getPropertyValue #custom filePropParams)
		if params != undefined do (
			finalFramePosition = params[1]
			scale_ratio = params[2] as float
			frameDist = params[3] as float
			last_lens_shift_h = params[4] as float
            last_lens_shift_v = params[5] as float

            InitIfIsValidNode()
            
            UpdateLoImgtag finalFramePosition
            UpdateLoImgTagSnap finalFramePosition
			UpdateRollout()
		)
	)
)
callbacks.addScript #filePostOpen "ReadParamsOnFileOpen()" id:#ReadParamsOnFileOpen

-- Refresh Layout UI Data
fn RefreshLayoutUIData = (
    readCutData()
    if isValidNode $TR_LO_T_TITLE do
        $TR_LO_T_TITLE.text = "TITLE. " + TR_DATA_Title
    if isValidNode $TR_LO_T_EPNO do
        $TR_LO_T_EPNO.text = "NO. " + TR_DATA_Episode
    if isValidNode $TR_LO_T_SCENE do
        $TR_LO_T_SCENE.text = "S. " + TR_DATA_Scene
    if isValidNode $TR_LO_T_CUTNO do
        $TR_LO_T_CUTNO.text = "C. " + TR_DATA_CutNo
    if isValidNode $TR_LO_T_LENS do
        $TR_LO_T_LENS.text = "LEN. " + TR_DATA_FocalLength + "mm"
	if isValidNode $TR_LO_T_DATE do
		$TR_LO_T_DATE.text = "DATE. " + localTime

    if isValidNode $TR_LO_T_TIME do (
        tf_sec = ((TR_DATA_TimeFrames as integer) / 24) as string
        tf_fra = ((mod (TR_DATA_TimeFrames as integer) 24) as integer) as string
        $TR_LO_T_TIME.text = "TIME ( " + tf_sec + " +  " + tf_fra + ")"
    )
)

fn SaveParamsOnFileSave = (
	params = #()
	params[1] = if finalFramePosition == undefined then 1 else finalFramePosition
	params[2] = if scale_ratio == undefined then 1 else scale_ratio
	params[3] = if frameDist == undefined then 10 else frameDist
	params[4] = if last_lens_shift_h == undefined then 0 else last_lens_shift_h
	params[5] = if last_lens_shift_v == undefined then 0 else last_lens_shift_v
	params[8] = localTime
	
	fileProperties.addProperty #custom "com_shynez_AdvancedLayout_params" (params as string)

	-- Refresh Layout UI Data
	refreshLayoutUIData()
)
callbacks.addScript #filePreSave "saveParamsOnFileSave()" id:#saveParamsOnFileSave

rollout SHYNEZ_TR_LoFrame "3D Layout 2.3.0" (
    button btn_cut_data "更新卡数据" width:180 height:34
    on btn_cut_data pressed do (
        fileIn "SHYNEZ_TR_CutData_WITCH_1.0.0.ms"
    )

    group "点击选区（右键可吸附）" (
        imgtag imgtag_lo_area "Lo Area" bitmap:bmBg align:#center
        
        on imgtag_lo_area lbuttondown pos btnState do (
            if pos.x < 79 do pos.x = 79
            if pos.y < 44 do pos.y = 44
    
            UpdateLoImgtag pos
            UpdateLoImgTagSnap pos

            finalFramePosition = pos
        )
        on imgtag_lo_area rbuttondown pos btnState do (
            pos = GetSnapPos pos
    
            UpdateLoImgtag pos
            UpdateLoImgTagSnap pos

            finalFramePosition = pos
        )
    )
    
    spinner frame_dist_spin "与摄像机距离" range:[0,100,10]
    checkbox checkbox_reset_view "重置视口"

    button rua "创建" width:180 height:40
    checkbox hide_mask "隐藏框外遮挡"
    on hide_mask changed value do (
        if hide_mask.checked then (
            if isValidNode $TR_LO_Mask_Left do $TR_LO_Mask_Left.isHidden = true
            if isValidNode $TR_LO_Mask_Right do $TR_LO_Mask_Right.isHidden = true
            if isValidNode $TR_LO_Mask_Top do $TR_LO_Mask_Top.isHidden = true
            if isValidNode $TR_LO_Mask_Bottom do $TR_LO_Mask_Bottom.isHidden = true
        ) else (
            if isValidNode $TR_LO_Mask_Left do $TR_LO_Mask_Left.isHidden = false
            if isValidNode $TR_LO_Mask_Right do $TR_LO_Mask_Right.isHidden = false
            if isValidNode $TR_LO_Mask_Top do $TR_LO_Mask_Top.isHidden = false
            if isValidNode $TR_LO_Mask_Bottom do $TR_LO_Mask_Bottom.isHidden = false
        )
    )

    group "Lo摄像机参数" (
		spinner cam_fov "Fov: (Deg)" range:[10,100,40]
		on cam_fov changed value do (
            last_lens_shift_h = 0
            last_lens_shift_v = 0
			UpdatePhys()
            UpdateLayoutFrame()
		)
		spinner lens_shift_horizontal "Shift H: (%)" range:[-800,800,0]
		on lens_shift_horizontal changed value do (
            LensShiftingPhys()
            LensShiftingRect()
		)
		spinner lens_shift_vertical "Shift V: (%)" range:[-800,800,0]
		on lens_shift_vertical changed value do (
            LensShiftingPhys()
            LensShiftingRect()
		)
    )
    button frame_movement "激活移动" width:166
    on frame_movement pressed do (
		if isValidNode rect do (
			macros.run "Tools" "Move"
			macros.run "Coordinate System" "Coordsys_Local"
			setTransformLockFlags rect #{3,4,5,6}
			select rect
		)
    )
    
	label author "Author" align:#left across:2
	hyperLink author_link "shynez语出" color:red hoverColor:red visitedColor:green address:"http://shynez.com/" align:#right

    -- main
    on rua pressed do (
        backgroundColor = color 255 255 255
        frameDist = frame_dist_spin.value

        clearselection()

        if not isCreated then (
            CreateLayoutFrame()
            lens_shift_horizontal.value = 0
            lens_shift_vertical.value = 0
            CreatePhysCameraNAlignLayoutFrame()
        ) else (
            -- perspXForm = Inverse(viewport.getTM())
            -- $TR_LO_Phys_Camera.Transform = perspXForm
        )
        
        --Update width height
        UpdateRenderSize()

        rect.Transform = phys.Transform
        rect.parent = phys
		
        last_lens_shift_h = 0
		last_lens_shift_v = 0
		
		phys.horizontal_shift = 0
		phys.vertical_shift = 0
		
		UpdateLayoutFrame()

        renderwidth = layoutFrameWidth_DPI200
		renderheight = layoutFrameHeight_DPI200
		
		displaySafeFrames = true
        viewport.setCamera phys
        
		cam_fov.value = phys.fov

		LensShiftingPhys()
		
        isCreated = true
        
        UpdateLoImgtag finalFramePosition
        UpdateLoImgTagSnap finalFramePosition
	)

    -- rollout
	on SHYNEZ_TR_LoFrame open do
	(
		ReadParamsOnFileOpen()
		if isCreated do
		(
            UpdateLoImgtag finalFramePosition
            UpdateLoImgTagSnap finalFramePosition
			UpdateRollout()
		)
    )
    
    on SHYNEZ_TR_LoFrame close do (
        -- !!! release bitmap memory

        Util_DeleteScriptUIOpenState "SHYNEZ_TR_LoFrame"
    )
)

RefreshLayoutUIData()
InitLoBitmap()
DrawMargin()
InitSnapPoints()
createDialog SHYNEZ_TR_LoFrame width:200 height:480 pos:[750,250] style:#(#style_titlebar, #style_border, #style_sysmenu)

cui.RegisterDialogBar SHYNEZ_TR_LoFrame