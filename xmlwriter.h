#ifndef XMLWRITER_H
#define XMLWRITER_H
#include <QFile>
#include <QObject>
#include <QtXml>

#include "applicationsmodel.h"

class XmlWriter : public QObject {
  Q_OBJECT
 public:
  explicit XmlWriter(QObject *parent = nullptr);
  void BindXml(QString filePath, ApplicationsModel *model);
 public slots:
  void saveXml();

 private:
  QString m_filePath;
  ApplicationsModel *m_model;
};
#endif  // XMLWRITER_H
