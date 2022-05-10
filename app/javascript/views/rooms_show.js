import { createApp } from 'vue'
import RoomsShow from './rooms_show.vue'

document.addEventListener('turbo:load', () => {
  const selector = '#rooms-show'
  const rooms_show = document.querySelector(selector)

  if (rooms_show) {
    const roomId = rooms_show.getAttribute('room_id')
    const mapId = rooms_show.getAttribute('map_id')
    const app = createApp(RoomsShow)
    app.provide('roomId', roomId)
    app.provide('mapId', mapId)
    app.mount(selector)
  }
})
