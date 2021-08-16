#include <QDebug>
#include <QGuiApplication>
#include <QMediaPlaylist>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QScreen>

#include "App/Climate/climatemodel.h"
#include "App/Media/player.h"
#include "App/Media/playlistmodel.h"
#include "appconfig.h"
#include "applicationsmodel.h"
#include "xmlreader.h"
#include "xmlwriter.h"

int main(int argc, char *argv[]) {
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  qRegisterMetaType<QMediaPlaylist *>("QMediaPlaylist*");

  QGuiApplication app(argc, argv);

  QQmlApplicationEngine engine;

  ApplicationsModel appsModel;
  XmlReader *xmlReader = new XmlReader("applications.xml", appsModel);

  XmlWriter *xmlWriter = new XmlWriter();
  xmlWriter->BindXml("applications.xml", &appsModel);
  engine.rootContext()->setContextProperty("xmlReader", xmlReader);
  engine.rootContext()->setContextProperty("xmlWriter", xmlWriter);
  engine.rootContext()->setContextProperty("appsModel", &appsModel);

  Player *player = new Player();
  engine.rootContext()->setContextProperty("myModel", player->m_playlistModel);
  engine.rootContext()->setContextProperty("player", player->m_player);
  engine.rootContext()->setContextProperty("utility", player);

  ClimateModel *climate = new ClimateModel();
  engine.rootContext()->setContextProperty("climateModel", climate);

  AppConfig *config = new AppConfig(app.primaryScreen()->size());
  engine.rootContext()->setContextProperty("appConfig", config);

  qDebug() << config->getWRatio() << " " << config->getHRatio() << Qt::endl;

  const QUrl url(QStringLiteral("qrc:/Qml/main.qml"));
  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreated, &app,
      [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) QCoreApplication::exit(-1);
      },
      Qt::QueuedConnection);
  engine.load(url);
  // notify signal to QML read data from dbus
  emit climate->dataChanged();

  return app.exec();
}
