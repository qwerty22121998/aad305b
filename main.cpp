#include <QGuiApplication>
#include <QScreen>
#include <QQmlApplicationEngine>
#include <QMediaPlaylist>
#include "App/Media/player.h"
#include <QQmlContext>
#include "App/Media/playlistmodel.h"
#include "App/Climate/climatemodel.h"
#include "applicationsmodel.h"
#include "xmlreader.h"
#include "appconfig.h"

#include <QDebug>


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    qRegisterMetaType<QMediaPlaylist*>("QMediaPlaylist*");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    ApplicationsModel appsModel;
    XmlReader xmlReader("applications.xml", appsModel);
    engine.rootContext()->setContextProperty("appsModel", &appsModel);

    Player *player = new Player();
    engine.rootContext()->setContextProperty("myModel",player->m_playlistModel);
    engine.rootContext()->setContextProperty("player",player->m_player);
    engine.rootContext()->setContextProperty("utility",player);

    ClimateModel *climate = new ClimateModel();
    engine.rootContext()->setContextProperty("climateModel",climate);

    AppConfig *config = new AppConfig(app.primaryScreen()->size());
    engine.rootContext()->setContextProperty("appConfig", config);

    qDebug() << config->getWRatio() << " " << config->getHRatio() << Qt::endl;

    const QUrl url(QStringLiteral("qrc:/Qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    //notify signal to QML read data from dbus
    emit climate->dataChanged();

    return app.exec();
}
