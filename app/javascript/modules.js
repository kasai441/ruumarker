import tags from './modules/tags'

window.addEventListener('popstate', () => {
  tags.browserBack()
})

const homeIndex = document.getElementById('home-index')
const helpIndex = document.getElementById('help-index')
if (homeIndex || helpIndex) {
  tags.homeTop()
  tags.displayHome()
} else {
  tags.displayHelp()
}

const roomsShow = document.getElementById('rooms-show')
if (roomsShow) {
  const roomId = roomsShow.getAttribute('room_id')
  tags.displayPrint(roomId)
}

const mapsEdit = document.getElementById('maps-edit')
const marksEdit = document.getElementById('marks-edit')
if (mapsEdit || marksEdit) {
  tags.preventSafariAddressBarPop()
}
