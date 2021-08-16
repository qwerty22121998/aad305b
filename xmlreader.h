#ifndef XMLREADER_H
#define XMLREADER_H
#include <QFile>
#include <QObject>
#include <QtXml>

#include "applicationsmodel.h"

class XmlReader : public QObject {
 public:
  XmlReader(QString filePath, ApplicationsModel &model);

 private:
  QDomDocument m_xmlDoc;  // The QDomDocument class represents an XML document.
  bool ReadXmlFile(QString filePath);
  void PaserXml(ApplicationsModel &model);
  void saveXml(QList<ApplicationItem> list);
  QString m_filePath;
};

#endif  // XMLREADER_H
