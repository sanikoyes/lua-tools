ifeq ($(OS), Windows_NT)
  TECMAKE_CMD = $(MAKE) --no-print-directory -f ../tecmakewin.mak TEC_UNAME=$(TEC_UNAME) 
else
  TECMAKE_CMD = $(MAKE) --no-print-directory -f ../tecmake.mak 
endif

.PHONY: do_all luagl_base luagl luaglu
do_all: luagl_base luagl luaglu

luagl_base:
	$(TECMAKE_CMD) MF=luagl_base USE_LUA51=Yes
	$(TECMAKE_CMD) MF=luagl_base USE_LUA52=Yes
	$(TECMAKE_CMD) MF=luagl_base USE_LUA53=Yes
luagl:
	$(TECMAKE_CMD) MF=luagl USE_LUA51=Yes
	$(TECMAKE_CMD) MF=luagl USE_LUA52=Yes
	$(TECMAKE_CMD) MF=luagl USE_LUA53=Yes
luaglu:
	@$(TECMAKE_CMD) MF=luaglu USE_LUA51=Yes
	@$(TECMAKE_CMD) MF=luaglu USE_LUA52=Yes
	@$(TECMAKE_CMD) MF=luaglu USE_LUA53=Yes
