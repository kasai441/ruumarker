import 'core-js/stable'
import 'regenerator-runtime/runtime'

import { createApp } from 'vue'
import { createStore } from 'vuex'
import mark from './mark.vue'
import posts from './modules/posts'

document.addEventListener('turbo:load', () => {
  const selector = '#image-edit'
  const image_edits = document.querySelector(selector)

  if (image_edits) {
    const room_id = image_edits.getAttribute('room_id')
    console.log(room_id)
    const description = image_edits.getAttribute('description')
    const location = image_edits.getAttribute('location')
    const image = image_edits.getAttribute('image')

    const app = createApp(mark)
    app.provide('roomId', room_id)

    const store = createStore({
      modules: {
        posts
      }
    })
    app.use(store)
    const vm = app.mount(selector)

    // vm.roomId = room_id
    // vm.description = description;
    // vm.location = location;
    // vm.image = image;
  }
})
