set_global_assignment -entity "pll_audio" -library "lib_pll_audio" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_audio" -library "lib_pll_audio" -name IP_TOOL_VERSION "22.1"
set_global_assignment -entity "pll_audio" -library "lib_pll_audio" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_audio" -name SPD_FILE [file join $::quartus(sip_path) "pll_audio.spd"]

set_global_assignment -library "lib_pll_audio" -name MISC_FILE [file join $::quartus(sip_path) "pll_audio_sim/pll_audio.vo"]
