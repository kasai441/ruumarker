<template>
  <section id="image-expand">
    <div class="p-4">
      {{ this.expansion }}
      <input type="range" v-model="expansion" @pointermove="expand"
             min="66" max="150" class="range range-sm">
    </div>
  </section>
</template>

<script>
import params from '../modules/params'
import tags from '../modules/tags'

export default {
  name: 'ImageExpand',
  props: [
    'formData',
    'targetModel',
    'locatorsJson'
  ],
  data() {
    return {
      expansion: 100,
      locators: this.locatorsJson ? JSON.parse(this.locatorsJson) : []
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
      this.layout()

      const formData = this.formData ? params.renewFormData(this.formData, this.targetModel) : new FormData()
      formData.set(`${this.targetModel}[expansion]`, this.expansion)
      this.$emit('emitFormData', formData)
    },
    layout() {
      const field = tags.field('edit-field')
      const trimmingRate = params.parseOrInit(this.formData.get(`${this.targetModel}[trimming]`))
      const trimming = params.toPx(field, trimmingRate)
      const element = document.getElementById('edit-image')
      element.style.width = field.w * this.expansion / 100 + 'px'
      element.style.height = field.h * this.expansion / 100 + 'px'
      element.style.left = trimming.x - field.w * (this.expansion / 100 - 1) / 2 + 'px'
      element.style.top = trimming.y - field.h * (this.expansion / 100 - 1) / 2 + 'px'

      console.log(document.getElementById('edit-image').style.width)
      tags.transferLocators(this.locators, 'edit-image')
    }
  },
  created() {
    if (this.formData) {
      console.log('aaaaa')
      console.log(this.formData.get(`${this.targetModel}[expansion]`))
      this.expansion = this.formData.get(`${this.targetModel}[expansion]`)
    }
  }
}
</script>
