#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif

#include <hx/CFFI.h>
#include "HxReachability.h"

using namespace reachability;

static void reachability_setReachabilityCallback (value callback) { setReachabilityCallback(callback); }
DEFINE_PRIM(reachability_setReachabilityCallback, 1);

static void reachability_dealloc () { dealloc(); }
DEFINE_PRIM(reachability_dealloc, 0);

extern "C" void reachability_main () {}
DEFINE_ENTRY_POINT(reachability_main);
extern "C" int reachability_register_prims () { return 0; }
