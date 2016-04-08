#include "lua.hpp"

#include <stdlib.h>
#include "xxtea/xxtea.h"
#include "iconv/iconv.h"

int l_xxtea_encrypt(lua_State *L) {

	size_t data_len;
	const char *data = luaL_checklstring(L, 1, &data_len);
	size_t key_len;
	const char *key = luaL_checklstring(L, 2, &key_len);

	xxtea_long ret_length;
	unsigned char *ret = xxtea_encrypt((unsigned char *) data, data_len, (unsigned char *) key, key_len, &ret_length);

	lua_pushlstring(L, (char *) ret, ret_length);
	free(ret);

	return 1;
}

int l_xxtea_decrypt(lua_State *L) {

	size_t data_len;
	const char *data = luaL_checklstring(L, 1, &data_len);
	size_t key_len;
	const char *key = luaL_checklstring(L, 2, &key_len);

	xxtea_long ret_length;
	unsigned char *ret = xxtea_decrypt((unsigned char *) data, data_len, (unsigned char *) key, key_len, &ret_length);

	lua_pushlstring(L, (char *) ret, ret_length);
	free(ret);

	return 1;
}

typedef bool(*Converter)(const std::string& in, std::string& out);
template<Converter converter>
int l_iconv(lua_State *L) {

	size_t len;
	const char *in_ = luaL_checklstring(L, 1, &len);
	std::string in;
	in.assign(in_, len);

	std::string out;
	if(converter(in, out)) {

		lua_pushlstring(L, out.c_str(), out.length());
		return 1;
	}
	return 0;
}		

int l_utf2gbk(lua_State *L) { return l_iconv<utf2gbk>(L); }
int l_gbk2utf(lua_State *L) { return l_iconv<gbk2utf>(L); }
int l_utf2big(lua_State *L) { return l_iconv<utf2big>(L); }
int l_big2utf(lua_State *L) { return l_iconv<big2utf>(L); }
int l_big2gbk(lua_State *L) { return l_iconv<big2gbk>(L); }
int l_gbk2big(lua_State *L) { return l_iconv<gbk2big>(L); }

static const struct luaL_Reg xxtea_lib[] = {
	{ "encrypt", l_xxtea_encrypt },
	{ "decrypt", l_xxtea_decrypt },
	{ NULL, NULL },
};

static const struct luaL_Reg iconv_lib[] = {
	{ "utf2gbk", l_utf2gbk },
	{ "gbk2utf", l_gbk2utf },
	{ "utf2big", l_utf2big },
	{ "big2utf", l_big2utf },
	{ "big2gbk", l_big2gbk },
	{ "gbk2big", l_gbk2big },
	{ NULL, NULL },
};

extern "C" {

int luaopen_misc_xxtea(lua_State *L) {
	luaL_newlib(L, xxtea_lib);
	return 1;
}

int luaopen_misc_iconv(lua_State *L) {
	luaL_newlib(L, iconv_lib);
	return 1;
}

};
