#!/bin/bash -x
export QMAKE_PATH=/usr/bin/qmake

export X_SOURCE_PATH=$PWD
export X_BUILD_NAME=xopcodecalc_linux_portable
export X_RELEASE_VERSION=$(cat "release_version.txt")

source build_tools/linux.sh

check_file $QMAKE_PATH

if [ -z "$X_ERROR" ]; then
    make_init
    make_build "$X_SOURCE_PATH/xopcodecalc_source.pro"

    check_file "$X_SOURCE_PATH/build/release/xocalc"
    if [ -z "$X_ERROR" ]; then
        create_deb_app_dir xocalc
        
        #cp -f $X_SOURCE_PATH/LICENSE                                        $X_SOURCE_PATH/release/$X_BUILD_NAME/
        cp -f $X_SOURCE_PATH/DEBIAN/control                                 $X_SOURCE_PATH/release/$X_BUILD_NAME/DEBIAN/
        sed -i "s/#VERSION#/$X_RELEASE_VERSION/"                            $X_SOURCE_PATH/release/$X_BUILD_NAME/DEBIAN/control
        sed -i "s/#ARCH#/$X_ARCHITECTURE/"                                  $X_SOURCE_PATH/release/$X_BUILD_NAME/DEBIAN/control
        cp -f $X_SOURCE_PATH/build/release/xocalc                              $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/bin/
        cp -f $X_SOURCE_PATH/DEBIAN/xocalc.desktop                             $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/share/applications/
        sed -i "s/#VERSION#/$X_RELEASE_VERSION/"                            $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/share/applications/xocalc.desktop
        cp -Rf $X_SOURCE_PATH/DEBIAN/hicolor/                               $X_SOURCE_PATH/release/$X_BUILD_NAME/usr/share/icons/

        make_deb
        mv $X_SOURCE_PATH/release/$X_BUILD_NAME.deb $X_SOURCE_PATH/release/xopcodecalc_${X_RELEASE_VERSION}-${X_REVISION}_${X_ARCHITECTURE}.deb
        make_clear
    fi
fi
