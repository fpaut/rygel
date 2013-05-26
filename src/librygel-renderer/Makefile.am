include $(top_srcdir)/common.am
include $(srcdir)/filelist.am

librygel_renderer_includedir=$(includedir)/rygel-2.0
librygel_renderer_include_HEADERS = rygel-renderer.h

lib_LTLIBRARIES = librygel-renderer-2.0.la

LIBRYGEL_RENDERER_VERSION=1:0:0

librygel_renderer_2_0_la_SOURCES = \
	$(LIBRYGEL_RENDERER_VAPI_SOURCE_FILES) \
	$(LIBRYGEL_RENDERER_NONVAPI_SOURCE_FILES)

librygel_renderer_2_0_la_VALAFLAGS = \
	-H rygel-renderer.h --library=rygel-renderer-2.0 \
	--gir=Rygel-2.0.gir \
	$(LIBRYGEL_RENDERER_DEPS_VALAFLAGS) \
	$(RYGEL_COMMON_LIBRYGEL_CORE_VALAFLAGS) \
	$(RYGEL_COMMON_VALAFLAGS)
librygel_renderer_2_0_la_CFLAGS = \
	$(LIBRYGEL_RENDERER_DEPS_CFLAGS) \
	$(RYGEL_COMMON_LIBRYGEL_CORE_CFLAGS) \
	-DG_LOG_DOMAIN=\"Rygel\"
librygel_renderer_2_0_la_LIBADD = \
	$(LIBRYGEL_RENDERER_DEPS_LIBS) \
	$(RYGEL_COMMON_LIBRYGEL_CORE_LIBS)
librygel_renderer_2_0_la_LDFLAGS = \
	-version-info $(LIBRYGEL_RENDERER_VERSION)

vapidir = $(VAPIDIR)
vapi_DATA = rygel-renderer-2.0.vapi rygel-renderer-2.0.deps

rygel-renderer.h rygel-renderer-2.0.vapi Rygel-2.0.gir: librygel_renderer_2_0_la_vala.stamp

-include $(INTROSPECTION_MAKEFILE)
INTROSPECTION_GIRS=
INTROSPECTION_SCANNER_ARGS=
INTROSPECTION_COMPILER_ARGS= -l librygel-renderer-2.0.so.1 --includedir=$(builddir)/../librygel-core
$(srcdir)/RygelRenderer-2.0.gir: $(srcdir)/Rygel-2.0.gir
	$(AM_V_GEN)$(SED) -e 's,Rygel\.,RygelRenderer.,g' \
		-e 's,namespace name="Rygel",namespace name="RygelRenderer",g' \
		-e 's,RygelRenderer\.Plugin,RygelCore.Plugin,g' \
		-e 's,RygelRenderer\.MediaDevice,RygelCore.MediaDevice,g' \
		-e 's,<package name="rygel-renderer-2.0"/>,<include name="RygelCore" version="2.0"/>\n<package name="rygel-renderer-2.0"/>,' \
		$< >$@
GIRS = RygelRenderer-2.0.gir

girdir=$(datadir)/gir-1.0
dist_gir_DATA = $(GIRS)

typelibdir = $(libdir)/girepository-1.0
nodist_typelib_DATA = $(GIRS:.gir=.typelib)


rygel-renderer.h rygel-renderer-2.0.vapi: librygel_renderer_2_0_la_vala.stamp

EXTRA_DIST = rygel-renderer.h rygel-renderer-2.0.vapi rygel-renderer-2.0.deps RygelRenderer-2.0.gir
