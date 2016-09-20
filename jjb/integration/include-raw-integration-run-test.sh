#@IgnoreInspection BashAddShebang
# Activate robotframework virtualenv
# ${ROBOT_VENV} comes from the include-raw-integration-install-robotframework.sh
# script.
source ${ROBOT_VENV}/bin/activate

# Run script plan if it exists
if [ -f ${WORKSPACE}/test/csit/scriptplans/${TESTPLAN} ]; then
    echo "scriptplan exists!!!"
    echo "Changing the scriptplan path..."
    cat ${WORKSPACE}/test/csit/scriptplans/${TESTPLAN} | sed "s:integration:${WORKSPACE}:" > scriptplan.txt
    cat scriptplan.txt
    for line in $( egrep -v '(^[[:space:]]*#|^[[:space:]]*$)' scriptplan.txt ); do
        echo "Executing ${line}..."
        source ${line}
    done
fi

# Get test plan if it exists, otherwise fail
if [ -f ${WORKSPACE}/test/csit/testplans/${TESTPLAN} ]; then
    echo "testplan exists!!!"
    echo "Reading the testplan:"
    cat ${WORKSPACE}/test/csit/testplans/${TESTPLAN} | sed "s:integration:${WORKSPACE}:" > testplan.txt
    cat testplan.txt
    SUITES=$( egrep -v '(^[[:space:]]*#|^[[:space:]]*$)' testplan.txt | tr '\012' ' ' )
else
    echo "testplan ${TESTPLAN} not found!  Aborting."
    exit 1
fi

echo "Starting Robot test suites ${SUITES} ..."
pybot -N ${TESTPLAN} -v WORKSPACE:/tmp ${TESTOPTIONS} ${SUITES} || true

# TODO: do something with the output
