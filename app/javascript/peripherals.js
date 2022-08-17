import visuals from './modules/visuals'

window.addEventListener('popstate', () => {
  visuals.browserBack()
})

const homeIndex = document.getElementById('home-index')
if (homeIndex) {
  visuals.homeTop()
}
const helpIndex = document.getElementById('help-index')
if (helpIndex) {
  visuals.displayHome()
}

if (!homeIndex && !helpIndex) {
  visuals.displayHelp()
}

const mapsEdit = document.getElementById('maps-edit')
const marksEdit = document.getElementById('marks-edit')
const roomsShow = document.getElementById('rooms-show')
const reportsIndex = document.getElementById('reports-index')
if (mapsEdit || marksEdit || roomsShow || reportsIndex) {
  visuals.preventSafariAddressBarPop()
}
