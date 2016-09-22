#@IgnoreInspection BashAddShebang
# Activate robotframework virtualenv
# ${ROBOT_VENV} comes from the include-raw-integration-install-robotframework.sh
# script.

${WORKSPACE}/test/csit/run-csit.sh ${TESTPLAN} ${TESTOPTIONS}

