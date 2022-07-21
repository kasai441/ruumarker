<template>
  <section>
    <div class="w-full flex flex-col items-center">
      <div class="w-field">
        <h2 class="font-h2">間取り画像のアップロード</h2>
        <p class="font-p">お部屋の間取り画像をアップロードします。画像は端末に保存されてるものを選択するか、スマホの場合はカメラで画像として取り込んで、アップロードできます。</p>
      </div>
      <div id="preview-field" class="relative w-field h-field rounded-lg bg-white outline outline-3 outline-slate-200">
        <img id="preview-image" src="/sample_map.png"
             class="absolute object-contain w-field h-field rounded-lg opacity-50">
        <div v-if="isLoading" class="w-field h-field flex justify-center items-center">
          <div class="animate-ping h-20 w-20 bg-white rounded-full"></div>
        </div>
      </div>
      <div class="flex justify-center p-8">
        <image-upload target-model="map" @emit-form-data="getFormData"
                      @emit-is-loading="getIsLoading"></image-upload>
      </div>
    </div>
  </section>
</template>

<script>
import ImageUpload from '../components/image_upload.vue'
import api from '../modules/api'
import tags from '../modules/tags'

export default {
  name: 'MapsNew',
  inject: [
    'roomId'
  ],
  data() {
    return {
      formData: null,
      isLoading: false
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
    getIsLoading(bool) {
      this.isLoading = bool
    },
    async create() {
      await api.actions.create(`/api/rooms/${this.roomId}/maps`, this.formData)
      location.href = `/rooms/${this.roomId}`
    },
    browserBack() {
      tags.browserBack()
    }
  },
  updated() {
    tags.loadingFilter(this.isLoading)
  },
  mounted() {
    window.addEventListener('popstate', this.browserBack)
  },
  beforeDestroy() {
    window.removeEventListener('popstate', this.browserBack)
  }
}
</script>
