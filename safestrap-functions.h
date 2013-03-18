#ifndef _SAFESTRAPFUNCTIONS_HEADER
#define _SAFESTRAPFUNCTIONS_HEADER

#if !defined(__cplusplus) && !defined(bool)
typedef enum { false = 0, true = 1 } bool;
#endif

bool locate_forward(char **needle_ptr, char *read_ptr, const char *needle, const char *needle_last);
bool locate_backward(char **needle_ptr, char *read_ptr, const char *needle, const char *needle_last);
void ProcessSafestrapTranslations(char *buf, int bufLen);

#endif
