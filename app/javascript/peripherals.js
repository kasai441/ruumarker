import visuals from './modules/visuals'

visuals.preventSafariAddressBarPop()

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
