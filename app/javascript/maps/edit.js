import { createApp } from 'vue'
import MapsEdit from './edit.vue'

document.addEventListener('turbo:load', () => {
  const selector = '#maps-edit'
  const maps_edit = document.querySelector(selector)

  if (maps_edit) {
    const roomId = maps_edit.getAttribute('room_id')
    const mapId = maps_edit.getAttribute('map_id')
    const imageUrl = maps_edit.getAttribute('image_url')
    const app = createApp(MapsEdit)
    app.provide('roomId', roomId)
    app.provide('mapId', mapId)
    app.provide('imageUrl', imageUrl)
    app.mount(selector)
  }
})
