<template>
  <section id="image-expand">
    <div class="p-2 flex flex-col items-center">
      <p class="font-btn">縮小｜拡大</p>
      <div class="w-full h-10 flex items-center">
        <input type="range" v-model="expansion" @pointermove="expand"
               min="50" max="150" class="range range-sm">
      </div>
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
    'locatorsJson'
  ],
  data() {
    return {
      expansion: 100,
      locators: this.locatorsJson ? JSON.parse(this.locatorsJson) : []
    }
  },
  methods: {
    expand() {
      this.layout()
      const formData = this.formData ? params.renewFormData(this.formData) : new FormData()
      const target = formData.get('target')
      formData.set(`${target}[expansion]`, this.expansion)
      this.$emit('emitFormData', formData)
    },
    layout() {
      const fieldSize = tags.readSize('edit-field')
      const target = this.formData.get('target')
      const trimmingRate = params.parseOrInit(this.formData.get(`${target}[trimming]`))
      const trimming = params.toPixel(fieldSize, trimmingRate)
      const element = document.getElementById('edit-image')
      element.style.width = fieldSize.w * this.expansion / 100 + 'px'
      element.style.height = fieldSize.h * this.expansion / 100 + 'px'
      element.style.left = trimming.x - fieldSize.w * (this.expansion / 100 - 1) / 2 + 'px'
      element.style.top = trimming.y - fieldSize.h * (this.expansion / 100 - 1) / 2 + 'px'

      tags.layoutLocators(this.locators, 'edit-image')
    }
  },
  created() {
    if (this.formData) {
      const target = this.formData.get('target')
      this.expansion = this.formData.get(`${target}[expansion]`) || 100
    }
  }
}
</script>
