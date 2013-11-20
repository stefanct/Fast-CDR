FASTCDR_OUTDIR= $(OUTDIR)/fastcdr
FASTCDR_OUTDIR_DEBUG = $(FASTCDR_OUTDIR)/debug
FASTCDR_OUTDIR_RELEASE = $(FASTCDR_OUTDIR)/release

# Get product version.
FASTCDRVERSION=-$(shell $(EPROSIMADIR)/scripts/common_pack_functions.sh printVersionFromCPP include/fastcdr/FastCdr_version.h)

FASTCDR_SED_OUTPUT_DIR_DEBUG= $(subst /,\\/,$(FASTCDR_OUTDIR_DEBUG))
FASTCDR_SED_OUTPUT_DIR_RELEASE= $(subst /,\\/,$(FASTCDR_OUTDIR_RELEASE))

FASTCDR_TARGET_DEBUG_FILE= libfastcdrd$(FASTCDRVERSION).so
FASTCDR_TARGET_DEBUG_Z_FILE= libfastcdrd$(FASTCDRVERSION).a
FASTCDR_TARGET_FILE= libfastcdr$(FASTCDRVERSION).so
FASTCDR_TARGET_Z_FILE= libfastcdr$(FASTCDRVERSION).a

FASTCDR_TARGET_DEBUG_FILE_LINK= libfastcdrd.so
FASTCDR_TARGET_DEBUG_Z_FILE_LINK= libfastcdrd.a
FASTCDR_TARGET_FILE_LINK= libfastcdr.so
FASTCDR_TARGET_Z_FILE_LINK= libfastcdr.a

FASTCDR_TARGET_DEBUG= $(BASEDIR)/lib/$(EPROSIMA_TARGET)/$(FASTCDR_TARGET_DEBUG_FILE)
FASTCDR_TARGET_DEBUG_Z= $(BASEDIR)/lib/$(EPROSIMA_TARGET)/$(FASTCDR_TARGET_DEBUG_Z_FILE)
FASTCDR_TARGET= $(BASEDIR)/lib/$(EPROSIMA_TARGET)/$(FASTCDR_TARGET_FILE)
FASTCDR_TARGET_Z= $(BASEDIR)/lib/$(EPROSIMA_TARGET)/$(FASTCDR_TARGET_Z_FILE)

FASTCDR_CFLAGS += $(CFLAGS) -std=c++0x
FASTCDR_CFLAGS_DEBUG += $(CFLAGS_DEBUG) -std=c++0x

FASTCDR_INCLUDE_DIRS= $(INCLUDE_DIRS) -I$(BASEDIR)/include \
		  -I$(EPROSIMADIR)/code

FASTCDR_SRC_CPPFILES= $(BASEDIR)/src/cpp/Cdr.cpp \
		  $(BASEDIR)/src/cpp/FastCdr.cpp \
		  $(BASEDIR)/src/cpp/FastBuffer.cpp \
		  $(BASEDIR)/src/cpp/exceptions/Exception.cpp \
		  $(BASEDIR)/src/cpp/exceptions/NotEnoughMemoryException.cpp \
		  $(BASEDIR)/src/cpp/exceptions/BadParamException.cpp

# Project sources are copied to the current directory
FASTCDR_SRCS= $(FASTCDR_SRC_CFILES) $(FASTCDR_SRC_CPPFILES)

# Source directories
FASTCDR_SOURCES_DIRS_AUX= $(foreach srcdir, $(dir $(FASTCDR_SRCS)), $(srcdir))
FASTCDR_SOURCES_DIRS= $(shell echo $(FASTCDR_SOURCES_DIRS_AUX) | tr " " "\n" | sort | uniq | tr "\n" " ")

FASTCDR_OBJS_DEBUG = $(foreach obj,$(notdir $(addsuffix .o, $(basename $(FASTCDR_SRCS)))), $(FASTCDR_OUTDIR_DEBUG)/$(obj))
FASTCDR_DEPS_DEBUG = $(foreach dep,$(notdir $(addsuffix .d, $(basename $(FASTCDR_SRCS)))), $(FASTCDR_OUTDIR_DEBUG)/$(dep))
FASTCDR_OBJS_RELEASE = $(foreach obj,$(notdir $(addsuffix .o, $(basename $(FASTCDR_SRCS)))), $(FASTCDR_OUTDIR_RELEASE)/$(obj))
FASTCDR_DEPS_RELEASE = $(foreach dep,$(notdir $(addsuffix .d, $(basename $(FASTCDR_SRCS)))), $(FASTCDR_OUTDIR_RELEASE)/$(dep))

OBJS+= $(FASTCDR_OBJS_DEBUG) $(FASTCDR_OBJS_RELEASE)
DEPS+= $(FASTCDR_DEPS_DEBUG) $(FASTCDR_DEPS_RELEASE)

.PHONY: fastcdr checkFASTCDRDirectories

fastcdr: checkFASTCDRDirectories $(FASTCDR_TARGET_DEBUG) $(FASTCDR_TARGET_DEBUG_Z) $(FASTCDR_TARGET) $(FASTCDR_TARGET_Z)

checkFASTCDRDirectories:
	@mkdir -p $(OUTDIR)
	@mkdir -p $(FASTCDR_OUTDIR)
	@mkdir -p $(FASTCDR_OUTDIR_DEBUG)
	@mkdir -p $(FASTCDR_OUTDIR_RELEASE)
	@mkdir -p lib
	@mkdir -p lib/$(EPROSIMA_TARGET)
	@mkdir -p $(EPROSIMA_LIBRARY_PATH)/proyectos/$(EPROSIMA_TARGET)

$(FASTCDR_TARGET_DEBUG): $(FASTCDR_OBJS_DEBUG)
	$(LN) $(LDFLAGS) -shared -o $(FASTCDR_TARGET_DEBUG) $(LIBRARY_PATH) $(LIBS_DEBUG) $(FASTCDR_OBJS_DEBUG)
	$(LNK) -s -f $(FASTCDR_TARGET_DEBUG_FILE) $(BASEDIR)/lib/$(EPROSIMA_TARGET)/$(FASTCDR_TARGET_DEBUG_FILE_LINK)
	$(CP) $(FASTCDR_TARGET_DEBUG) $(EPROSIMA_LIBRARY_PATH)/proyectos/$(EPROSIMA_TARGET)
	$(LNK) -s -f $(EPROSIMA_LIBRARY_PATH)/proyectos/$(EPROSIMA_TARGET)/$(FASTCDR_TARGET_DEBUG_FILE) $(EPROSIMA_LIBRARY_PATH)/proyectos/$(EPROSIMA_TARGET)/$(FASTCDR_TARGET_DEBUG_FILE_LINK)

$(FASTCDR_TARGET_DEBUG_Z): $(FASTCDR_OBJS_DEBUG)
	$(AR) -cru $(FASTCDR_TARGET_DEBUG_Z) $(FASTCDR_OBJS_DEBUG)
	$(LNK) -s -f $(FASTCDR_TARGET_DEBUG_Z_FILE) $(BASEDIR)/lib/$(EPROSIMA_TARGET)/$(FASTCDR_TARGET_DEBUG_Z_FILE_LINK)
	$(CP) $(FASTCDR_TARGET_DEBUG_Z) $(EPROSIMA_LIBRARY_PATH)/proyectos/$(EPROSIMA_TARGET)
	$(LNK) -s -f $(EPROSIMA_LIBRARY_PATH)/proyectos/$(EPROSIMA_TARGET)/$(FASTCDR_TARGET_DEBUG_Z_FILE) $(EPROSIMA_LIBRARY_PATH)/proyectos/$(EPROSIMA_TARGET)/$(FASTCDR_TARGET_DEBUG_Z_FILE_LINK)

$(FASTCDR_TARGET): $(FASTCDR_OBJS_RELEASE)
	$(LN) $(LDFLAGS) -shared -o $(FASTCDR_TARGET) $(LIBRARY_PATH) $(LIBS) $(FASTCDR_OBJS_RELEASE)
	$(LNK) -s -f $(FASTCDR_TARGET_FILE) $(BASEDIR)/lib/$(EPROSIMA_TARGET)/$(FASTCDR_TARGET_FILE_LINK)
	$(CP) $(FASTCDR_TARGET) $(EPROSIMA_LIBRARY_PATH)/proyectos/$(EPROSIMA_TARGET)
	$(LNK) -s -f $(EPROSIMA_LIBRARY_PATH)/proyectos/$(EPROSIMA_TARGET)/$(FASTCDR_TARGET_FILE) $(EPROSIMA_LIBRARY_PATH)/proyectos/$(EPROSIMA_TARGET)/$(FASTCDR_TARGET_FILE_LINK)

$(FASTCDR_TARGET_Z): $(FASTCDR_OBJS_RELEASE)
	$(AR) -cru $(FASTCDR_TARGET_Z) $(FASTCDR_OBJS_RELEASE)
	$(LNK) -s -f $(FASTCDR_TARGET_Z_FILE) $(BASEDIR)/lib/$(EPROSIMA_TARGET)/$(FASTCDR_TARGET_Z_FILE_LINK)
	$(CP) $(FASTCDR_TARGET_Z) $(EPROSIMA_LIBRARY_PATH)/proyectos/$(EPROSIMA_TARGET)
	$(LNK) -s -f $(EPROSIMA_LIBRARY_PATH)/proyectos/$(EPROSIMA_TARGET)/$(FASTCDR_TARGET_Z_FILE) $(EPROSIMA_LIBRARY_PATH)/proyectos/$(EPROSIMA_TARGET)/$(FASTCDR_TARGET_Z_FILE_LINK)

vpath %.cpp $(FASTCDR_SOURCES_DIRS)

$(FASTCDR_OUTDIR_DEBUG)/%.o:%.cpp
	@echo Calculating dependencies \(DEBUG mode\) $<
	@$(CPP) $(FASTCDR_CFLAGS_DEBUG) -MM $(FASTCDR_INCLUDE_DIRS) $< | sed "s/^.*:/$(FASTCDR_SED_OUTPUT_DIR_DEBUG)\/&/g" > $(@:%.o=%.d)
	@echo Compiling \(DEBUG mode\) $<  
	$(CPP) $(FASTCDR_CFLAGS_DEBUG) $(FASTCDR_INCLUDE_DIRS) $< -o $@

$(FASTCDR_OUTDIR_RELEASE)/%.o:%.cpp
	@echo Calculating dependencies \(RELEASE mode\) $<
	@$(CPP) $(FASTCDR_CFLAGS) -MM $(FASTCDR_INCLUDE_DIRS) $< | sed "s/^.*:/$(FASTCDR_SED_OUTPUT_DIR_RELEASE)\/&/g" > $(@:%.o=%.d)
	@echo Compiling \(RELEASE mode\) $<
	$(CPP) $(FASTCDR_CFLAGS) $(FASTCDR_INCLUDE_DIRS) $< -o $@
