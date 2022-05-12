<template>
  <section>
    <image-show :id="mapId" :image-url="imageUrl" :trimming="trimming" target-model="map" @emit-form-data="getFormData"></image-show>
  </section>
</template>

<script>
import ImageShow from '../components/image_show.vue'

export default {
  name: 'RoomsShow',
  inject: [
    'roomId',
    'mapId',
    'imageUrl',
    'trimming'
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
