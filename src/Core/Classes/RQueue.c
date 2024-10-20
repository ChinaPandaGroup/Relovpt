// @anchor: Writing, LiLinYang
// @date: 2024
// @copyright: OPanda/Relvopt
// @class: RQueue
// @language: C/C++
// @system: UNIX,Windows

#ifndef __cplusplus
// @language: C
// @system: UNIX,Windows
////////////////////////////////////////////////
#include "../../Sdk/RTypes.h" // include header
////////////////////////////////////////////////
struct _RQueueNode{

};
struct RQueue{
    LENGE_T length;
    struct _RQueueNode *head, *tail; // is head and tail
};


#else
#endif