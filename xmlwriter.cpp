#include "xmlwriter.h"

#include <QTextStream>

XmlWriter::XmlWriter(QObject *parent) : QObject(parent) {}

void XmlWriter::BindXml(QString filePath, ApplicationsModel *model) {
  m_filePath = filePath;
  m_model = model;
}

void XmlWriter::saveXml() {
  QFile file(PROJECT_PATH + m_filePath);

  if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate |
                 QIODevice::Text)) {
    file.close();
    return;
  }

  QDomDocument m_xmlDoc;
  QDomElement root = m_xmlDoc.createElement("APPLICATIONS");
  m_xmlDoc.appendChild(root);
  for (int i = 0; i < m_model->rowCount(); i++) {
    ApplicationItem app = m_model->applicationAt(i);
    QDomElement tagApp = m_xmlDoc.createElement("APP");
    tagApp.setAttribute("ID", i);
    root.appendChild(tagApp);

    QDomElement tagTitle = m_xmlDoc.createElement("TITLE");
    tagApp.appendChild(tagTitle);
    QDomText title = m_xmlDoc.createTextNode(app.title());
    tagTitle.appendChild(title);

    QDomElement tagURL = m_xmlDoc.createElement("URL");
    tagApp.appendChild(tagURL);
    QDomText url = m_xmlDoc.createTextNode(app.url());
    tagURL.appendChild(url);

    QDomElement tagIcon = m_xmlDoc.createElement("ICON_PATH");
    tagApp.appendChild(tagIcon);
    QDomText icon = m_xmlDoc.createTextNode(app.iconPath());
    tagIcon.appendChild(icon);
  }
  QTextStream output(&file);
  output << m_xmlDoc.toString();
  file.close();
}
