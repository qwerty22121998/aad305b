ndef CONFIG_H
#define CONFIG_H


#include <QObject>
#include <QSize>

struct ScreenSize {
  QSize default_size;
  QSize device_size;
};

class Config : public QObject {
  Q_OBJECT
  Q_PROPERTY(qreal w_ratio READ getWRatio NOTIFY sizeChanged)
  Q_PROPERTY(qreal h_ratio READ getHRatio NOTIFY sizeChanged)
 public:
  explicit Config(QSize device, QObject *parent = nullptr);
  qreal getWRatio();
  qreal getHRatio();
 public slots:

 signals:
  void sizeChanged();

 public:
  ScreenSize screen_size;
};

#endif // CONFIG_H
