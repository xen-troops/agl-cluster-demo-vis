#ifndef DISPLAY_MANAGER_CLIENT_HPP
#define DISPLAY_MANAGER_CLIENT_HPP

#include <QDebug>
#include <QtDBus/QDBusInterface>
#include <QtDBus/QDBusReply>

class DisplayManagerClient : public QObject
{
    Q_OBJECT

public:
    explicit DisplayManagerClient(QObject *parent = nullptr)
        : QObject(parent),
          mDBus("com.epam.DisplayManager", "/com/epam/DisplayManager",
                "com.epam.DisplayManager.Control")
    {
        qDebug() << "Create DisplayManager client";
    }
    ~DisplayManagerClient() { qDebug() << "Delete DisplayManager client"; }

    Q_INVOKABLE void userEvent(unsigned int id)
    {
        qDebug() << "Send userEvent:" << id;

        mDBus.call(QDBus::CallMode::NoBlock, "userEvent", static_cast<uint32_t>(id));
    }

private:
    QDBusInterface mDBus;
};

#endif // DISPLAY_MANAGER_CLIENT_HPP