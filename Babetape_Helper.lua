script_version(1.0)
script_author = "Tape"

local imgui = require 'imgui'
local memory = require 'memory'
local encoding = require 'encoding'
local inicfg = require 'inicfg'
local hook = require 'lib.samp.events'
local fa = require 'fAwesome5'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local LAST_VERSION = '1.0'

local sw,sh = getScreenResolution()

local fa_font = nil
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })
function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig()
        font_config.MergeMode = true

        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 13.0, font_config, fa_glyph_ranges)
    end
end

local inicfg = require('inicfg')
local directIni = "Babetape Helper.ini"
local mainIni = inicfg.load({
config =
{
dmg = false,
tlf = false,
arm = false,
msk = false,
lock = false,
jlock = false,
fcar = false,
recar = false,
key = false,
style = false,
acd = false,
zz = false,
pizza = false,
drugs = false,
olock = false,
weather = "1",
lockweather = false,
}
}, directIni)
inicfg.save(mainIni, directIni)

function save()
    inicfg.save(mainIni, directIni)
end

local tlf = imgui.ImBool(mainIni.config.tlf)
local arm = imgui.ImBool(mainIni.config.arm)
local msk = imgui.ImBool(mainIni.config.msk)
local lock = imgui.ImBool(mainIni.config.lock)
local dmg = imgui.ImBool(mainIni.config.dmg)
local slider = imgui.ImInt(15000)
local jlock = imgui.ImBool(mainIni.config.jlock)
local fcar = imgui.ImBool(mainIni.config.fcar)
local recar = imgui.ImBool(mainIni.config.recar)
local key = imgui.ImBool(mainIni.config.key)
local style = imgui.ImBool(mainIni.config.style)
local zz = imgui.ImBool(mainIni.config.zz)
local olock = imgui.ImBool(mainIni.config.olock)
local acd = imgui.ImBool(mainIni.config.acd)
local pizza = imgui.ImBool(mainIni.config.pizza)
local drugs = imgui.ImBool(mainIni.config.drugs)
local blockweather = imgui.ImBool(mainIni.config.lockweather)

local status = inicfg.load(mainIni, 'Babetape Helper.ini')
if not doesFileExist('moonloader/config/Babetape Helper.ini') then inicfg.save(mainIni, 'Babetape Helper.ini') end

local main_window_state = imgui.ImBool(false)
local created = false

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
		imgui.Process = false
	sampAddChatMessage("{42AAFF}[Babetape Helper] {ffffff}Загружен!", -1)	
	sampAddChatMessage("{42AAFF}[Babetape Helper] {ffffff}Активация: {42AAFF}/bbth. {FFFFFF}Автор: {42AAFF}Tape", -1)	
	sampRegisterChatCommand("acl",clean)
	sampRegisterChatCommand("bbth", function()		
      main_window_state.v = not main_window_state.v
	end)
	autoupdate("https://github.com/TapeTheft/bbth/raw/main/update.json", '['..string.upper(thisScript().name)..']: ', "https://github.com/TapeTheft/bbth/raw/main/update.json")
	while true do
		wait(0)
		imgui.Process = main_window_state.v
		if tlf.v and wasKeyPressed(0x50) and not sampIsCursorActive() then
			sampSendChat("/phone")
		end
		if arm.v then
			if testCheat("arm") and not sampIsChatInputActive() then
				sampSendChat("/armour")
			end
		end
		if msk.v then
			if testCheat("mask") and not sampIsCursorActive() then
				sampSendChat("/mask")
			end
		end
		if olock.v and not sampIsChatInputActive() then
			if testCheat("ol") then
				sampSendChat("/olock")
			end
		end
		if jlock.v and not sampIsChatInputActive() then
			if testCheat("jl") then
				sampSendChat("/jlock")
			end
		end
		if lock.v and not sampIsChatInputActive() then
			if testCheat("l") then
				sampSendChat("/lock")
			end
		end
		if drugs.v and not sampIsCursorActive() then
			if wasKeyPressed(0x61) and isKeyDown(0x12) then
                sampSendChat("/usedrugs 1")
            end
            if wasKeyPressed(0x62) and isKeyDown(0x12) then
                sampSendChat("/usedrugs 2")
            end
            if wasKeyPressed(0x63) and isKeyDown(0x12) then
                sampSendChat("/usedrugs 3")
			end
		end
		if fcar.v and not sampIsCursorActive() then
			if testCheat("can") then
				sampSendChat("/fillcar")
			end
		end
		if recar.v and not sampIsCursorActive() then
			if testCheat("recar") then
				sampSendChat("/repcar")
			end
		end
		if key.v then
			if testCheat("K") and isCharInAnyCar(PLAYER_PED) then
               sampSendChat("/key")
			end
		end
		if style.v then
		 	if testCheat("X") and isCharInAnyCar(PLAYER_PED) then
				sampSendChat("/style")
			 end
		end
		if mainIni.config.lockweather == true and mainIni.config.weather ~= memory.read(0xC81320, 1, false) then memory.write(0xC81320, mainIni.config.weather, 1, false) end
	end
end

function onScriptTerminate(script, quitGame)
	if script == thisScript() then
		if created then
			sampTextdrawDelete(2029)
		end
		save()
	end
end

function imgui.OnDrawFrame()
  		imgui.ShowCursor = main_window_state.v
  if main_window_state.v then
		imgui.SetNextWindowSize(imgui.ImVec2(410, 705), imgui.Cond.FirstUseEver)
		if not window_pos then
			ScreenX, ScreenY = getScreenResolution()ScreenX, ScreenY = getScreenResolution()
			imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		end

	  imgui.Begin('Babetape Helper', main_window_state, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)

	  	imgui.Text(u8"Очистка буффера: /acl")
			imgui.SameLine()
			imgui.TextQuestion(u8"Очищает память стрима, и вы начинаете играть как будто вы только запустили гта.")
			imgui.SetNextWindowPos(imgui.ImVec2((sw/2),sh/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5,0.5))
	        	imgui.BeginChild("##other_bar", imgui.ImVec2(380, 170), true)
			 imgui.Text(u8"Разное")			 
				imgui.Checkbox(u8"Переводить секунды в минуты в деморгане",dmg)
				mainIni.config.dmg = dmg.v
				save()
				imgui.SameLine()
				imgui.TextQuestion(u8"Вместо секунд теперь в деморгане будут показыватся минуты.")
				imgui.Checkbox(u8"Cкип диалога о ЗЗ", zz)
				mainIni.config.zz = zz.v
				save()
				imgui.SameLine()
				imgui.TextQuestion(u8"Как только скрипт увидит диалог с текстом 'Запрещено дратся' - он его пропустит.")
				imgui.Checkbox(u8"Cкип диалога о пицце", pizza)
				mainIni.config.pizza = pizza.v
				save()
				imgui.SameLine()
				imgui.TextQuestion(u8"Как только скрипт увидит диалог с текстом 'Вы успешно положили пиццу' - он его пропустит.")	
				if imgui.Checkbox(u8"Блокировка изменения погоды сервером", blockweather) then
					mainIni.config.lockweather = blockweather.v
					save()
                end		
	  	        imgui.EndChild()

				imgui.BeginChild("##car_bar", imgui.ImVec2(380, 298), true)
			imgui.Text(u8"Транспорт")
				imgui.Checkbox(u8"Закрытие транспорта", lock)
				mainIni.config.lock = lock.v
				save()
				imgui.SameLine()
				imgui.TextQuestion(u8"При нажатии на клавишу L вы закроете/откроете свой транспорт.")
				imgui.Checkbox(u8"Закрытие аренды", jlock)
				mainIni.config.jlock = jlock.v
				save()
				imgui.SameLine()
				imgui.TextQuestion(u8"При нажатии сочитаний клавиш JL вы откроете/закроете арендованный транспорт.")
				imgui.Checkbox(u8"Закрытие орг. т/с", olock)
				mainIni.config.olock = olock.v
				save()
				imgui.SameLine()
				imgui.TextQuestion(u8"При нажатии сочитаний клавиш OL вы откроете/закроете организационный транспорт.")
				imgui.Checkbox(u8"Ключи от авто", key)
				mainIni.config.key = key.v
				save()
				imgui.SameLine()
				imgui.TextQuestion(u8"При нажатии на клавишу K вы вставите/вытащите ключи.")
				imgui.Checkbox(u8"Стиль вождения", style)
				mainIni.config.style = style.v
				save()
				imgui.SameLine()
				imgui.TextQuestion(u8"При нажатии на клавишу X сменится стиль езды авто.")
				imgui.Checkbox(u8"Заправить авто", fcar)
				mainIni.config.fcar = fcar.v
				save()
				imgui.SameLine()
				imgui.TextQuestion(u8"При нажатии сочитаний клавиш CAN вы заправите транспорт используя канистру.")
				imgui.Checkbox(u8"Починить авто", recar)
				mainIni.config.recar = recar.v
				save()
				imgui.SameLine()
				imgui.TextQuestion(u8"При нажатии сочитани клавиш RECAR вы почините транспорт используя ремкомплект.")
				imgui.Checkbox(u8"Автозакрытие дверей", acd)
				mainIni.config.acd = acd.v
				save()
			    imgui.SameLine()
			    imgui.TextQuestion(u8"Как только скрипт увидит что вы словили авто по госсу он автоматически закроет двери авто.")
	  	        imgui.EndChild()
				  
	  	        imgui.BeginChild("##player_bar", imgui.ImVec2(380, 108), true)
			imgui.Text(u8"Персонаж")
				imgui.Checkbox(u8"Телефон", tlf)
				mainIni.config.tlf = tlf.v
				save()
				imgui.SameLine()
				imgui.TextQuestion(u8"При нажатии на клавишу P у вас откроется телефон.")
				imgui.SameLine()
				imgui.Checkbox(u8"Бронежилет", arm)
				mainIni.config.arm = arm.v
				save()
				imgui.SameLine()
				imgui.TextQuestion(u8"При нажатии сочетаний клавиш ARM вы оденете бронежилет.")
				imgui.Checkbox(u8"Маска", msk)
				mainIni.config.msk = msk.v
				save()
				imgui.SameLine()
				imgui.TextQuestion(u8"При нажатии сочетаний клавиш MASK вы оденете маску.")
				imgui.SameLine()
				imgui.Checkbox(u8"Наркотики", drugs)
				mainIni.config.drugs = drugs.v		
				save()
				imgui.SameLine()
				imgui.TextQuestion(u8"При нажатии сочетаний клавиш ALT + 1/2/3 (нумпад) вы используете наркотики.")
				imgui.SameLine()
				imgui.EndChild()

				imgui.Text(u8"Самый лучший промокод: #babetape") 

		    	imgui.SetCursorPos(imgui.ImVec2(370, 30))
		    	if imgui.Button(u8('')..fa.ICON_FA_RETWEET, imgui.ImVec2(25,25)) then
					sampAddChatMessage("{42AAFF}[Babetape Helper] {FFFFFF}Скрипт успешно перезапущен.", -1)
		    		reloadsc()
				end
				
				imgui.SetCursorPos(imgui.ImVec2(15, 680))
				if imgui.Link("https://www.youtube.com/c/KatsuBabetape", "Katsu Babetape") then
				end

				imgui.SetCursorPos(imgui.ImVec2(180, 680))
				if imgui.Link("https://discord.gg/x5tue8S", "Discord") then
				end

				imgui.SetCursorPos(imgui.ImVec2(345, 680))
				if imgui.Link("https://vk.com/katsu_babetape", "VK Group") then
				end
			imgui.End()
	    end
end

function hook.onServerMessage(color, message)
	if acd.v then
		if message:find("Поздравляем! Теперь этот транспорт принадлежит вам!") and not message:find('говорит') and not message:find('- |') then
			sampSendChat('/lock')
		end
	end
end

function reloadsc()
    lua_thread.create(function ()
			main_window_state.v = not main_window_state.v
			wait(30)
			thisScript():reload()
    end)
end

function clean()
    local huy = callFunction(0x53C500, 2, 2, true, true)
    local huy1 = callFunction(0x53C810, 1, 1, true)
    local huy2 = callFunction(0x40CF80, 0, 0)
    local huy3 = callFunction(0x4090A0, 0, 0)
    local huy4 = callFunction(0x5A18B0, 0, 0)
    local huy5 = callFunction(0x707770, 0, 0)
    local pX, pY, pZ = getCharCoordinates(PLAYER_PED)
    requestCollision(pX, pY)
    loadScene(pX, pY, pZ)
    sampAddChatMessage("{42AAFF}[Babetape Helper] {FFFFFF}Очистка произошла успешно!", -1)
end

function hook.onDisplayGameText(style, time, text)
	if dmg.v then
	    if style == 3 and time == 1000 and text:find("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed %d+ Sec%.") then
		  local c, _ = math.modf(tonumber(text:match("Jailed (%d+)")) / 60)
		  return {style, time, string.format("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~Jailed %s Sec = %s Min.", text:match("Jailed (%d+)"), c)}
		end
	end
end

function hook.onShowDialog(dialogId, dialogStyle, dialogTitle, okButtonText, cancelButtonText, dialogText)
	if zz.v then
	    if dialogText:find("В этом месте запрещено") then
			sampSendDialogResponse(dialogId,1,0,-1)
			return false
		end
	end
	if pizza.v then
	    if dialogText:find("Вы успешно положили") then
			sampSendDialogResponse(dialogId,1,0,-1)
			return false
		end
	end
	if tlf.v then
	   if dialogId == 1000 then
		   sampSendDialogResponse(dialogId,1,0,-1)
		   return false
	   end
	end
end

function onWindowMessage(msg, wparam, lparam)
    if (msg == 256 or msg == 257) and wparam == 27 and imgui.Process and not isPauseMenuActive() and not sampIsCursorActive() then
        consumeWindowMessage(true, true)
        if msg == 257 then
            main_window_state = imgui.ImBool(false)
        end
    end
end

function apply_custom_style()
	if not state then
  	imgui.SwitchContext()
  	local style = imgui.GetStyle()
   	local colors = style.Colors
   	local clr = imgui.Col
   	local ImVec4 = imgui.ImVec4
   	local ImVec2 = imgui.ImVec2
	   
		style.WindowPadding = ImVec2(15, 15)
		style.WindowRounding = 6.0
		style.FramePadding = ImVec2(5, 5)
		style.FrameRounding = 4.0
		style.ItemSpacing = ImVec2(12, 8)
		style.ItemInnerSpacing = ImVec2(8, 6)
		style.IndentSpacing = 25.0
		style.ScrollbarSize = 15.0
		style.ScrollbarRounding = 0.0
		style.GrabMinSize = 5.0
		style.GrabRounding = 3.0

		colors[clr.Text]                 = ImVec4(1.00, 1.00, 1.00, 1.00)
		colors[clr.TextDisabled]	     = ImVec4(0.45, 0.45, 0.45, 1.00)
		colors[clr.WindowBg] 		     = ImVec4(0.00, 0.10, 0.15, 0.95)
		colors[clr.ChildWindowBg] 	     = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.PopupBg]				 = ImVec4(0.00, 0.15, 0.25, 0.85)
		colors[clr.Border]				 = ImVec4(0.00, 0.25, 0.45, 1.00)
		colors[clr.BorderShadow]		 = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.FrameBg]			     = ImVec4(0.00, 0.25, 0.45, 0.55)
		colors[clr.FrameBgHovered]		 = ImVec4(0.00, 0.25, 0.45, 1.00)
		colors[clr.FrameBgActive]		 = ImVec4(0.00, 0.25, 0.45, 1.00)

		colors[clr.TitleBg]				 = ImVec4(0.00, 0.25, 0.45, 1.00)
		colors[clr.TitleBgCollapsed]	 = ImVec4(0.00, 0.25, 0.45, 1.00)
		colors[clr.TitleBgActive]		 = ImVec4(0.00, 0.25, 0.45, 1.00)

		colors[clr.MenuBarBg]			 = ImVec4(0.10, 0.09, 0.12, 1.00)
		colors[clr.ScrollbarBg]          = ImVec4(0.07, 0.07, 0.08, 0.53)
		colors[clr.ScrollbarGrab]        = ImVec4(0.15, 0.14, 0.17, 1.00)
		colors[clr.ScrollbarGrabHovered] = ImVec4(0.15, 0.14, 0.17, 1.00)
		colors[clr.ScrollbarGrabActive]  = ImVec4(0.17, 0.16, 0.19, 1.00)
		colors[clr.ComboBg]				 = ImVec4(0.50, 0.14, 0.15, 1.00)
		colors[clr.CheckMark]			 = ImVec4(0.00, 0.34, 0.52, 1.00)
		colors[clr.SliderGrab]			 = ImVec4(0.00, 0.25, 0.45, 1.00)
		colors[clr.SliderGrabActive]	 = ImVec4(0.00, 0.30, 0.50, 1.00)
		colors[clr.Button]				 = ImVec4(0.00, 0.25, 0.45, 0.85)
		colors[clr.ButtonHovered]		 = ImVec4(0.00, 0.27, 0.47, 1.00)
		colors[clr.ButtonActive]		 = ImVec4(0.00, 0.27, 0.47, 1.00)
		colors[clr.Header]				 = ImVec4(0.00, 0.25, 0.45, 1.00)
		colors[clr.HeaderHovered]		 = ImVec4(0.00, 0.25, 0.45, 1.00)
		colors[clr.HeaderActive]		 = ImVec4(0.00, 0.25, 0.45, 1.00)
		colors[clr.Separator]            = colors[clr.Border]
		colors[clr.SeparatorHovered]     = ImVec4(0.86, 0.86, 0.86, 1.00)
		colors[clr.SeparatorActive]      = ImVec4(0.86, 0.86, 0.86, 1.00)
		colors[clr.ResizeGrip]			 = ImVec4(1.00, 1.00, 1.00, 0.30)
		colors[clr.ResizeGripHovered]	 = ImVec4(1.00, 1.00, 1.00, 0.60)
		colors[clr.ResizeGripActive]	 = ImVec4(1.00, 1.00, 1.00, 0.90)
		colors[clr.CloseButton]			 = ImVec4(0.00, 0.20, 0.35, 1.00)
		colors[clr.CloseButtonHovered]	 = ImVec4(0.00, 0.10, 0.15, 0.95)
		colors[clr.CloseButtonActive]	 = ImVec4(0.00, 0.15, 0.20, 0.95)
		colors[clr.PlotLines]			 = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.PlotLinesHovered]	 = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.PlotHistogram]		 = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.PlotHistogramHovered] = ImVec4(0.00, 0.00, 0.00, 0.00)
		colors[clr.TextSelectedBg]		 = ImVec4(0.00, 0.25, 0.45, 1.00)
		colors[clr.ModalWindowDarkening] = ImVec4(0.00, 0.00, 0.00, 0.00)
	end
end
apply_custom_style()

function imgui.TextQuestion(text)
	imgui.TextDisabled('(?)')
	if imgui.IsItemHovered() then
		imgui.BeginTooltip()
		imgui.PushTextWrapPos(450)
		imgui.TextUnformatted(text)
		imgui.PopTextWrapPos()
		imgui.EndTooltip()
	end
end

function imgui.Link(link,name,myfunc)
    myfunc = type(name) == 'boolean' and name or myfunc or false
    name = type(name) == 'string' and name or type(name) == 'boolean' and link or link
    local size = imgui.CalcTextSize(name)
    local p = imgui.GetCursorScreenPos()
    local p2 = imgui.GetCursorPos()
    local resultBtn = imgui.InvisibleButton('##'..link..name, size)
    if resultBtn then
        if not myfunc then
            os.execute('explorer '..link)
        end
    end
    imgui.SetCursorPos(p2)
    if imgui.IsItemHovered() then
        imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.ButtonHovered], name)
        imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y + size.y), imgui.ImVec2(p.x + size.x, p.y + size.y), imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.ButtonHovered]))
    else
        imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.Button], name)
    end
    return resultBtn
end

function autoupdate(json_url, prefix, url)
	local dlstatus = require('moonloader').download_status
	local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
	if doesFileExist(json) then os.remove(json) end
	downloadUrlToFile(json_url, json,
	  function(id, status, p1, p2)
		if status == dlstatus.STATUSEX_ENDDOWNLOAD then
		  if doesFileExist(json) then
			local f = io.open(json, 'r')
			if f then
			  local info = decodeJson(f:read('*a'))
			  updatelink = info.updateurl
			  updateversion = info.latest
			  f:close()
			  os.remove(json)
			  if updateversion ~= thisScript().version then
				lua_thread.create(function(prefix)
				  local dlstatus = require('moonloader').download_status
				  local color = -1
				  sampAddChatMessage(('{42AAFF}[Babetape Helper] {FFFFFF}Обнаружено обновление. Пытаюсь обновиться c {42AAFF}'..thisScript().version..' {FFFFFF}на {42AAFF}'..updateversion), color)	
				  wait(250)
				  downloadUrlToFile(updatelink, thisScript().path,
					function(id3, status1, p13, p23)
					  if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
						print(string.format('Загружено %d из %d.', p13, p23))
					  elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
						print('Загрузка обновления завершена.')
						sampAddChatMessage(('{42AAFF}[Babetape Helper] {FFFFFF}Обновление завершено!'), color)
						goupdatestatus = true
						lua_thread.create(function() wait(500) thisScript():reload() end)
					  end
					  if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
						if goupdatestatus == nil then
						  sampAddChatMessage(('{42AAFF}[Babetape Helper] {FFFFFF}Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
						  update = false
						end
					  end
					end
				  )
				  end, prefix
				)
			  else
				update = false
				print('v'..thisScript().version..': Обновление не требуется.', -1)
			  end
			end
		  else
			print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно', -1)
			update = false
		  end
		end
	  end
	)
	while update ~= false do wait(100) end
  end
