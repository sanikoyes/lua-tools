PROJNAME = luagl
LIBNAME = luagl_base

OPT=Yes

SRC = luagl_util.c luagl_const.c

ifdef USE_LUA53
  DEFINES += LUA_COMPAT_MODULE
else
ifdef USE_LUA52
  DEFINES += LUA_COMPAT_MODULE
else
  USE_LUA51 = Yes
endif
endif

# To not link with the Lua dynamic library in UNIX
NO_LUALINK = Yes
# To use a subfolder with the Lua version for binaries
LUAMOD_DIR = Yes

ifneq ($(findstring MacOS, $(TEC_UNAME)), )
  ifneq ($(TEC_SYSMINOR), 4)
    BUILD_DYLIB=Yes
  endif
endif
