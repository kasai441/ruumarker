import tags from './modules/tags'

window.addEventListener('popstate', () => {
  tags.browserBack()
})

tags.homeTop()

const homeIndex = document.getElementById('home-index')
const helpIndex = document.getElementById('help-index')
if (homeIndex || helpIndex) {
  tags.displayHome()
} else {
  tags.displayHelp()
}

const roomsShow = document.getElementById('rooms-show')
if (roomsShow) {
  const roomId = roomsShow.getAttribute('room_id')
  tags.displayPrint(roomId)
}
