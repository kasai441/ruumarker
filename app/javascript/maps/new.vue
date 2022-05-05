<template>
  <div id="maps-new">
    <image-upload target-model="map"></image-upload>
  </div>
</template>

<script>
import ImageUpload from '../components/image_upload.vue'

export default {
  name: 'MapsNew',
  inject: [
    'roomId'
  ],
  data() {
    return {
      formData: null,
    }
  },
  components: {
    ImageUpload
  }
}
</script>
