
/* Define to 1 if translation of program messages to the user's native
   language is requested. */
/* #undef ENABLE_NLS */

/* The gettext domain we're using */
#define GETTEXT_PACKAGE "libexif-9"

#ifdef WIN32
#define snprintf _snprintf
#pragma warning(disable:4996) // warning C4996: '_snprintf': This function or variable may be unsafe. Consider using _snprintf_s instead. To disable deprecation, use _CRT_SECURE_NO_WARNINGS. See online help for details.

#endif

