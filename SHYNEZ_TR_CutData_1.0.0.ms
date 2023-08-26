--Anime Cut Data
--author: shynez.com
--version 1.0
fileIn "SHYNEZ_TR_Util.ms"

if Util_IsScriptUIOpen "SHYNEZ_TR_CutData" do (
      return print "The script instance is already open."
)
Util_AddScriptUIOpenState "SHYNEZ_TR_CutData"


-- data
-- save format SOE #12_C102_F036_3D-Lo
TR_DATA_TITLE = "WITCH"
TR_DATA_EPISODE = "01"
TR_DATA_SCENE = "00"
TR_DATA_CUTNO = "001"
TR_DATA_TIMEFRAMES = "24"
TR_DATA_TYPE = "3D-Lo"

-- func
AttbFuncTBDataUpdate
AttbFuncTBDataRead
AttbFuncTBDataWrite
UpdateCutData

-- rollout
SHYNEZ_TR_CutData

rollout SHYNEZ_TR_CutData "Cut Data 1.0.0" (
    label attb_title ""
    group "卡数据" (
        label attb_title_text "标题：" across:6
        edittext attb_custom_title fieldWidth:80 offset:[-10,0]
        label attb_episode_text "集数：" offset:[22,0]
        edittext attb_episode fieldWidth:30 offset:[20,0]
        label attb_scene_text "场：" offset:[10,0]
        edittext attb_scene fieldWidth:40
        label attb_cut_no_text "卡号：" across:7 offset:[5,0]
        edittext attb_cut_no fieldWidth:40
        label attb_time_text "时长：" offset:[10,0]
        edittext attb_time_seconds fieldWidth:30 offset:[10,0]
        edittext attb_time_frames "+ " fieldWidth:30 offset:[0,0]
        label attb_frame_text "总帧数" offset:[0,0]
        label attb_total_frames "0" height:16 width:40 offset:[-5,0]
        
        on attb_custom_title changed theText do AttbFuncTBDataUpdate()
        on attb_episode changed theText do AttbFuncTBDataUpdate()
        on attb_scene changed theText do AttbFuncTBDataUpdate()
        on attb_cut_no changed theText do AttbFuncTBDataUpdate()
        on attb_time_seconds changed theText do (
            attb_time_seconds.text = Util_OnlyNumberLeft theText
            attb_total_frames.text = ((attb_time_seconds.text as integer)*24 + attb_time_frames.text as integer) as string
            
            AttbFuncTBDataUpdate()
        )
        on attb_time_frames changed theText do (
            attb_time_frames.text = Util_OnlyNumberLeft theText
            attb_total_frames.text = ((attb_time_seconds.text as integer)*24 + attb_time_frames.text as integer) as string

            AttbFuncTBDataUpdate()
        )
    )
	-- Buttons
	button btn_update "更新" width:360 height:40
	
	on btn_update pressed do (
		AttbFuncTBDataWrite()
		RefreshLayoutUIData()

		frameRate = 24
		animationRange = interval 1f (TR_DATA_TIMEFRAMES as float)
	)

	Label author "Author" align:#left across:2
	hyperLink authorLink "shynez语出" color:red hoverColor:red visitedColor:green address:"http://shynez.com/" align:#right

	on SHYNEZ_TR_CutData open do (
		AttbFuncTBDataRead()

		attb_title.text = TR_DATA_TITLE + "_" + TR_DATA_EPISODE + "_S" + TR_DATA_SCENE + "_C" + TR_DATA_CUTNO + "_F" + TR_DATA_TIMEFRAMES + "_" + TR_DATA_TYPE

		attb_custom_title.text = TR_DATA_TITLE
        attb_episode.text = TR_DATA_EPISODE
        attb_scene.text = TR_DATA_SCENE
		attb_cut_no.text = TR_DATA_CUTNO
		attb_time_seconds.text = ((TR_DATA_TIMEFRAMES as integer) / 24) as string
		attb_time_frames.text = ((mod (TR_DATA_TIMEFRAMES as integer) 24) as integer) as string
		attb_total_frames.text = TR_DATA_TIMEFRAMES
    )
    -- 0.2.1
    on SHYNEZ_TR_CutData close do (
        Util_DeleteScriptUIOpenState "SHYNEZ_TR_CutData"
    )
)

fn AttbFuncTBDataUpdate = (
	TR_DATA_TITLE = SHYNEZ_TR_CutData.attb_custom_title.text
    TR_DATA_EPISODE = SHYNEZ_TR_CutData.attb_episode.text
    TR_DATA_SCENE = SHYNEZ_TR_CutData.attb_scene.text
	TR_DATA_CUTNO = SHYNEZ_TR_CutData.attb_cut_no.text
	TR_DATA_TIMEFRAMES = SHYNEZ_TR_CutData.attb_total_frames.text
	TR_DATA_TYPE = "3D-Lo"

	SHYNEZ_TR_CutData.attb_title.text = TR_DATA_TITLE + "_" + TR_DATA_EPISODE + "_S" + TR_DATA_SCENE + "_C" + TR_DATA_CUTNO + "_F" + TR_DATA_TIMEFRAMES + "_" + TR_DATA_TYPE
)

fn AttbFuncTBDataRead = (
	filePropCutData = fileProperties.findProperty #custom "com_shynez_CutData"

	if filePropCutData > 0 do (
		dataString = fileProperties.getPropertyValue #custom (fileProperties.findProperty #custom "com_shynez_CutData")
		data = filterString dataString "_"

		TR_DATA_TITLE = data[1]
		TR_DATA_EPISODE = data[2]
		TR_DATA_SCENE = substring data[3] 2 -1
		TR_DATA_CUTNO = substring data[4] 2 -1
		TR_DATA_TIMEFRAMES = substring data[5] 2 -1
		TR_DATA_TYPE = data[6]

		-- test
		--print TR_DATA_TITLE
		--print TR_DATA_EPISODE
		--print TR_DATA_CUTNO
		--print TR_DATA_TIMEFRAMES
		--print TR_DATA_TYPE
	)
)

fn AttbFuncTBDataWrite = (
	if true do (
		fileProperties.addProperty #custom "com_shynez_CutData" SHYNEZ_TR_CutData.attb_title.text
	)
)

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

createDialog SHYNEZ_TR_CutData height:160 width:400