<template>
  <section id="image-upload">
    <div class="p-4 text-sm z-50">
      <input type="file" id="upload-image" name="upload-image" accept="image/png,image/jpeg" @change="upload" />
    </div>
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
      console.log('ImageUpload#upload')
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
