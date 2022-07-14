<template>
  <section id="image-upload">
    <label for="file"
           @pointerdown="loadable" @pointerup="loading">
      <div class="w-full flex flex-col items-center">
        <p class="font-btn">アップロード</p>
        <img src="/upload.png" width="40">
      </div>
    </label>
    <input type="file" id="file" name="upload-image"
           accept="image/png,image/jpeg" @change="upload"
           class="hidden"
    />
  </section>
</template>

<script>
import params from '../modules/params'

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
    }
  },
  methods: {
    loadable() {
      this.isLoadable = true
      const alert = document.getElementById('alert')
      alert.innerText = ''
      alert.classList.remove('alert', 'alert-error', 'mt-2')
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
        const alert = document.getElementById('alert')
        alert.innerText = '指定の画像ファイル[jpg/jpeg/png/gif]以外の可能性があります'
        alert.classList.add('alert', 'alert-error', 'mt-2')
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
  }
}
</script>
