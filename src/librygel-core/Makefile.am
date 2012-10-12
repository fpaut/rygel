include $(top_srcdir)/common.am
include $(srcdir)/filelist.am

librygelincdir = $(includedir)/rygel-2.0

librygelinc_HEADERS = rygel-core.h

lib_LTLIBRARIES = librygel-core-2.0.la

librygel_core_2_0_la_SOURCES = \
	$(LIBRYGEL_CORE_VAPI_SOURCE_FILES) \
	$(LIBRYGEL_CORE_NONVAPI_SOURCE_FILES)

librygel_core_2_0_la_VALAFLAGS = \
	-H rygel-core.h -C --library=rygel-core-2.0 \
	--gir=Rygel-2.0.gir \
	--vapidir=$(srcdir) \
	--pkg uuid \
	$(LIBRYGEL_CORE_DEPS_VALAFLAGS) \
	$(RYGEL_COMMON_VALAFLAGS)

librygel_core_2_0_la_CFLAGS = \
	$(RYGEL_COMMON_DEFINES_CFLAGS) \
	$(LIBRYGEL_CORE_DEPS_CFLAGS) \
	-DPLUGIN_DIR='"$(plugindir)"' \
	-DSMALL_ICON_DIR='"$(smallicondir)"' \
	-DBIG_ICON_DIR='"$(bigicondir)"' \
	-include config.h \
	-DG_LOG_DOMAIN='"Rygel"'

librygel_core_2_0_la_LIBADD = \
	$(LIBRYGEL_CORE_DEPS_LIBS)

RYGEL_CORE_VERSION=1:0:0
librygel_core_2_0_la_LDFLAGS = \
	$(RYGEL_DATA_DIR_DEFINES) \
	-version-info $(RYGEL_CORE_VERSION)

BUILT_SOURCES = \
	rygel-core-2.0.vapi \
	rygel-core.h

VAPI_FILES = rygel-core-2.0.vapi
DEPS_FILES = rygel-core-2.0.deps

vapidir = $(VAPIDIR)
vapi_DATA = $(VAPI_FILES) $(DEPS_FILES)
rygel-core-2.0.vapi rygel-core.h Rygel-2.0.gir: librygel_core_2_0_la_vala.stamp

-include $(INTROSPECTION_MAKEFILE)
INTROSPECTION_GIRS=
INTROSPECTION_SCANNER_ARGS=
INTROSPECTION_COMPILER_ARGS= -l librygel-core-2.0.so.1
$(srcdir)/RygelCore-2.0.gir: $(srcdir)/Rygel-2.0.gir
	$(AM_V_GEN)$(SED) -e 's,Rygel\.,RygelCore.,g' -e 's,namespace name="Rygel",namespace name="RygelCore",g' $< >$@
GIRS = RygelCore-2.0.gir

girdir=$(datadir)/gir-1.0
dist_gir_DATA = $(GIRS)

typelibdir = $(libdir)/girepository-1.0
nodist_typelib_DATA = $(GIRS:.gir=.typelib)

MAINTAINERCLEANFILES += $(BUILT_SOURCES)

EXTRA_DIST = \
	rygel-build-config.vapi \
	$(VAPI_FILES) \
	$(DEPS_FILES) \
	uuid.vapi \
	$(BUILT_SOURCES) \
	RygelCore-2.0.gir
