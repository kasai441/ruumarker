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
    'map'
  ],
  data() {
    return {
      mapId: null,
      mapImageUrl: null,
      mapTrimming: null,
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
  },
  created() {
    const map = JSON.parse(this.map)
    this.mapId = map['id']
    this.mapImageUrl = map['image_url']
    this.mapTrimming = map['trimming']
  }
}
</script>
