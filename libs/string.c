
#include "string.h"
/*
 * Function Name:   strlen
 * Purpose: calculate the length of the string @s,stop when it meet '\0' character
 * Params:  
 * @s   the input string
 * Return:  the length of string @s
 */
size_t 
strlen(const char *s)
{
    size_t n = 0;
    while(*s ++ != '\0')
    {
        n ++;
    }
    return n;
}
/*
 * calculate the length of the string @s,stop when it meet '\0' character, but at most @len
 */
size_t
strnlen(const char *s, size_t len)
{
  size_t cnt = 0;  
  while( cnt < len && *s ++ != '\0')
  {
      cnt ++;
  }
  return cnt;
}

/*
 * copies the string pointed by @src into the array pointed by @dst.
 */
char*
strcpy(char *dst, const char *src)
{
    char *p = dst;
    while((*p ++ = *src ++) != '\0')
        ;
    return dst;
}

/*
 * copies the string pointed by @src into the array pointed by @dst, but at most @len.
 * if found character '\0' before @len characters, it won't copy any characters.
 */
char*
strncpy(char *dst, const char *src, size_t len)
{
    char *p = dst;
    while(len > 0)
    {
       if((*p = *src) != '\0')
       {
           src ++;
           p ++;
           len --;
       }else{
           break;
       }

    }
    return dst;
}

/*
 * compares the string @s1 and @s2.
 */
int
strcmp(const char *s1, const char *s2)
{
    while(*s2 != '\0' && *s2 != '\0')
    {
        if(*s1 != *s2)
        {
            break;
        }
        s1 ++;
        s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
}
/*
 * copies the string pointed by @src into the array pointed by @dst, but at most @len.
 * if found character '\0' before @len characters, it won't copy any characters.
 * but at most @n.
 */
int
strncmp(const char *s1, const char *s2, size_t n)
{
    while(n > 0 && *s1 != '\0' && *s1 == *s2)
    {
        n --, s1 ++ ,s2 ++;
    }
    return n == 0 ? 0 : ((int)((unsigned char)*s1 - (unsigned char)*s2));
}

/*
 * locates first occurrence of character in string.
 */
char*
strchr(const char *s, char c)
{
    while(*s != '\0')
    {
        if(*s == c)
        {
            return (char*)s;
        }
        s ++;
    }
    return NULL;
}

/*
 * locates first occurrence of character in string ,but it returns the end of character instead of character NULL.
 */
char*
strfind(const char *s, char c)
{
    while(*s != '\0')
    {
        if(*s == c)
        {
            break;
        }
        s ++;
    }
    return (char*)s;
}
/* *
 * strtol - converts string to long integer
 * @s:        the input string that contains the representation of an integer number
 * @endptr:    reference to an object of type char *, whose value is set by the
 *             function to the next character in @s after the numerical value. This
 *             parameter can also be a null pointer, in which case it is not used.
 * @base:    x
 *
 * The function first discards as many whitespace characters as necessary until
 * the first non-whitespace character is found. Then, starting from this character,
 * takes as many characters as possible that are valid following a syntax that
 * depends on the base parameter, and interprets them as a numerical value. Finally,
 * a pointer to the first character following the integer representation in @s
 * is stored in the object pointed by @endptr.
 *
 * If the value of base is zero, the syntax expected is similar to that of
 * integer constants, which is formed by a succession of:
 * - An optional plus or minus sign;
 * - An optional prefix indicating octal or hexadecimal base ("0" or "0x" respectively)
 * - A sequence of decimal digits (if no base prefix was specified) or either octal
 *   or hexadecimal digits if a specific prefix is present
 *
 * If the base value is between 2 and 36, the format expected for the integral number
 * is a succession of the valid digits and/or letters needed to represent integers of
 * the specified radix (starting from '0' and up to 'z'/'Z' for radix 36). The
 * sequence may optionally be preceded by a plus or minus sign and, if base is 16,
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
        s ++;
    }
    else if (*s == '-') {
        s ++, neg = 1;
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
        s += 2, base = 16;
    }
    else if (base == 0 && s[0] == '0') {
        s ++, base = 8;
    }
    else if (base == 0) {
        base = 10;
    }

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
            dig = *s - '0';
        }
        else if (*s >= 'a' && *s <= 'z') {
            dig = *s - 'a' + 10;
        }
        else if (*s >= 'A' && *s <= 'Z') {
            dig = *s - 'A' + 10;
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
        *endptr = (char *) s;
    }
    return (neg ? -val : val);
}
/*
 * sets the first @n bytes of the memory area pointed by @s
 * to the specified value @c.
 */
void*
memset(void *s, char c, size_t n)
{
    char *p = s;
    while(n > 0)
    {
        *p ++ = c;
        n --;
    }
    return s;
}
/*
 * copies the values of @n bytes from the location pointed by @src to
 * the memory area pointed by @dst. @src and @dst are allowed to overlap.
 */
void*
memmove(void *dst, const void *src, size_t n)
{
    const char *s = src;
    char *d = dst;
    if (s < d && s + n > d) {
        s += n, d += n;
        while (n -- > 0) {
            *-- d = *-- s;
        }
    } else {
        while (n -- > 0) {
            *d ++ = *s ++;
        }
    }
    return dst;
}
/*
 * copies the value of @n bytes from the location pointed by @src to
 * the memory area pointed by @dst.
 */
void*
memcpy(void *dst, const void *src, size_t n)
{
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
}
/*
 * compares two blocks of memory
 */
int
memcmp(const void *v1, const void *v2, size_t n)
{
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
}


