## this is a script soley for inclusion in the main build scripts. 
## Common functions that are executed both all types of builds

ME=`basename "$0"`
echo "-->-- Starting ${ME}"
echo "--I-- ${TRAVIS_TAG} ${TRAVIS_BRANCH}"

function _exit(){
    printf "%s Exiting %s because %s exit code:%s\n" "--<--" "${ME}" "$1" "$2"   
    exit $2
}

function _abortBuild(){
    echo "ABORT_BUILD=true" > ${DIR}/build.cfg
    echo "ABORT_CODE=$1" >> ${DIR}/build.cfg
    echo "BUILD_FOCUS=${BUILD_FOCUS}" >> ${DIR}/build.cfg
    echo "BUILD_RELEASE=${BUILD_RELEASE}" >> ${DIR}/build.cfg
}

#check to see if the build.cfg file (that holds state between scripts)
if [ ! -f ${DIR}/build.cfg ]; then

    echo "ABORT_BUILD=false" > ${DIR}/build.cfg
    echo "ABORT_CODE=0" >> ${DIR}/build.cfg
    ## regexp to match the latest version
    LATEST_REGEXP=v0\.16\.\([0-9]{1,2}\|x\)

    ## determine the build type here
    if [ -z "${TRAVIS_TAG}" ]; then
        if [[ "${TRAVIS_BRANCH}" =~ ${LATEST_REGEXP} ]]; then
            BUILD_FOCUS="latest"
            BUILD_RELEASE="unstable"
        else
            BUILD_FOCUS="next"
            BUILD_RELEASE="unstable"
        fi
    else
        if [[ "${TRAVIS_BRANCH}" =~ ${LATEST_REGEXP} ]]; then
            BUILD_FOCUS="latest"
            BUILD_RELEASE="stable"
        else
            BUILD_FOCUS="next"
            BUILD_RELEASE="stable"
        fi
    fi

    echo "BUILD_FOCUS=${BUILD_FOCUS}" >> ${DIR}/build.cfg
    echo "BUILD_RELEASE=${BUILD_RELEASE}" >> ${DIR}/build.cfg
fi

source ${DIR}/build.cfg

echo "--I-- Build focus is ${BUILD_FOCUS}"
echo "--I-- Build release is ${BUILD_RELEASE}"

if [ "${ABORT_BUILD}" = "true" ]; then
  _exit "exiting early from" ${ABORT_CODE}
fi