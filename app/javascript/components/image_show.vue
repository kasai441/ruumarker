<template>
  <section id="image-show">
    <div id="show-field" @pointerdown="scrollTable($event)" @pointerup="unbindFadeout($event)"
         class="mb-4 w-field h-field rounded-lg relative border border-1 border-slate-300 overflow-hidden">
      <img :src="imageUrl" id="show-image"
           class="rounded-lg absolute w-field h-field max-w-none
           object-contain">
      <img v-if="!printMode" src="/camera.png" @click='imageEdit' @pointerdown="unbindHalfvanish" @pointerup="halfvanish"
           id="image-edit" class="absolute z-10" width="40">
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
    imageEdit() {
      const target = this.formData.get('target')
      const id = this.formData.get(`${target}[id]`)
      location.href = `/rooms/${this.roomId}/${target}s/${id}/edit`
    },
    halfvanish(e) {
      tags.parent('IMG', e.target).classList.add('animate-halfvanish')
    },
    unbindHalfvanish(e) {
      tags.parent('IMG', e.target).classList.remove('animate-halfvanish')
    },
    layout() {
      const fieldSize = tags.readSize('show-field')
      tags.expand(fieldSize, this.formData, 'show-image')
      tags.trim(fieldSize, this.formData,'show-image')
      tags.layoutLocators(this.locators, 'show-image')
      if (!this.printMode) tags.writePosition('image-edit', {
        x: fieldSize.w - 45,
        y: fieldSize.h - 45
      })
    },
    scrollTable(e) {
      if (this.printMode) return

      const a = tags.parent('A', e.target)
      const regex = /locator/g
      if (a && a.id.match(regex)) {
        const rows = document.getElementsByTagName('locators-row')
        Array.prototype.forEach.call(rows, row => {
          row.classList.remove('active', 'animate-fadeout')
        })

        const row = document.getElementById(a.id.replace(regex, this.locatorsModel))
        row.classList.add('active')
        // table.scrollTo({
        //   behavior: 'smooth',
        //   left: 0,
        //   top: tr.offsetTop
        // })
      }
    },
    unbindFadeout(e) {
      if (this.printMode) return

      const a = tags.parent('A', e.target)
      const regex = /locator/g
      if (a && a.id.match(regex)) {
        const tr = document.getElementById(a.id.replace(regex, this.locatorsModel))
        tr.classList.remove('active')
        tr.classList.add('animate-fadeout')
      }
    },
    handleResize() {
      this.layout()
    }
  },
  mounted() {
    window.addEventListener('resize', this.handleResize)
    const target = this.formData.get('target')
    this.imageUrl = this.formData.get(`${target}[image_url]`)
    tags.generateLocators(this.locators, 'show-field', { printMode: this.printMode })
    this.layout()
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
  }
}
</script>
