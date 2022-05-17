import { createApp } from 'vue'
import RoomsShow from './views/rooms_show.vue'
import MapsNew from './views/maps_new.vue'
import MapsEdit from './views/maps_edit.vue'
import MarksEdit from './views/marks_edit.vue'

document.addEventListener('turbo:load', () => {
  const selectors = [
    '#rooms-show',
    '#maps-new',
    '#maps-edit',
    '#marks-edit'
  ]
  selectors.forEach((selector) => {
    let app
    let element = document.querySelector(selector)
    if (element) {
      console.log(`element-id: ${element.id}`)
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
      }
      app.provide('roomId', element.getAttribute('room_id'))
      app.provide('mark', element.getAttribute('mark'))
      app.provide('map', element.getAttribute('map'))
      app.mount(selector)
    }
  })
})
