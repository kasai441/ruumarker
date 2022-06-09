<template>
  <section id="image-show">
    <div id="show-field" @pointerdown="scrollTable($event)" @pointerup="unbindFadeout($event)"
         class="mb-4 w-field h-field rounded-lg relative border border-1 border-slate-300 overflow-hidden">
      <img :src="imageUrl" id="show-image"
           class="rounded-lg absolute w-field h-field
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
    'id',
    'fieldModel',
    'imageUrl',
    'trimming',
    'fieldEditName',
    'locatorsModel',
    'locatorsJson',
    'printMode'
  ],
  data() {
    return {
      showFieldWidth: 0,
      showFieldHeight: 0,
      locators: this.locatorsJson ? JSON.parse(this.locatorsJson) : []
    }
  },
  methods: {
    imageEdit() {
      location.href = `/rooms/${this.roomId}/${this.fieldModel}s/${this.id}/edit`
    },
    halfvanish(e) {
      tags.parent('IMG', e.target).classList.add('animate-halfvanish')
    },
    unbindHalfvanish(e) {
      tags.parent('IMG', e.target).classList.remove('animate-halfvanish')
    },
    getFieldSize() {
      const field = tags.field('show-field')
      const trimmingRate = params.parseOrInit(this.trimming)
      const trimming = params.toPx(field, trimmingRate)
      tags.styleLeftTop('show-image', trimming)
      tags.transferLocators(this.locators, trimming, field)

      if (!this.printMode) tags.styleLeftTop('image-edit', {
        x: field.w - 45,
        y: field.h - 45
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
      this.getFieldSize()
    }
  },
  mounted() {
    window.addEventListener('resize', this.handleResize)
    tags.generateLocators(this.locators, 'show-field', { printMode: this.printMode })
    this.getFieldSize()
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
  }
}
</script>
