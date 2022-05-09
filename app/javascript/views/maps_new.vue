<template>
  <section id="maps-new">
    <image-preview sample-image="/sample.png"></image-preview>
    <image-upload target-model="map" @emitFormData="getFormData"></image-upload>
  </section>
</template>

<script>
import ImageUpload from '../components/image_upload.vue'
import ImagePreview from '../components/image_preview.vue'
import api from '../modules/api'

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
    ImagePreview,
    ImageUpload
  },
  methods: {
    getFormData(formData) {
      this.formData = formData
      this.create()
    },
    async create() {
      await api.actions.create(`/api/rooms/${this.roomId}/maps`, this.formData)
      location.href = `/rooms/${this.roomId}`
    }
  }
}
</script>
