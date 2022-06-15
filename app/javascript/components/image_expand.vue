<template>
  <section id="image-expand">
    <div class="p-4">
      {{ this.expansion }}
      <input type="range" v-model="expansion" min="50" max="150" class="range range-sm">
    </div>
  </section>
</template>

<script>
import params from '../modules/params'

export default {
  name: 'ImageExpand',
  props: [
    'formData',
    'targetModel'
  ],
  data() {
    return {
      expansion: 100
    }
  },
  methods: {
    async rotate() {
      // let imageFile = this.formData.get(`${this.targetModel}[image]`)
      // let imageUrl = this.formData.get(`${this.targetModel}[image_url]`)
      // if (imageFile) imageUrl = await params.getImageUrl(imageFile)
      // imageFile = await params.rotateImage(imageUrl, imageFile).catch(e => {
      //   console.log('onload error', e)
      //   throw new Error('onload error')
      // })
      //
      // const formData = this.formData ? params.renewFormData(this.formData, this.targetModel) : new FormData()
      // if (imageFile) formData.set(`${this.targetModel}[image]`, imageFile)
      // this.$emit('emitFormData', formData)
    },
    expand() {

    }
  },
  created() {
    if (this.formData) {
      this.expantion = this.formData.get(`${this.targetModel}[expansion]`)
    }
  }
}
</script>
