/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or (at your option) the GNU General
** Public license version 3 or any later version approved by the KDE Free
** Qt Foundation. The licenses are as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL2 and LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-2.0.html and
** https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "androidsurfacetexture.h"
#include <QtCore/private/qjni_p.h>
#include <QtCore/private/qjnihelpers_p.h>

QT_BEGIN_NAMESPACE

static const char QtSurfaceTextureListenerClassName[] = "org/qtproject/qt5/android/multimedia/QtSurfaceTextureListener";
static QMap<int, AndroidSurfaceTexture*> g_objectMap;

// native method for QtSurfaceTexture.java
static void notifyFrameAvailable(JNIEnv* , jobject, int id)
{
    AndroidSurfaceTexture *obj = g_objectMap.value(id, 0);
    if (obj)
        Q_EMIT obj->frameAvailable();
}

AndroidSurfaceTexture::AndroidSurfaceTexture(unsigned int texName)
    : QObject()
    , m_texID(int(texName))
{
    // API level 11 or higher is required
    if (QtAndroidPrivate::androidSdkVersion() < 11) {
        qWarning("Camera preview and video playback require Android 3.0 (API level 11) or later.");
        return;
    }

    QJNIEnvironmentPrivate env;
    m_surfaceTexture = QJNIObjectPrivate("android/graphics/SurfaceTexture", "(I)V", jint(texName));
    if (env->ExceptionCheck()) {
#ifdef QT_DEBUG
        env->ExceptionDescribe();
#endif // QT_DEBUG
        env->ExceptionClear();
    }

    if (m_surfaceTexture.isValid())
        g_objectMap.insert(int(texName), this);

    QJNIObjectPrivate listener(QtSurfaceTextureListenerClassName, "(I)V", jint(texName));
    m_surfaceTexture.callMethod<void>("setOnFrameAvailableListener",
                                      "(Landroid/graphics/SurfaceTexture$OnFrameAvailableListener;)V",
                                      listener.object());
}

AndroidSurfaceTexture::~AndroidSurfaceTexture()
{
    if (QtAndroidPrivate::androidSdkVersion() > 13 && m_surface.isValid())
        m_surface.callMethod<void>("release");

    if (m_surfaceTexture.isValid()) {
        release();
        g_objectMap.remove(m_texID);
    }
}

QMatrix4x4 AndroidSurfaceTexture::getTransformMatrix()
{
    QMatrix4x4 matrix;
    if (!m_surfaceTexture.isValid())
        return matrix;

    QJNIEnvironmentPrivate env;

    jfloatArray array = env->NewFloatArray(16);
    m_surfaceTexture.callMethod<void>("getTransformMatrix", "([F)V", array);
    env->GetFloatArrayRegion(array, 0, 16, matrix.data());
    env->DeleteLocalRef(array);

    return matrix;
}

void AndroidSurfaceTexture::release()
{
    if (QtAndroidPrivate::androidSdkVersion() < 14)
        return;

    m_surfaceTexture.callMethod<void>("release");
}

void AndroidSurfaceTexture::updateTexImage()
{
    if (!m_surfaceTexture.isValid())
        return;

    m_surfaceTexture.callMethod<void>("updateTexImage");
}

jobject AndroidSurfaceTexture::surfaceTexture()
{
    return m_surfaceTexture.object();
}

jobject AndroidSurfaceTexture::surface()
{
    if (!m_surface.isValid()) {
        m_surface = QJNIObjectPrivate("android/view/Surface",
                                      "(Landroid/graphics/SurfaceTexture;)V",
                                      m_surfaceTexture.object());
    }

    return m_surface.object();
}

jobject AndroidSurfaceTexture::surfaceHolder()
{
    if (!m_surfaceHolder.isValid()) {
        m_surfaceHolder = QJNIObjectPrivate("org/qtproject/qt5/android/multimedia/QtSurfaceTextureHolder",
                                            "(Landroid/view/Surface;)V",
                                            surface());
    }

    return m_surfaceHolder.object();
}

bool AndroidSurfaceTexture::initJNI(JNIEnv *env)
{
    // SurfaceTexture is available since API 11.
    if (QtAndroidPrivate::androidSdkVersion() < 11)
        return false;

    jclass clazz = QJNIEnvironmentPrivate::findClass(QtSurfaceTextureListenerClassName,
                                                     env);

    static const JNINativeMethod methods[] = {
        {"notifyFrameAvailable", "(I)V", (void *)notifyFrameAvailable}
    };

    if (clazz && env->RegisterNatives(clazz,
                                      methods,
                                      sizeof(methods) / sizeof(methods[0])) != JNI_OK) {
        return false;
    }

    return true;
}

QT_END_NAMESPACE
