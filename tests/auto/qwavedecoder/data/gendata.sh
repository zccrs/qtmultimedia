#!/bin/bash
#############################################################################
##
## Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
## All rights reserved.
## Contact: Nokia Corporation (qt-info@nokia.com)
##
## This file is the build configuration utility of the Qt Toolkit.
##
## $QT_BEGIN_LICENSE:LGPL$
## GNU Lesser General Public License Usage
## This file may be used under the terms of the GNU Lesser General Public
## License version 2.1 as published by the Free Software Foundation and
## appearing in the file LICENSE.LGPL included in the packaging of this
## file. Please review the following information to ensure the GNU Lesser
## General Public License version 2.1 requirements will be met:
## http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
##
## In addition, as a special exception, Nokia gives you certain additional
## rights. These rights are described in the Nokia Qt LGPL Exception
## version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
##
## GNU General Public License Usage
## Alternatively, this file may be used under the terms of the GNU General
## Public License version 3.0 as published by the Free Software Foundation
## and appearing in the file LICENSE.GPL included in the packaging of this
## file. Please review the following information to ensure the GNU General
## Public License version 3.0 requirements will be met:
## http://www.gnu.org/copyleft/gpl.html.
##
## Other Usage
## Alternatively, this file may be used in accordance with the terms and
## conditions contained in a signed written agreement between you and Nokia.
##
##
##
##
##
## $QT_END_LICENSE$
##
#############################################################################

# Generate some simple test data.  Uses "sox".

endian=""
endian_extn=""

for channel in 1 2; do
    if [ $channel -eq 1 ]; then
        endian="little"
        endian_extn="le"
    fi

    if [ $channel -eq 2 ]; then
        endian="big"
        endian_extn="be"
    fi
    for samplebits in 8 16 32; do
        for samplerate in 44100 8000; do
            if [ $samplebits -ne 8 ]; then
                sox --endian "${endian}" -c ${channel} -b ${samplebits} -r ${samplerate} -n isawav_${channel}_${samplebits}_${samplerate}_${endian_extn}.wav synth 0.25 sine 300-3300
            else
                sox -c ${channel} -b ${samplebits} -r ${samplerate} -n isawav_${channel}_${samplebits}_${samplerate}.wav synth 0.25 sine 300-3300
            fi
        done
     done
done
