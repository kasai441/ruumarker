<template>
  <section id="image-upload">
    <label for="file"
           @pointerdown="loadable" @pointerup="loading">
      <div v-if="isFirstUpload">
        <a class="btn btn-lime py-0 h-16">
          <div class="flex flex-col items-center">
            <p class="font-btn text-white">
              アップロード
            </p>
            <img src="/upload_trans.png" width="40" height="40">
          </div>
        </a>
      </div>
      <div v-else class="w-full flex flex-col items-center">
        <p class="font-btn">アップロード</p>
        <img src="/upload.png" width="40">
      </div>
    </label>
    <input type="file" id="file" name="upload-image"
           accept="image/png,image/jpeg,image/gif" @change="upload"
           class="hidden"
    />
  </section>
</template>

<script>
import params from '../modules/params'
import visuals from '../modules/visuals'

export default {
  name: 'ImageUpload',
  props: [
    'formData',
    'targetModel'
  ],
  data() {
    return {
      isLoadable: false,
      isLoading: false,
      isFirstUpload: true
    }
  },
  methods: {
    loadable() {
      this.isLoadable = true
      visuals.fadeAlert()
    },
    loading() {
      if (this.isLoadable) {
        document.body.onfocus = this.dialogEnding
        this.isLoadable = false
      }
    },
    dialogEnding() {
      this.$emit('emitIsLoading', true)
      this.emitIsLoadingFalseLater()
      document.body.onfocus = null
    },
    emitIsLoadingFalseLater() {
      setTimeout(() => {
        if (this.isLoading) {
          this.emitIsLoadingFalseLater()
        } else {
          this.$emit('emitIsLoading', false)
        }
      }, 2000)
    },
    async upload(e) {
      this.isLoading = true
      this.$emit('emitIsLoading', true)

      let imageFile = e.target.files[0]
      const imageUrl = await params.getImageUrl(imageFile)
      imageFile = await params.reduceLargeImage(imageUrl, imageFile).catch(e => {
        console.log('onload error', e)
        visuals.alertError('アップロードするのは「 jpg / jpeg / png / gif 」のいずれかの画像ファイルである必要があります')
        this.$emit('emitIsLoading', false)
        this.isLoading = false
        throw new Error('onload error')
      })

      const formData = this.formData ? params.renewFormData(this.formData, this.targetModel) : new FormData()
      if (imageFile) formData.set(`${this.targetModel}[image]`, imageFile)
      this.$emit('emitFormData', formData)
      this.$emit('emitIsLoading', false)
      this.isLoading = false
    }
  },
  mounted() {
    this.isFirstUpload = !this.formData
  }
}
</script>
