<template>
  <section>
    <image-show :room-id="roomId" :id="mapId" field-model="map" :image-url="mapImageUrl" :trimming="mapTrimming"
                locators-model="mark" :locators-json="marks"
                @emit-form-data="getFormData"></image-show>
  </section>
</template>

<script>
import ImageShow from '../components/image_show.vue'

export default {
  name: 'RoomsShow',
  inject: [
    'roomId',
    'map',
    'marks'
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
