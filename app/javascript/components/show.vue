<template>
  <div>
    <h2>MapShow</h2>
    <div>
      <h3 v-if="map">{{ map.trimming }}</h3>
      <img v-if="response" :src="response.image_url" />
      <img v-else />
    </div>
    <p>{{ response }}</p>
  </div>
</template>

<script>
import api from '../modules/api'

export default {
  name: 'MapShow',
  inject: ['roomId'],
  props: [
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
    window:onload = async function() {
      this.map = await api.actions.show('')
      console.log('HOHOH')
    }
  }
}
</script>
