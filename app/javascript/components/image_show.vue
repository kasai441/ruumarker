<template>
  <section id="image-show">
    <div id="show-field" @click="scrollTable($event)"
         class="mb-4 w-field-show h-field-show rounded-lg relative border border-1 border-slate-300 overflow-hidden">
      <img :src="imageUrl" id="show-image"
           class="rounded-lg absolute w-field-show h-field-show max-w-none
           object-contain">
      <a v-if="!printMode" id="image-edit" @click='imageEdit'
           class="absolute z-10 flex flex-col items-center">
        <img src="/camera.png" width="40">
        <svg viewBox="0 0 34 17" width="34" height="17">
          <text x="4" y="0.3" dominant-baseline="text-before-edge" class="font-btn font-bg">編集</text>
          <text x="4" y="0" dominant-baseline="text-before-edge" class="font-btn">編集</text>
        </svg>
      </a>
    </div>
  </section>
</template>
<script>
import tags from '../modules/tags'

export default {
  name: 'ImageShow',
  props: [
    'roomId',
    'formData',
    'locatorsModel',
    'locatorsJson',
    'printMode'
  ],
  data() {
    return {
      imageUrl: null,
      showFieldWidth: 0,
      showFieldHeight: 0,
      locators: this.locatorsJson ? JSON.parse(this.locatorsJson) : []
    }
  },
  methods: {
    imageEdit(e) {
      tags.parent('A', e.target).classList.add('animate-fadeout')
      const target = this.formData.get('target')
      const id = this.formData.get(`${target}[id]`)
      location.href = `/rooms/${this.roomId}/${target}s/${id}/edit`
    },
    layout() {
      const fieldSize = tags.readSize('show-field')
      if (!fieldSize) return

      tags.expand(fieldSize, this.formData, 'show-image')
      tags.trim(fieldSize, this.formData,'show-image')
      tags.layoutLocators(this.locators, 'show-image')
      if (!this.printMode) tags.writePosition('image-edit', {
        x: fieldSize.w - 50,
        y: fieldSize.h - 65
      })
    },
    scrollTable(e) {
      if (this.printMode) return

      const a = tags.parent('A', e.target)
      const regex = /locator/g
      if (a && a.id.match(regex)) {
        const rows = document.getElementsByClassName('locators-row')
        Array.prototype.forEach.call(rows, row => {
          row.classList.remove('animate-select')
        })

        const row = document.getElementById(a.id.replace(regex, this.locatorsModel))
        row.classList.add('animate-select')

        window.scrollTo({
          behavior: 'smooth',
          left: 0,
          top: row.offsetTop - 100
        })
      }
    },
    handleResize() {
      this.layout()
    }
  },
  mounted() {
    if (this.printMode) {
      const tags = document.getElementsByClassName('h-field')
      Array.prototype.forEach.call(tags, tag => {
        tag.classList.remove('w-field', 'h-field')
        tag.classList.add('w-print-field', 'h-print-field')
      })
    }

    window.addEventListener('resize', this.handleResize)
    const target = this.formData.get('target')
    this.imageUrl = this.formData.get(`${target}[image_url]`)
    const elements = tags.generateLocators(this.locators, { printMode: this.printMode })
    document.getElementById('show-field').append(...elements)
    this.layout()
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
  }
}
</script>
