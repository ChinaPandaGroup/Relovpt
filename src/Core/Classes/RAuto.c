// @anchor: Writing 
// @date: 2024
// @copyright: OPanda/Relvopt
// @class: RAuto
// @language: C/C++
// @system: UNIX,Windows

#ifndef __cplusplus
#include <stdlib.h>

enum RTypes{
    __STD__INT      ,
    __STD__DOUBLE   ,
    __STD__FLOAT    ,
    __STD__CHAR     ,
    __STD__LONG_LONG,
    __STD__SHORT    ,
    __STD__BOOL     ,
    __STD__STRUCT   ,
    __RELVOPT__QUEUE
};
typedef struct RAuto{
    enum RTypes _Types ;
    void *_value;
    void (*__Set_RTypes_Type)(RAuto autos, enum RTypes type) ; // This function is a hidden function and cannot be called externally, otherwise it may cause a crash
    void (*__Set_RTypes_Value)(RAuto autos, void *) ; // This function is a hidden function, But you can call this function
    
} RAuto;

void __Set_RTypes_Type(RAuto autos, enum RTypes type){
    autos._Types = type;
}

void __Set_RTypes_Value(RAuto autos, void *value) {
    autos._value = value;
}

RAuto __New_RTypes(enum RTypes type, void *value) {
    RAuto result ;
    result._Types = type ;
    result._value = value ;
    return result; 
}

#else
typedef auto RAuto;

#endif
