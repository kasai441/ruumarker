import 'core-js/stable'
import 'regenerator-runtime/runtime'
import { createApp } from 'vue'
import router from '../modules/router.js'
import MapsNew from './new.vue'

document.addEventListener('turbo:load', () => {
  const selector = '#maps-new'
  const maps_new = document.querySelector(selector)

  if (maps_new) {
    const roomId = maps_new.getAttribute('room_id')
    const app = createApp(MapsNew)
    app.use(router)
    app.provide('roomId', roomId)
    app.mount(selector)
  }
})
