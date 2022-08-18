<template>
  <section>
    <div class="w-full flex flex-col items-center">
      <div class="w-show-field">
        <h2 class="font-h2">間取り画像のアップロード</h2>
        <p class="font-p">お部屋の間取り画像をアップロードします。画像は端末に保存されてるものを選択するか、スマホの場合はカメラで画像として取り込んで、アップロードできます。</p>
      </div>
      <div id="preview-field" class="relative w-show-field h-show-field rounded-lg bg-white outline outline-3 outline-slate-200">
        <img id="preview-image" src="/sample_map.png"
             class="absolute object-contain w-show-field h-show-field rounded-lg opacity-50">
        <div v-if="isLoading" class="w-show-field h-show-field flex justify-center items-center">
          <div class="animate-ping h-20 w-20 bg-white rounded-full"></div>
        </div>
      </div>
      <div class="flex justify-center p-8">
        <image-upload target-model="map" @emit-form-data="getFormData"
                      @emit-is-loading="getIsLoading"></image-upload>
      </div>
      <div class="main-screen font-help-sm">
        <p class="p-1">
          ※ 作った入居時チェック表のURLは、知っていれば誰でもアクセスできるので、手元で保管し、不特定な他人に閲覧されないようにしてください。
        </p>
        <p class="p-1">
          ※ このウェブサイトの入居時チェック表作成データは作成開始から約10日で消えてしまいます。PDFとしてダウンロードできるので、手元で保存するようにしてください。
        </p>
      </div>
    </div>
  </section>
</template>

<script>
import ImageUpload from '../components/image_upload.vue'
import api from '../modules/api'
import visuals from '../modules/visuals'

export default {
  name: 'RoomsNew',
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
      const response = await api.actions.create('/api/rooms', this.formData)
      if (response !== 'error') location.href = `/rooms/${response.data.id}`
    }
  },
  updated() {
    visuals.loadingFilter(this.isLoading)
  }
}
</script>
