KDE_LANG = pt
SUBDIRS = $(AUTODIRS)

KDE_DOCS = AUTO

$(srcdir)/index.docbook: install-dep.entities

install-dep.entities:
	$(LN_S) $(kde_htmldir)/en/api/install-dep.entities .

index.cache.bz2: $(srcdir)/index.docbook $(KDE_XSL_STYLESHEET) install-dep.entities
	@-if test -n "$(MEINPROC)"; then \
		 if test ! -f index.docbook; then \
		    rm -f index.docbook ;\
		    echo $(LN_S) $(srcdir)/index.docbook . ;\
		    $(LN_S) $(srcdir)/index.docbook . ;\
		 fi ;\
		 echo $(MEINPROC) --check --cache index.cache.bz2 index.docbook ;\
		 $(MEINPROC) --check --cache index.cache.bz2 index.docbook; \
		 if test ! -f index.docbook; then \
			 rm -f index.docbook ;\
		fi ;\
	   fi

