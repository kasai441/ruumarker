<template>
  <section>
    <div class="flex flex-col items-center" @touchmove.prevent>
      <image-edit :formData="formData" target-model="map" @emitFormData="getFormData"></image-edit>
      <image-upload target-model="map" @emitFormData="getFormData"></image-upload>
      <image-update :id="mapId" :formData="formData" target-model="map"></image-update>
    </div>
  </section>
</template>

<script>
import ImageEdit from '../components/image_edit.vue'
import ImageUpload from '../components/image_upload.vue'
import ImageUpdate from '../components/image_update.vue'

export default {
  name: 'MapsEdit',
  inject: [
    'roomId',
    'mapId',
    'imageUrl',
    'trimming'
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
    if (this.formData) return

    this.formData = new FormData()
    this.formData.append('map[image_url]', this.imageUrl)
    this.formData.append('map[trimming]', this.trimming)
  }
}
</script>
