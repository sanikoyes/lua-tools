@echo off
REM This builds all the libraries of the folder for 1 uname

call tecmake %1 "MF=luagl_base" "USE_LUA51=Yes" %2 %3 %4 %5 %6 %7 %8
call tecmake %1 "MF=luagl" "USE_LUA51=Yes" %2 %3 %4 %5 %6 %7 %8
call tecmake %1 "MF=luaglu" "USE_LUA51=Yes" %2 %3 %4 %5 %6 %7 %8

call tecmake %1 "MF=luagl_base" "USE_LUA52=Yes" %2 %3 %4 %5 %6 %7 %8
call tecmake %1 "MF=luagl" "USE_LUA52=Yes" %2 %3 %4 %5 %6 %7 %8
call tecmake %1 "MF=luaglu" "USE_LUA52=Yes" %2 %3 %4 %5 %6 %7 %8

call tecmake %1 "MF=luagl_base" "USE_LUA53=Yes" %2 %3 %4 %5 %6 %7 %8
call tecmake %1 "MF=luagl" "USE_LUA53=Yes" %2 %3 %4 %5 %6 %7 %8
call tecmake %1 "MF=luaglu" "USE_LUA53=Yes" %2 %3 %4 %5 %6 %7 %8
