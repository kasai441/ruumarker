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
import params from '../modules/params'
import tags from '../modules/tags'

export default {
  name: 'ImageShow',
  props: [
    'roomId',
    'fieldModel',
    'fieldFormData',
    'fieldEditName',
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
      const id = this.fieldFormData.get(`${this.fieldModel}[id]`)
      location.href = `/rooms/${this.roomId}/${this.fieldModel}s/${id}/edit`
    },
    halfvanish(e) {
      tags.parent('IMG', e.target).classList.add('animate-halfvanish')
    },
    unbindHalfvanish(e) {
      tags.parent('IMG', e.target).classList.remove('animate-halfvanish')
    },
    layout() {
      const fieldSize = tags.readSize('show-field')
      const expansion = this.fieldFormData.get(`${this.fieldModel}[expansion]`) || 100
      tags.writeSize('show-image', {
        w: fieldSize.w * expansion / 100,
        h: fieldSize.h * expansion / 100
      })
      const trimmingRate = params.parseOrInit(this.fieldFormData.get(`${this.fieldModel}[trimming]`))
      const trimming = params.toPixel(fieldSize, trimmingRate)
      tags.writePosition('show-image', {
        x: trimming.x - fieldSize.w * (expansion / 100 - 1) / 2,
        y: trimming.y - fieldSize.h * (expansion / 100 - 1) / 2
      })
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
        const table = document.getElementById('locators-table')
        const trs = table.getElementsByTagName('tr')
        Array.prototype.forEach.call(trs, tr => {
          tr.classList.remove('active', 'animate-fadeout')
        })

        const tr = document.getElementById(a.id.replace(regex, this.locatorsModel))
        tr.classList.add('active')
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
    this.imageUrl = this.fieldFormData.get(`${this.fieldModel}[image_url]`)
    tags.generateLocators(this.locators, 'show-field', { printMode: this.printMode })
    this.layout()
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
  }
}
</script>
