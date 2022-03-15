<template>
  <div id="map-new">
    <map-show v-if="response" v-bind:response="response"></map-show>
    <image-upload v-else @upload="receive" targetModel="map"></image-upload>
  </div>
</template>

<script>
import mapShow from '../components/show.vue'
import ImageUpload from '../components/image_upload.vue'

export default {
  name: 'MapNew',
  inject: ['roomId'],
  data() {
    return {
      image: '',
      response: null,
    }
  },
  components: {
    ImageUpload,
    mapShow
  },
  methods: {
    receive(response){
      this.response = response
    }
  }
}
</script>
