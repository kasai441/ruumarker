import { createApp } from 'vue'
import MapsEdit from './views/maps_edit.vue'
import MapsNew from './views/maps_new.vue'
import RoomsShow from './views/rooms_show.vue'

document.addEventListener('turbo:load', () => {
  const selectors = [
    '#maps-edit',
    '#maps-new',
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
      case 'maps-new':
        app = createApp(MapsNew)
        break
      case 'rooms-show':
        app = createApp(RoomsShow)
        break
      }
      app.provide('roomId', element.getAttribute('room_id'))
      app.provide('mapId', element.getAttribute('map_id'))
      app.provide('imageUrl', element.getAttribute('image_url'))
      app.provide('trimming', element.getAttribute('trimming'))
      app.mount(selector)
    }
  })
})
