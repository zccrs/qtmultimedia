/****************************************************************************
**
** Copyright (C) 2012 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: http://www.qt-project.org/
**
** This file is part of the Qt Mobility Components.
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

#ifndef TRACE_H
#define TRACE_H

#include <QtCore/QDebug>

#define ENABLE_TRACE
//#define VERBOSE_TRACE

namespace Trace {

class NullDebug
{
public:
    template <typename T>
    NullDebug& operator<<(const T&) { return *this; }
};

inline NullDebug nullDebug() { return NullDebug(); }

template <typename T>
struct PtrWrapper
{
    PtrWrapper(const T *ptr) : m_ptr(ptr) { }
    const T *const m_ptr;
};

} // namespace Trace

template <typename T>
inline QDebug& operator<<(QDebug &debug, const Trace::PtrWrapper<T> &wrapper)
{
    debug.nospace() << "[" << (void*)wrapper.m_ptr << "]";
    return debug.space();
}

template<typename T>
inline const void *qtVoidPtr(const T *ptr)
{ return static_cast<const void *>(ptr); }

#define qtThisPtr() qtVoidPtr(this)

#ifdef ENABLE_TRACE
        inline QDebug qtTrace() { return qDebug() << "[qmlvideo]"; }
#    ifdef VERBOSE_TRACE
        inline QDebug qtVerboseTrace() { return qtTrace(); }
#    else
        inline Trace::NullDebug qtVerboseTrace() { return Trace::nullDebug(); }
#    endif
#else
    inline Trace::NullDebug qtTrace() { return Trace::nullDebug(); }
    inline Trace::NullDebug qtVerboseTrace() { return Trace::nullDebug(); }
#endif

#endif // TRACE_H