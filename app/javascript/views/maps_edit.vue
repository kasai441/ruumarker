<template>
  <section v-if="formData" class="flex flex-col items-center">
    <image-edit :formData="formData" target-model="map" @emitFormData="getFormData"></image-edit>
    <image-upload target-model="map" @emitFormData="getFormData"></image-upload>
    <image-update :id="mapId" :formData="formData" target-model="map"></image-update>
  </section>
</template>

<script>
import ImageEdit from '../components/image_edit.vue'
import ImageUpload from '../components/image_upload.vue'
import ImageUpdate from '../components/image_update.vue'
import api from '../modules/api'

export default {
  name: 'MapsEdit',
  inject: [
    'roomId',
    'mapId'
  ],
  data() {
    return {
      isImageEdit: false,
      formData: null
    }
  },
  components: {
    ImageEdit,
    ImageUpload,
    ImageUpdate
  },
  methods: {
    getFormData(formData) {
      this.formData = formData
    }
  },
  async created() {
    const response = await api.actions.show(`/api/rooms/${this.roomId}/maps/${this.mapId}.json`)
    this.formData = new FormData()
    this.formData.append('map[trimming]', response.trimming)
    this.formData.append('map[image_url]', response.image_url)
    console.log(response)
    console.log(this.formData.get('map[image_url]'))
  }
}
</script>
