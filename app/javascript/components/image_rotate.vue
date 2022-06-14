<template>
  <section id="image-rotate">
    <div class="p-4">
      <img id="rotate-image" src="/rotation.png" width="30" @pointerdown="rotate"
      />
    </div>
  </section>
</template>

<script>
import params from '../modules/params'

export default {
  name: 'ImageRotate',
  props: [
    'formData',
    'targetModel'
  ],
  methods: {
    async rotate() {
      let imageFile = this.formData.get(`${this.targetModel}[image]`)
      let imageUrl = this.formData.get(`${this.targetModel}[image_url]`)
      if (imageFile) imageUrl = await params.getImageUrl(imageFile)
      console.log('imageFile: ', imageFile)
      console.log('imageUrl: ', imageUrl)
      imageFile = await params.rotateImage(imageUrl, imageFile).catch(e => {
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
