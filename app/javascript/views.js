import { createApp } from 'vue'
import MapsEdit from './views/maps_edit.vue'
import MarksEdit from './views/marks_edit.vue'
import ReportsIndex from './views/reports_index.vue'
import RoomsNew from './views/rooms_new.vue'
import RoomsShow from './views/rooms_show.vue'

document.addEventListener('turbo:load', () => {
  const selectors = [
    '#maps-edit',
    '#marks-edit',
    '#reports-index',
    '#rooms-new',
    '#rooms-show'
  ]
  selectors.forEach((selector) => {
    let app
    let element = document.querySelector(selector)
    if (element) {
      switch (element.id) {
      case 'maps-edit':
        app = createApp(MapsEdit)
        break
      case 'marks-edit':
        app = createApp(MarksEdit)
        break
      case 'reports-index':
        app = createApp(ReportsIndex)
        break
      case 'rooms-new':
        app = createApp(RoomsNew)
        break
      case 'rooms-show':
        app = createApp(RoomsShow)
        break
      }
      app.provide('map', element.getAttribute('map'))
      app.provide('marks', element.getAttribute('marks'))
      app.provide('mark', element.getAttribute('mark'))
      app.provide('roomCreatedAt', element.getAttribute('room_created_at'))
      app.provide('roomId', element.getAttribute('room_id'))
      app.mount(selector)
    }
  })
})
