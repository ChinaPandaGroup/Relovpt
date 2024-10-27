// @anchor: Writing 
// @date: 2024
// @copyright: OPanda/Relvopt
// @class: RAuto
// @language: C/C++
// @system: UNIX,Windows

#ifndef __cplusplus

// This is a Types can choice
enum RTypes{
    __STD__INT      ,
    __STD__DOUBLE   ,
    __STD__FLOAT    ,
    __STD__CHAR     ,
    __STD__LONG_LONG,
    __STD__SHORT    ,
    __STD__BOOL     ,
    __STD__STRUCT   ,
    __RELVOPT__QUEUE,
	__UNKNOWN
};

#define Auto(X) __New_RTypes(_Generic((X), \
									int : __STD__INT, \
									double : __STD__DOUBLE, \
									float : __STD__FLOAT, \
									char : __STD__CHAR, \
									long long : __STD__LONG_LONG, \
									short : __STD__SHORT, \
									_Bool : __STD__BOOL, \
									struct : __STD__STRUCT, \
									default : __UNKNOWN), \
									&X)
#define AutoData(X) X._value
#else
// The C++ not have macro
#endif