/****************************************************************************
**
** Copyright (C) 2012 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: http://www.qt-project.org/
**
** This file is part of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser General Public
** License version 2.1 as published by the Free Software Foundation and
** appearing in the file LICENSE.LGPL included in the packaging of this
** file. Please review the following information to ensure the GNU Lesser
** General Public License version 2.1 requirements will be met:
** http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights. These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU General
** Public License version 3.0 as published by the Free Software Foundation
** and appearing in the file LICENSE.GPL included in the packaging of this
** file. Please review the following information to ensure the GNU General
** Public License version 3.0 requirements will be met:
** http://www.gnu.org/copyleft/gpl.html.
**
** Other Usage
** Alternatively, this file may be used in accordance with the terms and
** conditions contained in a signed written agreement between you and Nokia.
**
**
**
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtMultimedia 5.0

/*!
    \qmlclass Video
    \inherits Item
    \ingroup multimedia_qml
    \brief A convenience element for showing a specified video

    The \c Video element is a convenience element combining the functionality
    of the \l MediaPlayer and \l VideoOutput elements into one. It provides
    simple video playback functionality without having to specify multiple
    elements.

    \qml
    import QtQuick 2.0
    import QtMultimedia 5.0

    Video {
        id: video
        width : 800
        height : 600
        source: "video.avi"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                video.play()
            }
        }

        focus: true
        Keys.onSpacePressed: video.paused = !video.paused
        Keys.onLeftPressed: video.position -= 5000
        Keys.onRightPressed: video.position += 5000
    }
    \endqml

    The Video element supports untransformed, stretched, and uniformly scaled
    video presentation. For a description of stretched uniformly scaled
    presentation, see the \l fillMode property description.

    \sa MediaPlayer, VideoOutput
*/

Item {
    id: video

    /*** Properties of VideoOutput ***/
    /*!
        \qmlproperty enumeration Video::fillMode

        Set this property to define how the video is scaled to fit the target
        area.

        \list
        \o stretch - the video is scaled to fit.
        \o preserveAspectFit - the video is scaled uniformly to fit without
            cropping
        \o preserveAspectCrop - the video is scaled uniformly to fill, cropping
            if necessary
        \endlist

        Because this element is a convenience element in QML, it does not
        support enumerations directly. In contrast to \l VideoOutput and other
        elements, the values to set for fillMode all start with lowercase
        letters to work around this.

        The default fill mode is preserveAspectFit.
    */
    property alias fillMode:            videoOut.fillMode

    /*!
        \qmlproperty int Video::orientation

        The orientation of the Video element in degrees. Only multiples of 90
        degrees is supported, that is 0, 90, 180, 270, 360, etc.
    */
    property alias orientation:         videoOut.orientation

    /* Properties to emulate enumeration for fillMode, documented above */
    /*! \internal */
    readonly property int stretch:             VideoOutput.Stretch
    /*! \internal */
    readonly property int preserveAspectFit:   VideoOutput.PreserveAspectFit
    /*! \internal */
    readonly property int preserveAspectCrop:  VideoOutput.PreserveAspectCrop

    /*** Properties of MediaPlayer ***/
    /*!
        \qmlproperty bool Video::autoLoad

        This property indicates if loading of media should begin immediately.

        Defaults to true, if false media will not be loaded until playback is
        started.
    */
    property alias autoLoad:        player.autoLoad

    /*!
        \qmlproperty real Video::bufferProgress

        This property holds how much of the data buffer is currently filled,
        from 0.0 (empty) to 1.0
        (full).
    */
    property alias bufferProgress:  player.bufferProgress

    /*!
        \qmlproperty int Video::duration

        This property holds the duration of the media in milliseconds.

        If the media doesn't have a fixed duration (a live stream for example)
        this will be 0.
    */
    property alias duration:        player.duration

    /*!
        \qmlproperty enumeration Video::error

        This property holds the error state of the video.  It can be one of:

        \list
        \o NoError - there is no current error.
        \o ResourceError - the video cannot be played due to a problem
            allocating resources.
        \o FormatError - the video format is not supported.
        \o NetworkError - the video cannot be played due to network issues.
        \o AccessDenied - the video cannot be played due to insufficient
            permissions.
        \o ServiceMissing -  the video cannot be played because the media
            service could not be
        instantiated.
        \endlist
    */
    property alias error:           player.error

    /*!
        \qmlproperty string Video::errorString

        This property holds a string describing the current error condition in more detail.
    */
    property alias errorString:     player.errorString

    /* documented below due to length of metaData documentation */
    property alias metaData:        player.metaData

    /*!
        \qmlproperty bool Video::muted

        This property holds whether the audio output is muted.
    */
    property alias muted:           player.muted

    /*!
        \qmlproperty bool Video::paused

        This property holds whether the media is paused.

        Defaults to false, and can be set to true to pause playback.
    */
    property alias paused:          player.paused

    /*!
        \qmlproperty real Video::playbackRate

        This property holds the rate at which video is played at as a multiple
        of the normal rate.
    */
    property alias playbackRate:    player.playbackRate

    /*!
        \qmlproperty bool Video::playing

        This property holds whether the media is playing.

        Defaults to false, and can be set to true to start playback.
    */
    property alias playing:         player.playing

    /*!
        \qmlproperty int Video::position

        This property holds the current playback position in milliseconds.
    */
    property alias position:        player.position

    /*!
        \qmlproperty bool Video::seekable

        This property holds whether the playback position of the video can be
        changed.
    */
    property alias seekable:        player.seekable

    /*!
        \qmlproperty url Video::source

        This property holds the source URL of the media.
    */
    property alias source:          player.source

    /*!
        \qmlproperty enumeration Video::status

        This property holds the status of media loading. It can be one of:

        \list
        \o NoMedia - no media has been set.
        \o Loading - the media is currently being loaded.
        \o Loaded - the media has been loaded.
        \o Buffering - the media is buffering data.
        \o Stalled - playback has been interrupted while the media is buffering data.
        \o Buffered - the media has buffered data.
        \o EndOfMedia - the media has played to the end.
        \o InvalidMedia - the media cannot be played.
        \o UnknownStatus - the status of the media cannot be determined.
        \endlist
    */
    property alias status:          player.status

    /*!
        \qmlproperty real Video::volume

        This property holds the volume of the audio output, from 0.0 (silent) to 1.0 (maximum volume).
    */
    property alias volume:          player.volume

    /*!
        \qmlsignal Video::resumed()

        This signal is emitted when playback is resumed from the paused state.
    */
    signal resumed
    /*!
        \qmlsignal Video::started()

        This signal is emitted when playback is started.
    */
    signal started
    /*!
        \qmlsignal Video::stopped()

        This signal is emitted when playback is stopped.
    */
    signal stopped


    VideoOutput {
        id: videoOut
        anchors.fill: video
        source: player
    }

    MediaPlayer {
        id: player
        onResumed: video.resumed()
        onStarted: video.started()
        onStopped: video.stopped()
    }

    /*!
        \qmlmethod Video::play()

        Starts playback of the media.

        Sets the \l playing property to true, and the \l paused property to
        false.
    */
    function play() {
        player.play();
    }

    /*!
        \qmlmethod Video::pause()

        Pauses playback of the media.

        Sets the \l playing and \l paused properties to true.
    */
    function pause() {
        player.pause();
    }

    /*!
        \qmlmethod Video::stop()

        Stops playback of the media.

        Sets the \l playing and \l paused properties to false.
    */
    function stop() {
        player.stop();
    }

}

// ***************************************
// Documentation for meta-data properties.
// ***************************************

/*!
    \qmlproperty variant Video::metaData.title

    This property holds the title of the media.

    \sa {QtMultimedia::MetaData::Title}
*/

/*!
    \qmlproperty variant Video::metaData.subTitle

    This property holds the sub-title of the media.

    \sa {QtMultimedia::MetaData::SubTitle}
*/

/*!
    \qmlproperty variant Video::metaData.author

    This property holds the author of the media.

    \sa {QtMultimedia::MetaData::Author}
*/

/*!
    \qmlproperty variant Video::metaData.comment

    This property holds a user comment about the media.

    \sa {QtMultimedia::MetaData::Comment}
*/

/*!
    \qmlproperty variant Video::metaData.description

    This property holds a description of the media.

    \sa {QtMultimedia::MetaData::Description}
*/

/*!
    \qmlproperty variant Video::metaData.category

    This property holds the category of the media

    \sa {QtMultimedia::MetaData::Category}
*/

/*!
    \qmlproperty variant Video::metaData.genre

    This property holds the genre of the media.

    \sa {QtMultimedia::MetaData::Genre}
*/

/*!
    \qmlproperty variant Video::metaData.year

    This property holds the year of release of the media.

    \sa {QtMultimedia::MetaData::Year}
*/

/*!
    \qmlproperty variant Video::metaData.date

    This property holds the date of the media.

    \sa {QtMultimedia::MetaData::Date}
*/

/*!
    \qmlproperty variant Video::metaData.userRating

    This property holds a user rating of the media in the range of 0 to 100.

    \sa {QtMultimedia::MetaData::UserRating}
*/

/*!
    \qmlproperty variant Video::metaData.keywords

    This property holds a list of keywords describing the media.

    \sa {QtMultimedia::MetaData::Keywords}
*/

/*!
    \qmlproperty variant Video::metaData.language

    This property holds the language of the media, as an ISO 639-2 code.

    \sa {QtMultimedia::MetaData::Language}
*/

/*!
    \qmlproperty variant Video::metaData.publisher

    This property holds the publisher of the media.

    \sa {QtMultimedia::MetaData::Publisher}
*/

/*!
    \qmlproperty variant Video::metaData.copyright

    This property holds the media's copyright notice.

    \sa {QtMultimedia::MetaData::Copyright}
*/

/*!
    \qmlproperty variant Video::metaData.parentalRating

    This property holds the parental rating of the media.

    \sa {QtMultimedia::MetaData::ParentalRating}
*/

/*!
    \qmlproperty variant Video::metaData.ratingOrganization

    This property holds the name of the rating organization responsible for the
    parental rating of the media.

    \sa {QtMultimedia::MetaData::RatingOrganization}
*/

/*!
    \qmlproperty variant Video::metaData.size

    This property property holds the size of the media in bytes.

    \sa {QtMultimedia::MetaData::Size}
*/

/*!
    \qmlproperty variant Video::metaData.mediaType

    This property holds the type of the media.

    \sa {QtMultimedia::MetaData::MediaType}
*/

/*!
    \qmlproperty variant Video::metaData.audioBitRate

    This property holds the bit rate of the media's audio stream in bits per
    second.

    \sa {QtMultimedia::MetaData::AudioBitRate}
*/

/*!
    \qmlproperty variant Video::metaData.audioCodec

    This property holds the encoding of the media audio stream.

    \sa {QtMultimedia::MetaData::AudioCodec}
*/

/*!
    \qmlproperty variant Video::metaData.averageLevel

    This property holds the average volume level of the media.

    \sa {QtMultimedia::MetaData::AverageLevel}
*/

/*!
    \qmlproperty variant Video::metaData.channelCount

    This property holds the number of channels in the media's audio stream.

    \sa {QtMultimedia::MetaData::ChannelCount}
*/

/*!
    \qmlproperty variant Video::metaData.peakValue

    This property holds the peak volume of the media's audio stream.

    \sa {QtMultimedia::MetaData::PeakValue}
*/

/*!
    \qmlproperty variant Video::metaData.sampleRate

    This property holds the sample rate of the media's audio stream in Hertz.

    \sa {QtMultimedia::MetaData::SampleRate}
*/

/*!
    \qmlproperty variant Video::metaData.albumTitle

    This property holds the title of the album the media belongs to.

    \sa {QtMultimedia::MetaData::AlbumTitle}
*/

/*!
    \qmlproperty variant Video::metaData.albumArtist

    This property holds the name of the principal artist of the album the media
    belongs to.

    \sa {QtMultimedia::MetaData::AlbumArtist}
*/

/*!
    \qmlproperty variant Video::metaData.contributingArtist

    This property holds the names of artists contributing to the media.

    \sa {QtMultimedia::MetaData::ContributingArtist}
*/

/*!
    \qmlproperty variant Video::metaData.composer

    This property holds the composer of the media.

    \sa {QtMultimedia::MetaData::Composer}
*/

/*!
    \qmlproperty variant Video::metaData.conductor

    This property holds the conductor of the media.

    \sa {QtMultimedia::MetaData::Conductor}
*/

/*!
    \qmlproperty variant Video::metaData.lyrics

    This property holds the lyrics to the media.

    \sa {QtMultimedia::MetaData::Lyrics}
*/

/*!
    \qmlproperty variant Video::metaData.mood

    This property holds the mood of the media.

    \sa {QtMultimedia::MetaData::Mood}
*/

/*!
    \qmlproperty variant Video::metaData.trackNumber

    This property holds the track number of the media.

    \sa {QtMultimedia::MetaData::TrackNumber}
*/

/*!
    \qmlproperty variant Video::metaData.trackCount

    This property holds the number of track on the album containing the media.

    \sa {QtMultimedia::MetaData::TrackNumber}
*/

/*!
    \qmlproperty variant Video::metaData.coverArtUrlSmall

    This property holds the URL of a small cover art image.

    \sa {QtMultimedia::MetaData::CoverArtUrlSmall}
*/

/*!
    \qmlproperty variant Video::metaData.coverArtUrlLarge

    This property holds the URL of a large cover art image.

    \sa {QtMultimedia::MetaData::CoverArtUrlLarge}
*/

/*!
    \qmlproperty variant Video::metaData.resolution

    This property holds the dimension of an image or video.

    \sa {QtMultimedia::MetaData::Resolution}
*/

/*!
    \qmlproperty variant Video::metaData.pixelAspectRatio

    This property holds the pixel aspect ratio of an image or video.

    \sa {QtMultimedia::MetaData::PixelAspectRatio}
*/

/*!
    \qmlproperty variant Video::metaData.videoFrameRate

    This property holds the frame rate of the media's video stream.

    \sa {QtMultimedia::MetaData::VideoFrameRate}
*/

/*!
    \qmlproperty variant Video::metaData.videoBitRate

    This property holds the bit rate of the media's video stream in bits per
    second.

    \sa {QtMultimedia::MetaData::VideoBitRate}
*/

/*!
    \qmlproperty variant Video::metaData.videoCodec

    This property holds the encoding of the media's video stream.

    \sa {QtMultimedia::MetaData::VideoCodec}
*/

/*!
    \qmlproperty variant Video::metaData.posterUrl

    This property holds the URL of a poster image.

    \sa {QtMultimedia::MetaData::PosterUrl}
*/

/*!
    \qmlproperty variant Video::metaData.chapterNumber

    This property holds the chapter number of the media.

    \sa {QtMultimedia::MetaData::ChapterNumber}
*/

/*!
    \qmlproperty variant Video::metaData.director

    This property holds the director of the media.

    \sa {QtMultimedia::MetaData::Director}
*/

/*!
    \qmlproperty variant Video::metaData.leadPerformer

    This property holds the lead performer in the media.

    \sa {QtMultimedia::MetaData::LeadPerformer}
*/

/*!
    \qmlproperty variant Video::metaData.writer

    This property holds the writer of the media.

    \sa {QtMultimedia::MetaData::Writer}
*/

// The remaining properties are related to photos, and are technically
// available but will certainly never have values.

/*!
    \qmlproperty variant Video::metaData.cameraManufacturer

    \sa {QtMultimedia::MetaData::CameraManufacturer}
*/

/*!
    \qmlproperty variant Video::metaData.cameraModel

    \sa {QtMultimedia::MetaData::CameraModel}
*/

/*!
    \qmlproperty variant Video::metaData.event

    \sa {QtMultimedia::MetaData::Event}
*/

/*!
    \qmlproperty variant Video::metaData.subject

    \sa {QtMultimedia::MetaData::Subject}
*/

/*!
    \qmlproperty variant Video::metaData.orientation

    \sa {QtMultimedia::MetaData::Orientation}
*/

/*!
    \qmlproperty variant Video::metaData.exposureTime

    \sa {QtMultimedia::MetaData::ExposureTime}
*/

/*!
    \qmlproperty variant Video::metaData.fNumber

    \sa {QtMultimedia::MetaData::FNumber}
*/

/*!
    \qmlproperty variant Video::metaData.exposureProgram

    \sa {QtMultimedia::MetaData::ExposureProgram}
*/

/*!
    \qmlproperty variant Video::metaData.isoSpeedRatings

    \sa {QtMultimedia::MetaData::ISOSpeedRatings}
*/

/*!
    \qmlproperty variant Video::metaData.exposureBiasValue

    \sa {QtMultimedia::MetaData::ExposureBiasValue}
*/

/*!
    \qmlproperty variant Video::metaData.dateTimeDigitized

    \sa {QtMultimedia::MetaData::DateTimeDigitized}
*/

/*!
    \qmlproperty variant Video::metaData.subjectDistance

    \sa {QtMultimedia::MetaData::SubjectDistance}
*/

/*!
    \qmlproperty variant Video::metaData.meteringMode

    \sa {QtMultimedia::MetaData::MeteringMode}
*/

/*!
    \qmlproperty variant Video::metaData.lightSource

    \sa {QtMultimedia::MetaData::LightSource}
*/

/*!
    \qmlproperty variant Video::metaData.flash

    \sa {QtMultimedia::MetaData::Flash}
*/

/*!
    \qmlproperty variant Video::metaData.focalLength

    \sa {QtMultimedia::MetaData::FocalLength}
*/

/*!
    \qmlproperty variant Video::metaData.exposureMode

    \sa {QtMultimedia::MetaData::ExposureMode}
*/

/*!
    \qmlproperty variant Video::metaData.whiteBalance

    \sa {QtMultimedia::MetaData::WhiteBalance}
*/

/*!
    \qmlproperty variant Video::metaData.DigitalZoomRatio

    \sa {QtMultimedia::MetaData::DigitalZoomRatio}
*/

/*!
    \qmlproperty variant Video::metaData.focalLengthIn35mmFilm

    \sa {QtMultimedia::MetaData::FocalLengthIn35mmFile}
*/

/*!
    \qmlproperty variant Video::metaData.sceneCaptureType

    \sa {QtMultimedia::MetaData::SceneCaptureType}
*/

/*!
    \qmlproperty variant Video::metaData.gainControl

    \sa {QtMultimedia::MetaData::GainControl}
*/

/*!
    \qmlproperty variant Video::metaData.contrast

    \sa {QtMultimedia::MetaData::contrast}
*/

/*!
    \qmlproperty variant Video::metaData.saturation

    \sa {QtMultimedia::MetaData::Saturation}
*/

/*!
    \qmlproperty variant Video::metaData.sharpness

    \sa {QtMultimedia::MetaData::Sharpness}
*/

/*!
    \qmlproperty variant Video::metaData.deviceSettingDescription

    \sa {QtMultimedia::MetaData::DeviceSettingDescription}
*/
