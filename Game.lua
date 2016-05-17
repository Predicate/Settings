do
	local addon, namespace = ...
	_G[addon] = _G[addon] or {}
	setfenv(1, setmetatable(namespace, { __index = _G }))
end



local L = setmetatable({}, { __index = function(t, v) t[v] = BlankSlate.GetImports("Settings", v) or v; return t[v] end })

local locales = {}
do
	local localestrings = {
		deDE = "Deutsch",
		enGB = "English (EU)",
		enUS = "English",
		esES = "Castellano (Europa)",
		frFR = "Français",
		koKR = "한국어",
		zhCN = "简体中文",
		zhTW = "繁體中文",
		enCN = "简体中文（英文语音）",
		enTW = "繁體中文 (英文語音)",
		esMX = "Español (América Latina)",
		ruRU = "Русский",
		ptBR = "Português (Brasil)",
		ptPT = "Português (Brasil - UE)",
		itIT = "Italiano",
	}

	--VIDEO_OPTIONS_NEED_CLIENTRESTART
	local restartstrings = {
		deDE = "Das Ändern dieser Option führt dazu, dass der Client neu gestartet werden muss.",
		enGB = "Changing this option requires a client restart.",
		enUS = "Changing this option requires a client restart.",
		esES = "Cambiar esta opción requiere reiniciar el cliente.",
		frFR = "Changer cette option nécessite de relancer le programme.",
		koKR = "이 설정을 변경하면 클라이언트를 다시 시작해야 합니다",
		zhCN = "更改此选项需要重新启动客户端",
		zhTW = "改變這個選項需要重新啟動遊戲",
		enCN = "更改此选项需要重新启动客户端",
		enTW = "改變這個選項需要重新啟動遊戲",
		esMX = "Cambiar esta opción requiere reiniciar el cliente.",
		ruRU = "Изменение этого параметра потребует перезапуска игры.",
		ptBR = "É necessário reiniciar o cliente para que a alteração desta opção tenha efeito.",
		ptPT = "É necessário reiniciar o cliente para que a alteração desta opção tenha efeito.",
		itIT = "Modificare questa opzione richiede il riavvio del gioco.",
	}

	for _, v in ipairs({ GetAvailableLocales() }) do
		locales[v] = localestrings[v] or v
		L["RESTART_"..v] = restartstrings[v] or restartstrings.enUS
	end
end
local sound_outputdevices = {}
for i = 0, Sound_GameSystem_GetNumOutputDrivers()-1 do
	sound_outputdevices[i] = Sound_GameSystem_GetOutputDriverNameByIndex(i)
end

local sound_outputchannels = {
	[24] = L["SOUND_CHANNELS_LOW"]:format(24),
	[32] = L["SOUND_CHANNELS_MEDIUM"]:format(32),
	[64] = L["SOUND_CHANNELS_HIGH"]:format(64),
}

local function getBool(info) return GetCVarBool(info[#info]) end

options.args.game = {
	type = "group",
	name = L["SYSTEMOPTIONS_MENU"],
	childGroups = "tab",
	get = function(info)
		local val = GetCVar(info[#info])
		return tonumber(val) or val
	end,
	set = function(info, value)
		SetCVar(info[#info], value, "true")
	end,
	args = {
		language = {
			type = "group",
			name = L["LANGUAGES_LABEL"],
			args = {
				restartWarn = {
					order = 0,
					name = function() return L["RESTART_"..GetCVar("textLocale")] end,
					type = "description",
				},
				textLocale = {
					order = 1,
					name = L["LOCALE_TEXT_LABEL"],
					desc = L["OPTION_TOOLTIP_LOCALE"],
					type = "select",
					values = locales,
				},

				audioLocale = {
					order = 2,
					name = L["LOCALE_AUDIO_LABEL"],
					desc = L["OPTION_TOOLTIP_AUDIO_LOCALE"],
					type = "select",
					values = locales,
					hidden = function() return GetCVar("textLocale") == "enUS" end,
				},
			},
		},
		sound = {
			type = "group",
			name = L["SOUND_LABEL"],
			disabled = function() return not GetCVar("Sound_EnableAllSound") end,
			args = {
				system = {
					order = 1,
					type = "group",
					name = L["SYSTEMOPTIONS_MENU"],
					args = {
						Sound_EnableAllSound = {
							order = 0,
							name = L["ENABLE_SOUND"],
							desc = L["OPTION_TOOLTIP_ENABLE_SOUND"],
							type = "toggle",
							get = getBool,
						},
						Sound_MasterVolume = {
							order = 1,
							width = "double",
							name = L["MASTER_VOLUME"],
							desc = L["OPTION_TOOLTIP_MASTER_VOLUME"],
							type = "range",
							min = 0,
							max = 1,
							isPercent = true,
						},
						hardware = {
							order = 2,
							type = "header",
							name = L["HARDWARE"],
						},
						Sound_OutputDriverIndex = {
							order = 3,
							name = L["GAME_SOUND_OUTPUT"],
							desc = L["OPTION_TOOLTIP_SOUND_OUTPUT"],
							type = "select",
							values = sound_outputdevices,
						},
						Sound_NumChannels = {
							order = 4,
							name = L["SOUND_CHANNELS"],
							desc = L["OPTION_TOOLTIP_SOUND_CHANNELS"],
							type = "select",
							values = sound_outputchannels,
						},
						playback = {
							order = 5,
							type = "header",
							name = L["PLAYBACK"],
						},
						Sound_EnableReverb = {
							name = L["ENABLE_REVERB"],
							desc = L["OPTION_TOOLTIP_ENABLE_REVERB"],
							type = "toggle",
							get = getBool,
						},

						Sound_EnableSoftwareHRTF = {
							name = L["ENABLE_SOFTWARE_HRTF"],
							desc = L["OPTION_TOOLTIP_ENABLE_SOFTWARE_HRTF"],
							type = "toggle",
							get = getBool,
						},

						Sound_ListenerAtCharacter = {
							name = L["ENABLE_SOUND_AT_CHARACTER"],
							desc = L["OPTION_TOOLTIP_ENABLE_SOUND_AT_CHARACTER"],
							type = "toggle",
							get = getBool,
						},
						Sound_EnableSoundWhenGameIsInBG = {
							name = L["ENABLE_BGSOUND"],
							desc = L["OPTION_TOOLTIP_ENABLE_BGSOUND"],
							type = "toggle",
							get = getBool,
						},
						Sound_EnableDSPEffects = {
							order = 4,
							name = L["ENABLE_DSP_EFFECTS"],
							desc = L["OPTION_TOOLTIP_ENABLE_DSP_EFFECTS"],
							type = "toggle",
							get = getBool,
						},
					}
				},
				sound = {
					order = 2,
					type = "group",
					name = L["ENABLE_SOUNDFX"],
					args = {
						Sound_EnableSFX = {
							order = 0,
							name = L["ENABLE"],
							desc = L["OPTION_TOOLTIP_ENABLE_SOUNDFX"],
							type = "toggle",
							get = getBool,
						},
						Sound_SFXVolume = {
							order = 1,
							name = L["VOLUME"],
							desc = L["OPTION_TOOLTIP_SOUND_VOLUME"],
							type = "range",
							min = 0,
							max = 1,
							isPercent = true,
						},
						Sound_EnablePetSounds = {
							order = 2,
							name = L["ENABLE_PET_SOUNDS"],
							desc = L["OPTION_TOOLTIP_ENABLE_PET_SOUNDS"],
							type = "toggle",
							get = getBool,
							disabled = function() return not GetCVarBool("Sound_EnableSFX") end,
						},
						Sound_EnableEmoteSounds = {
							order = 3,
							name = L["ENABLE_EMOTE_SOUNDS"],
							desc = L["OPTION_TOOLTIP_ENABLE_EMOTE_SOUNDS"],
							type = "toggle",
							get = getBool,
							disabled = function() return not GetCVarBool("Sound_EnableSFX") end,
						},

					}
				},
				music = {
					order = 3,
					type = "group",
					name = L["ENABLE_MUSIC"],
					args = {
						Sound_EnableMusic = {
							order = 0,
							name = L["ENABLE"],
							desc = L["OPTION_TOOLTIP_ENABLE_MUSIC"],
							type = "toggle",
							get = getBool,
						},
						Sound_MusicVolume = {
							order = 1,
							name = L["VOLUME"],
							desc = L["OPTION_TOOLTIP_MUSIC_VOLUME"],
							type = "range",
							min = 0,
							max = 1,
							isPercent = true,
						},
						Sound_ZoneMusicNoDelay = {
							order = 2,
							name = L["ENABLE_MUSIC_LOOPING"],
							desc = L["OPTION_TOOLTIP_ENABLE_MUSIC_LOOPING"],
							type = "toggle",
							get = getBool,
							disabled = function() return not GetCVarBool("Sound_EnableMusic") end,
						},
						Sound_EnablePetBattleMusic = {
							order = 3,
							name = L["ENABLE_PET_BATTLE_MUSIC"],
							desc = L["OPTION_TOOLTIP_ENABLE_PET_BATTLE_MUSIC"],
							type = "toggle",
							get = getBool,
							disabled = function() return not GetCVarBool("Sound_EnableMusic") end,
						},
					}
				},
				ambience = {
					order = 4,
					type = "group",
					name = L["ENABLE_AMBIENCE"],
					args = {
						Sound_EnableAmbience = {
							order = 0,
							name = L["ENABLE"],
							desc = L["OPTION_TOOLTIP_ENABLE_AMBIENCE"],
							type = "toggle",
							get = getBool,
						},
						Sound_AmbienceVolume = {
							order = 1,
							name = L["VOLUME"],
							desc = L["OPTION_TOOLTIP_AMBIENCE_VOLUME"],
							type = "range",
							min = 0,
							max = 1,
							isPercent = true,
						},

					}
				},
				dialog = {
					order = 5,
					type = "group",
					name = L["ENABLE_DIALOG"],
					args = {
						Sound_EnableDialog = {
							order = 0,
							name = L["ENABLE"],
							desc = L["OPTION_TOOLTIP_ENABLE_DIALOG"],
							type = "toggle",
							get = getBool,
						},
						Sound_DialogVolume = {
							order = 1,
							name = L["VOLUME"],
							desc = L["OPTION_TOOLTIP_DIALOG_VOLUME"],
							type = "range",
							min = 0,
							max = 1,
							isPercent = true,
						},
						Sound_EnableErrorSpeech = {
							order = 2,
							name = L["ENABLE_ERROR_SPEECH"],
							desc = L["OPTION_TOOLTIP_ENABLE_ERROR_SPEECH"],
							type = "toggle",
							get = getBool,
							disabled = function() return not GetCVarBool("Sound_EnableDialog") end,
						},
					}
				},




			},
		},
		advGraphics = {
			type = "group",
			name = L["ADVANCED_LABEL"],
			args = {
				hdPlayerModels = {
					name = L["SHOW_HD_MODELS_TEXT"],
					desc = L["OPTION_TOOLTIP_SHOW_HD_MODELS_TEXT"],
					type = "toggle",
					get = getBool,
				},
			},
		},
		network = {
			type = "group",
			name = L["NETWORK_LABEL"],
			args = {
				disableServerNagle = {
					name = L["OPTIMIZE_NETWORK_SPEED"],
					desc = L["OPTION_TOOLTIP_OPTIMIZE_NETWORK_SPEED"],
					type = "toggle",
					get = getBool,
				},
				useIPv6 = {
					name = L["USEIPV6"],
					desc = L["OPTION_TOOLTIP_USEIPV6"],
					type = "toggle",
					get = getBool,
				},
				advancedCombatLogging = {
					name = L["ADVANCED_COMBAT_LOGGING"],
					desc = L["OPTION_TOOLTIP_ADVANCED_COMBAT_LOGGING"],
					type = "toggle",
					get = getBool,
				},
			},
		},

		--[[
		voice = {},
		controls = {},
		combat = {},
		names = {},
		camera = {},
		mouse = {},
		accessibility = {},
		--]]
	},

}
