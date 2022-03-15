<template>
  <div id="maps-new">
    <image-show v-if="response" v-bind:response="response"></image-show>
    <image-upload v-else @upload="receive" targetModel="map"></image-upload>
  </div>
</template>

<script>
import ImageShow from '../components/image_show.vue'
import ImageUpload from '../components/image_upload.vue'

export default {
  name: 'MapsNew',
  inject: ['roomId'],
  data() {
    return {
      image: '',
      response: null,
    }
  },
  components: {
    ImageUpload,
    ImageShow
  },
  methods: {
    receive(response){
      this.response = response
    }
  }
}
</script>
