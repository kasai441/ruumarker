<template>
  <section>
    <image-show :id="mapId" :imageUrl="imageUrl" :trimming="trimming" target-model="map" @emitFormData="getFormData"></image-show>
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
