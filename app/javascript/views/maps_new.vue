<template>
  <section>
    <div class="flex flex-col items-center">
      <div class="w-field">
        <h2 class="font-h2">間取り画像のアップロード</h2>
        <p class="font-p">お部屋の間取り画像をアップロードします。画像は端末に保存されてるものを選択するか、スマホの場合はカメラで画像として取り込んで、アップロードできます。</p>
      </div>
      <div id="preview-field" class="w-field h-field rounded-lg bg-white outline outline-3 outline-slate-200">
        <img id="preview-image" src="/sample.png" class="object-contain w-field h-field rounded-lg">
      </div>
      <image-upload target-model="map" @emit-form-data="getFormData"></image-upload>
    </div>
  </section>
</template>

<script>
import ImageUpload from '../components/image_upload.vue'
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
