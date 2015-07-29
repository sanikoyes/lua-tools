PROJNAME = luagl
LIBNAME = luaglu

OPT=Yes

INCLUDES = ../include .
SRC = luaglu.c

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
# To not use the "lib" prefix in UNIX
DLIBPRE :=
# To use a subfolder with the Lua version for binaries
LUAMOD_DIR = Yes

LIBS = luagl_base
LDIR = ../lib/$(TEC_UNAME_DIR)

USE_OPENGL = Yes
USE_MACOS_OPENGL = Yes

ifneq ($(findstring MacOS, $(TEC_UNAME)), )
  ifdef USE_MACOS_OPENGL
    LFLAGS = -framework OpenGL
    USE_OPENGL :=
  endif
endif
