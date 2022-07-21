import { createApp } from 'vue'
import RoomsShow from './views/rooms_show.vue'
import MapsNew from './views/maps_new.vue'
import MapsEdit from './views/maps_edit.vue'
import MarksEdit from './views/marks_edit.vue'
import ReportsIndex from './views/reports_index.vue'
import tags from './modules/tags'

tags.help()
window.addEventListener('popstate', () => {
  tags.browserBack()
})

document.addEventListener('turbo:load', () => {
  const selectors = [
    '#rooms-show',
    '#maps-new',
    '#maps-edit',
    '#marks-edit',
    '#reports-index'
  ]
  selectors.forEach((selector) => {
    let app
    let element = document.querySelector(selector)
    if (element) {
      switch (element.id) {
      case 'rooms-show':
        app = createApp(RoomsShow)
        break
      case 'maps-new':
        app = createApp(MapsNew)
        break
      case 'maps-edit':
        app = createApp(MapsEdit)
        break
      case 'marks-edit':
        app = createApp(MarksEdit)
        break
      case 'reports-index':
        app = createApp(ReportsIndex)
        break
      }
      app.provide('roomId', element.getAttribute('room_id'))
      app.provide('roomCreatedAt', element.getAttribute('room_created_at'))
      app.provide('map', element.getAttribute('map'))
      app.provide('marks', element.getAttribute('marks'))
      app.provide('mark', element.getAttribute('mark'))
      app.mount(selector)
    }
  })
})
