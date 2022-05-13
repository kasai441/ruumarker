<template>
  <section>
    <image-show :id="mapId" :image-url="mapImageUrl" :trimming="mapTrimming" target-model="map" @emit-form-data="getFormData"></image-show>
  </section>
</template>

<script>
import ImageShow from '../components/image_show.vue'

export default {
  name: 'RoomsShow',
  inject: [
    'roomId',
    'mapId',
    'mapImageUrl',
    'mapTrimming'
  ],
  data() {
    return {
      formData: null
    }
  },
  components: {
    ImageShow
  },
  methods: {
    getFormData(formData) {
      this.formData = formData
    }
  }
}
</script>
