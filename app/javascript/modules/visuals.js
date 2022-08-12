const loadingFilter = isLoading => {
  const loadingFilter = document.getElementById('loading-filter')
  if (isLoading) {
    loadingFilter.classList.remove('hidden')
  } else {
    loadingFilter.classList.add('hidden')
  }
}

const homeTop = () => {
  const homeTop = document.getElementById('home-top')
  if (!homeTop) return

  homeTop.addEventListener('click', () => {
    window.scrollTo({
      behavior: 'smooth',
      left: 0,
      top: 0
    })
  })
}

const displayHome = () => {
  const home = document.getElementById('home')
  home.classList.remove('hidden')
}

const displayHelp = () => {
  const help = document.getElementById('help')
  help.classList.remove('hidden')
  help.addEventListener('click', () => {
    help.classList.add('animate-fadeout')
    location.href = '/help'
  })
}

const displayPrint = roomId => {
  const download = document.getElementById('download')
  download.classList.remove('hidden')
  download.addEventListener('click', () => {
    download.classList.add('animate-fadeout')
    location.href = `/rooms/${roomId}/reports`
  })
}

const hideBars = () => {
  const titleBar = document.getElementById('title-bar')
  titleBar.classList.add('hidden')
  const titleBarSpace = document.getElementById('title-bar-space')
  titleBarSpace.classList.add('hidden')
  const footerBar = document.getElementById('footer-bar')
  footerBar.classList.add('hidden')
}

const preventSafariAddressBarPop = () => {
  const div = document.getElementById('screen-scroll')
  div.classList.add('overflow-scroll', 'h-screen')
}

const browserBack = () => {
  const fadeouts = document.getElementsByClassName('animate-fadeout')
  Array.prototype.forEach.call(fadeouts, fadeout => {
    fadeout.classList.remove('animate-fadeout')
  })

  const selects = document.getElementsByClassName('animate-select')
  Array.prototype.forEach.call(selects, select => {
    select.classList.remove('animate-select')
  })
}

const alertError = message => {
  const alert = document.getElementById('alert')
  alert.innerText = message
  alert.classList.add('alert', 'alert-error', 'mt-2')

  alert.addEventListener('click', fadeAlert)
}

const fadeAlert = () => {
  const alert = document.getElementById('alert')
  alert.innerText = ''
  alert.classList.remove('alert', 'alert-error', 'mt-2')
}

export default {
  namespaced: true,
  loadingFilter,
  homeTop,
  displayHome,
  displayHelp,
  displayPrint,
  hideBars,
  preventSafariAddressBarPop,
  browserBack,
  alertError,
  fadeAlert
}
