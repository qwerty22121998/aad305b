import QtQuick 2.6
import QtQuick.Controls 2.4

Item {
    width: 1920 * appConfig.w_ratio
    height: (1200 - 104) * appConfig.h_ratio
    //Header
    AppHeader {
        id: headerItem
        width: parent.width
        height: 70 * appConfig.h_ratio
        playlistButtonStatus: playlist.opened ? 1 : 0
        onClickPlaylistButton: {
            if (!playlist.opened) {
                playlist.open()
            } else {
                playlist.close()
            }
        }
    }

    //Playlist
    PlaylistView {
        id: playlist
        y: (70 + 104) * appConfig.h_ratio
        width: 675 * appConfig.w_ratio
        height: parent.height - headerItem.height
    }

    //Media Info
    MediaInfoControl {
        id: mediaInfoControl
        anchors.top: headerItem.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.leftMargin: playlist.position * playlist.width
        anchors.bottom: parent.bottom
    }
}
