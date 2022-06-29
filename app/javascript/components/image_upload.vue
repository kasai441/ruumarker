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
      isUploading: false,
      isUploaded: false
    }
  },
  methods: {
    loadable() {
      this.isLoadable = true
    },
    loading() {
      if (this.isLoadable) {
        const inputTag = document.getElementById('file')
        inputTag.value = ''
        this.isUploaded = false

        document.body.onfocus = this.checkFile
        this.isLoadable = false
      }
    },
    checkFile() {
      const inputTag = document.getElementById('file')
      console.log(inputTag.value.length)
      console.log(inputTag.value)
      console.log(this.isUploaded)
      // this.isLoading = this.isLoading ? !this.isLoading : this.isLoading
      // this.$emit('emitIsLoading', true)
      document.body.onfocus = null
    },
    async upload(e) {
      console.log('aaa')
      console.log(e)
      this.$emit('emitIsLoading', true)
      let imageFile = e.target.files[0]
      const imageUrl = await params.getImageUrl(imageFile)
      imageFile = await params.reduceLargeImage(imageUrl, imageFile).catch(e => {
        console.log('onload error', e)
        throw new Error('onload error')
      })

      const formData = this.formData ? params.renewFormData(this.formData, this.targetModel) : new FormData()
      if (imageFile) formData.set(`${this.targetModel}[image]`, imageFile)
      this.$emit('emitFormData', formData)
      this.$emit('emitIsLoading', false)
      this.isUploaded = true
    }
  }
}
</script>
