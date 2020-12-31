
AUTOMAKE_OPTIONS = foreign 1.4

SUBDIRS = $(TOPSUBDIRS)

CONFIGURE_DEPENDENCIES = subdirs

$(top_srcdir)/acinclude.m4: $(top_srcdir)/admin/acinclude.m4.in $(top_srcdir)/admin/libtool.m4.in
	@cd $(top_srcdir) && cat admin/acinclude.m4.in $(top_srcdir)/admin/libtool.m4.in > acinclude.m4

merge:
	@if test -z "$$LIST"; then \
	  list=`find templates -name '*.pot' | sed -e 's#^templates/\(.*\)\.pot$$#\1#'`; \
	else \
	  list= ;\
	  for i in $$LIST; do \
	    list="$$list `find templates -name $$i | sed -e 's#^templates/\(.*\)\.pot$$#\1#'`"; \
	  done ;\
	  echo $$list; \
	fi; \
	for temp in $$list; do \
	  test -n "$$VERBOSE" && echo merging $$temp; \
	  trans= ;\
	  for subdir in `cat subdirs`; do \
	    if test -f $$subdir/messages/$$temp.po; then trans="$$trans $$subdir/messages/$$temp.po"; fi ;\
	  done ;\
	  for file in $$trans; do \
	    test -f $$file || break; \
	    trans_name=`echo $$file | sed -e "s#[,./ ]#_#g"`;  \
	    egrep -e '^#|^msgid' $$file |  perl -np -e 'exit if /msgid/;' > $$trans_name ;\
	    egrep '^#,|^#~|^# , c-format|^[^#]' $$file | egrep '^.*[^ ]+.*$$' | grep -v "\"POT-Creation" >> $$trans_name ;\
	    if msgmerge -q --no-location -o $$file.tmp $$trans_name templates/$$temp.pot 2> /dev/null; then \
	    rm -f $$trans_name ;\
	    if test -f $$file.tmp; then \
		perl ./commentmerge $$file.tmp templates/$$temp.pot > $$file.new ;\
		charset=`grep charset= $$file.new | sed -e "s#^.*[cC]harset=\(.*\)..\"#\1#"`; \
		if test "x$$charset" = "xutf8" || test "x$$charset" = "xutf-8" || test "x$$charset" = "xUTF-8"; then \
		   mv $$file.new $$file.tmp ;\
		   test -n "$$VERBOSE" && echo fixing "$$file" ;\
		   if ! perl ./msgsplit.pl < $$file.tmp > $$file.new ; then \
		      mv $$file.tmp $$file.new ;\
		   fi ;\
		fi ;\
		rm -f $$file.tmp ;\
		if diff $$file.new $$file > /dev/null; then \
		  rm $$file.new; \
		else \
		  mv $$file.new $$file ;\
		fi \
	    fi ;\
	    else \
	    	msgmerge -q $$file templates/$$temp.pot > /dev/null ;\
	    fi ;\
	  done \
	done

highscore:
	@files=`find */messages -name '*.po' -print` \
	TMPLIST=aaaaaaa; \
	rm -f $$TMPLIST; \
	for i in $$files; do \
	  output=`msgfmt -o /dev/null --statistics $$i 2>&1 | sed "s#\.##"`; \
	  untranslated= ;\
	  if echo $$output | grep -q untranslated ; then \
	    untranslated=`echo $$output |  sed 's#.* \(.*\) untranslated messages#\1#'` ;\
	  fi ;\
	  fuzzy= ;\
	  if echo $$output | grep -q fuzzy; then \
	    fuzzy=`echo $$output | sed 's#.* \(.*\) fuzzy translations.*#\1#'`; \
	  fi ;\
	  if test -n "$$fuzzy$$untranslated"; then \
	    lang=`echo $$i | sed -e 's,\([^/]*\)/messages/.*$$,\1,'`; \
	    file=`echo $$i | sed -e 's,.*/messages.*/\([^/]*\)\.po,\1,'`; \
	    echo $$lang-$$file-$$fuzzy-$$untranslated >> $$TMPLIST ;\
	  fi ; \
	done; \
	if test ! -r $$TMPLIST; then \
	  echo "it seems, everything is completly translated" ;\
	  exit;\
	fi  ;\
	\
	TMPLIST2=/tmp/log2;\
	sort -u $$TMPLIST > $$TMPLIST2 && mv $$TMPLIST2 $$TMPLIST;\
	oldlang= ;\
	rm -rf highscore; \
	for i in `cat $$TMPLIST`; do \
	  lang=`echo $$i | cut -f1 -d'-'`;\
	  file=`echo $$i | cut -f2 -d'-'`;\
	  fuzzy=`echo $$i | cut -f3 -d'-'`;\
	  if test -n "$$fuzzy"; then \
	    fuzzy="$$fuzzy fuzzy";\
	  fi ;\
	  untrans=`echo $$i | cut -f4 -d'-'`;\
	  if test -n "$$untrans"; then \
	    untrans="$$untrans untranslated";\
	  fi ;\
	  if test "$$oldlang" = "$$lang"; then \
	    echo "   $$file: $$fuzzy $$untrans" >> highscore;\
	  else \
	    echo "$$lang:" >> highscore;\
	    echo "   $$file: $$fuzzy $$untrans" >> highscore; \
	    oldlang=$$lang ;\
	  fi; \
	done; \
	\
	rm -f $$TMPLIST

highscore.html:
	@files=`find */messages -name '*.po' -print` \
	TMPLIST=`tempfile`; \
	rm -f $$TMPLIST; \
	for i in $$files; do \
	  output=`msgfmt --statistics $$i 2>&1 | sed "s#\.##"`; \
	  untranslated= ;\
	  if echo $$output | grep -q untranslated ; then \
	    untranslated=`echo $$output |  sed 's#.* \(.*\) untranslated messages#\1#'` ;\
	  fi ;\
	  fuzzy= ;\
	  if echo $$output | grep -q fuzzy; then \
	    fuzzy=`echo $$output | sed 's#.* \(.*\) fuzzy translations.*#\1#'`; \
	  fi ;\
	  if test -n "$$fuzzy$$untranslated"; then \
	    lang=`echo $$i | sed -e 's,\([^/]*\)/messages/.*$$,\1,'`; \
	    package=`echo $$i | sed -e 's,.*/messages/\([^/]*\)/.*\.po,\1,'`; \
	    file=`echo $$i | sed -e 's,.*/messages.*/\([^/]*\)\.po,\1,'`; \
	    echo $$lang-$$package-$$file-$$fuzzy-$$untranslated >> $$TMPLIST ;\
	  fi ; \
	done; \
	if test ! -r $$TMPLIST; then \
	  echo "it seems, everything is completly translated" ;\
	  exit;\
	fi  ;\
	\
	TMPLIST2=/tmp/log2;\
	sort -u $$TMPLIST > $$TMPLIST2 && mv $$TMPLIST2 $$TMPLIST;\
	oldlang= ;\
        oldpackage=;\
	rm -rf highscore; \
	rm -rf highscore.html; \
	echo '<html><head><title>Highscore</title></head>' >>highscore.html;\
        echo '<body><H1>Highscore</H1><P>As of ' >>highscore.html;\
	date -u  >>highscore.html;\
	echo '</P>' >>highscore.html;\
	for i in `cat $$TMPLIST`; do \
	  lang=`echo $$i | cut -f1 -d'-'`;\
	  package=`echo $$i | cut -f2 -d'-'`;\
	  file=`echo $$i | cut -f3 -d'-'`;\
	  fuzzy=`echo $$i | cut -f4 -d'-'`;\
	  if test -n "$$fuzzy"; then \
	    fuzzy="$$fuzzy fuzzy";\
	  fi ;\
	  untrans=`echo $$i | cut -f5 -d'-'`;\
	  if test -n "$$untrans"; then \
	    untrans="$$untrans untranslated";\
	  fi ;\
	  if test "$$oldlang" != "$$lang"; then \
	    if test ! -z "$$lang"; then\
	       echo "</table>" >> highscore.html;\
	    fi;\
	    echo "<H2><A name=\"$$lang\"></A>$$lang</H2>" >> highscore.html;\
            echo "$$lang:" >> highscore;\
            oldlang=$$lang ;\
	    oldpackage=;\
          fi;\
          if test "$$file" = "desktop"; then \
	     package='Desktop and KDELibs';\
	  fi;\
          if test "$$file" = "kdelibs"; then \
	     package='Desktop and KDELibs';\
	  fi;\
	  if test "$$oldpackage" != "$$package"; then \
	    if test ! -z "$$oldpackage"; then\
	       echo "</table>" >> highscore.html;\
	    fi;\
	    echo "<table cellpadding=3 border=0><tr><th align=\"left\" colspan=\"3\">\
	          $$package</th></tr>" >> highscore.html;\
	    oldpackage=$$package;\
	  fi;\
	  echo "<tr><td>$$file</td><td>$$fuzzy</td><td>$$untrans</td></tr>"\
	      >> highscore.html;\
	  echo "   $$file: $$fuzzy $$untrans" >> highscore; \
	done; \
	echo '</td></tr></table></body></html>' >> highscore.html;\
	\
	rm -f $$TMPLIST

all_files:
	@pwd=`pwd`; \
	(cd .. && bash $$pwd/findfiles $$pwd/all_files)

desktop: all_files
	@desktop=`tempfile`; \
	pwd=`pwd`; \
	(cd .. && bash $$pwd/createdesktop $$pwd/all_files $$desktop) ;\
	test -f $$desktop && \
	if diff -q $$desktop templates/desktop.pot; then \
          rm $$desktop; \
	else \
	  mv $$desktop templates/desktop.pot ;\
	fi

apply: apply.cc
	@g++ apply.cc -o apply

desktops: apply
	@langfile=`tempfile`; \
	rm -f $$langfile; \
	KDEDIR=`tempfile`;  \
	if test -f $$KDEDIR; then rm -f $$KDEDIR; mkdir $$KDEDIR; fi ;\
	export KDEDIR; \
	for file in */messages/desktop.po; do \
		charset=`grep charset= $$file | sed -e "s#^.*[cC]harset=\(.*\)..\"#\1#"`; \
		if test ! "x$$charset" = "xutf8" && test ! "x$$charset" = "xutf-8" && test ! "x$$charset" = "xUTF-8"; then \
			continue; \
		fi ;\
		lang=`echo $$file | sed -e "s#\([^/]*\)/messages/desktop.po#\1#"`; \
		mkdir -p $$KDEDIR/share/locale/$$lang/LC_MESSAGES; \
		msgfmt $$file -o $$KDEDIR/share/locale/$$lang/LC_MESSAGES/apply.mo; \
		echo $$lang >> $$langfile ;\
	done; \
	list=`cat ./all_files` ; \
	: > logfile ;\
	for i in $$list; do \
	   ./apply ../$$i `cat $$langfile` >> logfile 2>&1 && if diff ../$$i ../$$i.new > /dev/null; then rm ../$$i.new; else mv -f ../$$i.new ../$$i; fi ;\
	done ;\
	sort logfile ;\
	rm -f logfile

clean:
	rm -rf apply all_files messages

ECHO=echo

langsubdir:
	@if test -f Makefile.am; then \
	   if egrep '^#created by toplevel Makefile' Makefile.am > /dev/null; then \
	     rm -f Makefile.am ;\
	   else \
	     echo "The Makefile.am here is not generated. Leaving!" ;\
	     exit 1; \
	   fi; \
	fi
	@$(ECHO) "#created by toplevel Makefile" > Makefile.am; \
	subdirs="messages"; \
	if test -f docs/Makefile.am; then \
	  subdirs="docs $$subdirs"; \
	fi ;\
	if test -f data/Makefile.am; then \
	   subdirs="data $$subdirs"; \
        fi ;\
	$(ECHO) "SUBDIRS = $$subdirs" >> Makefile.am ;\
	$(ECHO) "AUTOMAKE_OPTIONS = foreign" >> Makefile.am ;\
	$(ECHO) "EXTRA_DIST = configure.in.in" >> Makefile.am ;\
	$(ECHO) "\$$(srcdir)/configure.in.in: \$$(srcdir)/../Makefile.am" >> Makefile.am ;\
	$(ECHO) "	cd \$$(srcdir) && $(MAKE) -f ../Makefile.am langsubdir SUBDIRLANG=$(SUBDIRLANG)" >> Makefile.am ;\
	$(ECHO) "\$$(srcdir)/configure.in: \$$(srcdir)/configure.in.in" >> Makefile.am ;\
	$(ECHO) "	cd \$$(srcdir) && $(MAKE) -f ../admin/Makefile.common configure.in" >> Makefile.am ;\
	$(ECHO) "\$$(srcdir)/acinclude.m4: \$$(srcdir)/../acinclude.m4" >> Makefile.am ;\
	$(ECHO) "	cd \$$(srcdir) && cp ../acinclude.m4 ." >> Makefile.am ;\
	$(ECHO) "dist-hook:" >> Makefile.am ;\
	$(ECHO) "	for i in am_edit install-sh ltmain.sh ltconfig config.sub config.guess mkinstalldirs missing; do cp \$$(top_srcdir)/../admin/\$$\$$i \$$(top_distdir)/\$$\$$i ; done && \\" >> Makefile.am ;\
	$(ECHO) "	(cd \$$(top_distdir) && \\" >> Makefile.am ;\
	$(ECHO) "	grep -v AC_CONFIG_AUX_DIR configure.in.in > tmp && mv tmp configure.in.in && \\" >> Makefile.am ;\
	$(ECHO) "	grep -v AC_CONFIG_AUX_DIR configure.in > tmp && mv tmp configure.in && \\" >> Makefile.am ;\
	$(ECHO) "	echo '#created by toplevel Makefile' > Makefile.am ;\\"  >> Makefile.am
	@if test -f docs/Makefile.am; then \
	  $(ECHO) "	echo 'SUBDIRS = docs messages' >> Makefile.am ;\\" >> Makefile.am ;\
	else \
	  $(ECHO) "	echo 'SUBDIRS = messages' >> Makefile.am ;\\" >> Makefile.am ;\
	fi ;\
	$(ECHO) "	echo 'AUTOMAKE_OPTIONS = foreign' >> /Makefile.am ; \\" >> Makefile.am ;\
	$(ECHO) "	aclocal && \\" >> Makefile.am ;\
	$(ECHO) "	autoheader && \\" >> Makefile.am ;\
	$(ECHO) "	automake --foreign --include-deps && \\" >> Makefile.am ;\
	$(ECHO) "	perl am_edit && \\" >> Makefile.am ;\
	$(ECHO) "	autoconf)" >> Makefile.am ;\
	$(ECHO) ".SILENT:" >> Makefile.am ;\
	echo "" >> Makefile.am

	@$(ECHO) "AC_INIT(messages/kdelibs.po)" > configure.in.in ;\
	$(ECHO) "AC_CONFIG_AUX_DIR(../admin)" >> configure.in.in ;\
	$(ECHO) "AM_INIT_AUTOMAKE(kde-i18n-$(SUBDIRLANG), 0.1)" >> configure.in.in ;\
	$(ECHO) "AM_CONFIG_HEADER(config.h)" >> configure.in.in ;\
	$(ECHO) "AC_SUBST(AUTODIRS)" >> configure.in.in ;\
	$(ECHO) "AM_KDE_WITH_NLS" >> configure.in.in ;\
	$(ECHO) "AC_CREATE_KFSSTND(default)" >> configure.in.in ;\
	$(ECHO) "KDE_SET_PREFIX" >> configure.in.in ;\
	$(ECHO) "AC_SUBST_KFSSTND" >> configure.in.in ;\
	$(ECHO) "AC_PROG_INSTALL" >> configure.in.in ;\
	$(ECHO) "AC_PROG_LN_S" >> configure.in.in ;\
	$(MAKE) -f ../admin/Makefile.common configure.in
	@$(MAKE) -f Makefile.am ./acinclude.m4 srcdir=.
	@aclocal
	@autoheader
	@automake
	@perl ../admin/am_edit
	@autoconf
	perl -pi -e 'print "if test \"x\$$with_fast_perl\" = \"xyes\" ;\
          then\n  perl -i.bak \$$ac_aux_dir/conf.change.pl \$$CONFIG_STATUS\
          || mv \$$CONFIG_STATUS.bak \$$CONFIG_STATUS;\
          \n  rm -f \$$CONFIG_STATUS.bak;\nfi\
          \n" if /^\s*chmod\s+.*\+x\s+.*CONFIG_STATUS/;' configure


cvs-dist-local:
	$(MAKE) -f Makefile.am acinclude.m4 top_srcdir=.
	if [ -f inst-apps ]; then \
		subdirfile=inst-apps; \
	else \
		subdirfile=subdirs; \
	fi; \
	for dir in `cat $$subdirfile`; do \
	  if test ! -f $$dir/messages/kdelibs.po; then \
	     echo for $$dir there is no kdelibs.po ;\
	     continue ;\
	  fi ;\
	  destdir=kde-i18n-$$dir ;\
	  rm -fr $$destdir ;\
	  cp -r $$dir $$destdir ;\
	  for i in am_edit install-sh ltmain.sh ltconfig config.sub \
		config.guess mkinstalldirs missing; do \
			cp admin/$$i $$destdir; \
	  done ;\
	  cp acinclude.m4 $$destdir ;\
	$(ECHO) "#created by toplevel Makefile" > $$destdir/Makefile.am; \
	subdirs="messages"; \
	if test -f $$destdir/docs/Makefile.am; then \
	  subdirs="docs $$subdirs"; \
	fi ;\
	if test -f $$destdir/data/Makefile.am; then \
	   subdirs="data $$subdirs"; \
        fi ;\
	$(ECHO) "SUBDIRS = $$subdirs" >> $$destdir/Makefile.am ;\
	$(ECHO) "AUTOMAKE_OPTIONS = foreign" >> $$destdir/Makefile.am ;\
	$(ECHO) "AC_INIT(messages/kdelibs.po)" > $$destdir/configure.in.in ;\
	$(ECHO) "AM_INIT_AUTOMAKE(kde-i18n-$$dir, 0.1)" >> $$destdir/configure.in.in ;\
	$(ECHO) "AM_CONFIG_HEADER(config.h)" >> $$destdir/configure.in.in ;\
	$(ECHO) "KDE_SET_PREFIX" >> $$destdir/configure.in.in ;\
	$(ECHO) "AC_SUBST(AUTODIRS)" >> $$destdir/configure.in.in ;\
	$(ECHO) "AM_KDE_WITH_NLS" >> $$destdir/configure.in.in ;\
	$(ECHO) "AC_CREATE_KFSSTND(default)" >> $$destdir/configure.in.in ;\
	$(ECHO) "AC_SUBST_KFSSTND" >> $$destdir/configure.in.in ;\
	$(ECHO) "AC_PROG_INSTALL" >> $$destdir/configure.in.in ;\
	$(ECHO) "AC_PROG_LN_S" >> $$destdir/configure.in.in ;\
	rm -f $$destdir/configure.in ;\
	(cd $$destdir && \
	  $(MAKE) -f ../admin/Makefile.common configure.in && \
	  aclocal && autoheader && automake && perl am_edit && autoconf && \
	for i in `find . -name "*.po"`; do msgfmt $$i -o `echo $$i | sed -e 's#\.po#.gmo#'`; done ) ;\
	rm -f $$destdir/configure.in.in ;\
	tar c --exclude CVS --exclude .cvsignore $$destdir | bzip2 > $$destdir.tar.bz2 ;\
	rm -rf $$destdir ;\
	done

cvs-local:
	if [ -f inst-apps ]; then \
		subdirfile=inst-apps; \
	else \
		subdirfile=subdirs; \
	fi; \
	for dir in `cat $$subdirfile`; do \
		(echo "*** Building in $$dir"; cd $$dir && $(MAKE) -f ../Makefile.am langsubdir SUBDIRLANG=$$dir) \
	done

listtoremove:
	@list=`(cd $(srcdir) && find . -name index.docbook)` ;\
	for i in $$list ; do if test ! -f `echo $$i | sed -e "s%index.docbook%index.cache.bz2%"`; then echo $$i; fi; done > listtoremove
	@for i in `cat $(srcdir)/subdirs `; do num=`grep "/$$i/" listtoremove | wc -l`; echo "$$i:$$num" ; done | grep -v " 0"
	@-rm -f listtoremove
