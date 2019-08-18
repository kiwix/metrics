FROM grimoirelab/full

ENV KIWIX_REPOS='"https://github.com/kiwix/kiwix-android", \
	    "https://github.com/kiwix/kiwix-tools", \
	    "https://github.com/kiwix/kiwix-lib", \ 
	    "https://github.com/kiwix/kiwix-js-windows", \
	    "https://github.com/kiwix/kiwix-build", \
	    "https://github.com/kiwix/kiwix-desktop", \
	    "https://github.com/kiwix/kiwix-hotspot", \
	    "https://github.com/kiwix/kiwix-js", \
	    "https://github.com/kiwix/kiwix-android-custom", \ 
	    "https://github.com/kiwix/maintenance", \
	    "https://github.com/kiwix/cardshop", \
	    "https://github.com/kiwix/apple", \
	    "https://github.com/kiwix/web", \
	    "https://github.com/kiwix/tools"'

ENV OPENZIM_REPOS='"https://github.com/openzim/libzim", \
	   "https://github.com/openzim/mwoffliner", \
	   "https://github.com/openzim/mediawiki-docker", \
	   "https://github.com/openzim/wikimedia_wp1_bot", \
	   "https://github.com/openzim/wp1_selection_tools", \
	   "https://github.com/openzim/zim-tools", \
	   "https://github.com/openzim/zimwriterfs", \
	   "https://github.com/openzim/zimfarm", \
	   "https://github.com/openzim/zim-requests", \
	   "https://github.com/openzim/zip2zim", \
	   "https://github.com/openzim/node-libzim", \
	   "https://github.com/openzim/phet", \
	   "https://github.com/openzim/youtube", \
	   "https://github.com/openzim/zimit", \
	   "https://github.com/openzim/wikihow", \
	   "https://github.com/openzim/histropedia", \
	   "https://github.com/openzim/openedx", \
	   "https://github.com/openzim/sotoki", \
	   "https://github.com/openzim/wikifundi", \
	   "https://github.com/openzim/gutenberg", \
	   "https://github.com/openzim/ted", \
	   "https://github.com/openzim/kalite"'
	   
USER root
	   
# set the projets and his repositories
RUN { \
  echo '{' ; \
  echo '  "kiwix": {' ; \
  echo '    "git": [' ; \
  echo        $KIWIX_REPOS ; \
  echo '    ],' ; \
  echo '    "github": [' ; \
  echo        $KIWIX_REPOS ; \
  echo '    ]' ; \
  echo "  }," ; \
  echo '{' ; \
  echo '  "openzim": {' ; \
  echo '    "git": [' ; \
  echo        $OPENZIM_REPOS ; \
  echo '    ],' ; \
  echo '    "github": [' ; \
  echo        $OPENZIM_REPOS ; \
  echo '    ]' ; \
  echo "  }" ; \
  echo "}" ; \
} > /myprojects.json

# set project Kiwix name
RUN sed "s/CHAOSS/Kiwix/g" /project.cfg > /project.cfg

# set Github token
RUN { \
  echo "[github]" ; \
  echo "api-token = $GITHUB_TOKEN" ; \  
} > /override.cfg

