VERSION := 3.0.0

COMPONENTS := base zookeeper

build-debian:
	for component in ${COMPONENTS} ; do \
        echo "\n\nBuilding $${component} \n==========================================\n " ; \
				docker build -t confluentinc/$${component}:${VERSION} debian/$${component} || exit 1 ; \
				docker tag confluentinc/$${component}:${VERSION} confluentinc/$${component}:latest || exit 1 ; \
  done


venv: venv/bin/activate
venv/bin/activate: tests/requirements.txt
	test -d venv || virtualenv venv
	venv/bin/pip install -Ur tests/requirements.txt
	touch venv/bin/activate

test: venv
	IMAGE_DIR=$(pwd) venv/bin/behave tests