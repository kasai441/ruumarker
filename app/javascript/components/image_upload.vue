<template>
  <section id="image-upload">
    <label for="file" class="">
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
  methods: {
    async upload(e) {
      e.preventDefault()
      let imageFile = e.target.files[0]
      const imageUrl = await params.getImageUrl(imageFile)
      imageFile = await params.reduceLargeImage(imageUrl, imageFile).catch(e => {
        console.log('onload error', e)
        throw new Error('onload error')
      })

      const formData = this.formData ? params.renewFormData(this.formData, this.targetModel) : new FormData()
      if (imageFile) formData.set(`${this.targetModel}[image]`, imageFile)
      this.$emit('emitFormData', formData)
    }
  }
}
</script>
