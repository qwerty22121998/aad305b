#include "xmlreader.h"

XmlReader::XmlReader(QString filePath, ApplicationsModel &model) {
  ReadXmlFile(filePath);
  PaserXml(model);
}

bool XmlReader::ReadXmlFile(QString filePath) {
  // Load xml file as raw data
  m_filePath = PROJECT_PATH + filePath;
  QFile f(m_filePath);
  if (!f.open(QIODevice::ReadOnly)) {
    // Error while loading file
    qDebug() << "error when read file " << m_filePath << Qt::endl;
    return false;
  }
  // Set data into the QDomDocument before processing
  m_xmlDoc.setContent(&f);
  f.close();
  return true;
}

void XmlReader::PaserXml(ApplicationsModel &model) {
  // Extract the root markup
  QDomElement root = m_xmlDoc.documentElement();

  // Get the first child of the root (Markup COMPONENT is expected)
  QDomElement Component = root.firstChild().toElement();

  // Loop while there is a child
  while (!Component.isNull()) {
    // Check if the child tag name is COMPONENT
    if (Component.tagName() == "APP") {
      // Read and display the component ID
      QString ID = Component.attribute("ID", "No ID");

      // Get the first child of the component
      QDomElement Child = Component.firstChild().toElement();

      QString title;
      QString url;
      QString iconPath;

      // Read each child of the component node
      while (!Child.isNull()) {
        // Read Name and value
        if (Child.tagName() == "TITLE")
          title = Child.firstChild().toText().data();
        if (Child.tagName() == "URL") url = Child.firstChild().toText().data();
        if (Child.tagName() == "ICON_PATH")
          iconPath = Child.firstChild().toText().data();

        // Next child
        Child = Child.nextSibling().toElement();
      }
      ApplicationItem item(title, url, iconPath);
      model.addApplication(item);
    }

    // Next component
    Component = Component.nextSibling().toElement();
  }
}

void XmlReader::saveXml(QList<ApplicationItem> listData) {
  QFile file(m_filePath);
  file.remove();
  if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate |
                 QIODevice::Text)) {
    qDebug() << "Save file error!!";
    file.close();
    return;
  }
  QString clear = "";
  m_xmlDoc.setContent(clear);
  QDomElement root = m_xmlDoc.createElement("APPLICATIONS");
  m_xmlDoc.appendChild(root);
  for (ApplicationItem item : listData) {
    QDomElement tagApp = m_xmlDoc.createElement("APP");
    tagApp.setAttribute("ID", "");
    root.appendChild(tagApp);

    QDomElement tagTitle = m_xmlDoc.createElement("TITLE");
    tagApp.appendChild(tagTitle);
    QDomText title = m_xmlDoc.createTextNode(item.title());
    tagTitle.appendChild(title);

    QDomElement tagURL = m_xmlDoc.createElement("URL");
    tagApp.appendChild(tagURL);
    QDomText url = m_xmlDoc.createTextNode(item.url());
    tagURL.appendChild(url);

    QDomElement tagIcon = m_xmlDoc.createElement("ICON_PATH");
    tagApp.appendChild(tagIcon);
    QDomText icon = m_xmlDoc.createTextNode(item.iconPath());
    tagIcon.appendChild(icon);
  }
  QTextStream output(&file);
  // qDebug() << m_xmlDoc.toString();
  output << m_xmlDoc.toString();
  file.close();
  qDebug() << "Save file success!!";
}
