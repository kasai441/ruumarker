<template>
  <section id="image-rotate">
    <div class="p-4">
      <img id="rotate-image" src="/rotation.png" width="30" @pointerdown="rotate">
    </div>
  </section>
</template>

<script>
import params from '../modules/params'

export default {
  name: 'ImageRotate',
  props: [
    'formData'
  ],
  methods: {
    async rotate() {
      const target = this.formData.get('target')
      let imageFile = this.formData.get(`${target}[image]`)
      let imageUrl = this.formData.get(`${target}[image_url]`)
      if (imageFile) imageUrl = await params.getImageUrl(imageFile)
      imageFile = await params.rotateImage(imageUrl, imageFile).catch(e => {
        console.log('onload error', e)
        throw new Error('onload error')
      })

      const formData = this.formData ? params.renewFormData(this.formData) : new FormData()
      if (imageFile) formData.set(`${target}[image]`, imageFile)
      this.$emit('emitFormData', formData)
    }
  }
}
</script>
