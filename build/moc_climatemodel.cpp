/****************************************************************************
** Meta object code from reading C++ file 'climatemodel.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.15.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../App/Climate/climatemodel.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'climatemodel.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.15.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_ClimateModel_t {
    QByteArrayData data[10];
    char stringdata0[120];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_ClimateModel_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_ClimateModel_t qt_meta_stringdata_ClimateModel = {
    {
QT_MOC_LITERAL(0, 0, 12), // "ClimateModel"
QT_MOC_LITERAL(1, 13, 11), // "dataChanged"
QT_MOC_LITERAL(2, 25, 0), // ""
QT_MOC_LITERAL(3, 26, 11), // "driver_temp"
QT_MOC_LITERAL(4, 38, 14), // "passenger_temp"
QT_MOC_LITERAL(5, 53, 16), // "driver_wind_mode"
QT_MOC_LITERAL(6, 70, 19), // "passenger_wind_mode"
QT_MOC_LITERAL(7, 90, 9), // "fan_level"
QT_MOC_LITERAL(8, 100, 9), // "auto_mode"
QT_MOC_LITERAL(9, 110, 9) // "sync_mode"

    },
    "ClimateModel\0dataChanged\0\0driver_temp\0"
    "passenger_temp\0driver_wind_mode\0"
    "passenger_wind_mode\0fan_level\0auto_mode\0"
    "sync_mode"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_ClimateModel[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       1,   14, // methods
       7,   20, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   19,    2, 0x06 /* Public */,

 // signals: parameters
    QMetaType::Void,

 // properties: name, type, flags
       3, QMetaType::Double, 0x00495001,
       4, QMetaType::Double, 0x00495001,
       5, QMetaType::Int, 0x00495001,
       6, QMetaType::Int, 0x00495001,
       7, QMetaType::Int, 0x00495001,
       8, QMetaType::Int, 0x00495001,
       9, QMetaType::Int, 0x00495001,

 // properties: notify_signal_id
       0,
       0,
       0,
       0,
       0,
       0,
       0,

       0        // eod
};

void ClimateModel::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<ClimateModel *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->dataChanged(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (ClimateModel::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&ClimateModel::dataChanged)) {
                *result = 0;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<ClimateModel *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< double*>(_v) = _t->GetDriverTemperature(); break;
        case 1: *reinterpret_cast< double*>(_v) = _t->GetPassengerTemperature(); break;
        case 2: *reinterpret_cast< int*>(_v) = _t->GetDriverWindMode(); break;
        case 3: *reinterpret_cast< int*>(_v) = _t->GetPassengerWindMode(); break;
        case 4: *reinterpret_cast< int*>(_v) = _t->GetFanLevel(); break;
        case 5: *reinterpret_cast< int*>(_v) = _t->GetAutoMode(); break;
        case 6: *reinterpret_cast< int*>(_v) = _t->GetSyncMode(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
    Q_UNUSED(_a);
}

QT_INIT_METAOBJECT const QMetaObject ClimateModel::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_ClimateModel.data,
    qt_meta_data_ClimateModel,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *ClimateModel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *ClimateModel::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_ClimateModel.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int ClimateModel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 1)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 1;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 1)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 1;
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 7;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 7;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 7;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 7;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 7;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 7;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void ClimateModel::dataChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
