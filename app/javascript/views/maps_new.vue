<template>
  <section>
    <div class="px-4 sm:px-6 md:px-8 pt-4 sm:pt-6 md:pt-8 flex flex-col items-center text-center">
      <h1 class="p-4 text-2xl font-bold">間取り画像のアップロード</h1>
      <p class="p-4 mx-8 text-sm sm:mx-32 lg:mx-48">お部屋の間取り画像をアップロードします。画像は端末に保存されてるものを選択するか、スマホの場合はカメラで画像として取り込んで、アップロードできます。</p>
      <image-preview sample-image="/sample.png"></image-preview>
      <image-upload target-model="map" @emit-form-data="getFormData"></image-upload>
    </div>
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
