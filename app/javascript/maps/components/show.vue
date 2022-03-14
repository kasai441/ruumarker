<template>
  <div>
    <h2>MapShow</h2>
    <div>
      <h3 v-if="map">{{ map.trimming }}</h3>
      <img v-if="response" :src="response.image_url" />
    </div>
    <p>{{ parentMessage }}</p>
    <p>{{ response }}</p>
  </div>
</template>

<script>
import api from '../../modules/api'

export default {
  name: 'MapShow',
  // inject: ['roomId'],
  props: [
    'parentMessage',
    'response'
  ],
  data() {
    return {
      map: '',
      trimming: '',
      // image: '',
      // imageFile: null
    }
  },
  methods: {
    show(id) {
      this.map = api.actions.show('maps', id)
    }
  }
}
</script>
