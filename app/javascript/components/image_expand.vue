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
      console.log('oooo')

      const field = tags.field('edit-field')
      const w = field.w * this.expansion / 100
      const h = field.h * this.expansion / 100
      const trimmingRate = params.fromJson(this.formData, this.targetModel, 'trimming')
      const left = field.w * (Number(trimmingRate.x) - (this.expansion / 100 - 1) / 2)
      const top = field.h * (Number(trimmingRate.y) - (this.expansion / 100 - 1) / 2)
      const elements = [document.getElementById('edit-image')]
      Array.prototype.forEach.call(elements, element => {
        element.style.width = w + 'px'
        element.style.height = h + 'px'
        element.style.left = left + 'px'
        element.style.top = top + 'px'
      })

      const formData = this.formData ? params.renewFormData(this.formData, this.targetModel) : new FormData()
      formData.set(`${this.targetModel}[expansion]`, this.expansion)
      this.$emit('emitFormData', formData)
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
