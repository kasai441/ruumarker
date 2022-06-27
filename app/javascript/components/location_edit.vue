<template>
  <section id="location-edit">
    <div id="edit-location-field" @pointermove="touchmove($event)"
         @pointerup="touchend($event)" @pointerleave="touchend($event)"
         class="my-6 w-field h-field relative">
      <img :src="imageUrl" id="edit-location-image" draggable="false"
           @pointerdown="touchstart($event)" @touchmove.prevent
           class="absolute w-field h-field max-w-none object-contain">
      <div id="edit-location-frame"
           class="absolute z-10 w-field h-field
             pointer-events-none bg-transparent bg-transparent
             outline outline-112 outline-slate-300"></div>
      <div id="edit-location-shade"
           class="absolute z-10 w-field h-field
             pointer-events-none bg-transparent bg-transparent
             outline outline-slate-100"></div>
      <img :src="locatorImage" id="locator-image" draggable="false" width="28"
           class="absolute z-20 pointer-events-none">
      <div class="absolute z-10 w-field h-field
             pointer-events-none bg-transparent
             outline outline-240 outline-slate-200 opacity-40"></div>
      <div class="absolute z-10 w-field h-field
             pointer-events-none bg-transparent
             outline outline-4 outline-lime-500"></div>
    </div>
  </section>
</template>
<script>
import tags from '../modules/tags'
import params from '../modules/params'

export default {
  name: 'LocationEdit',
  props: [
    'fieldFormData',
    'locatorFormData',
    'locatorImage',
    'locatorsJson'
  ],
  data() {
    return {
      isMovable: false,
      imageUrl: null,
      location: null,
      frameOffset: null,
      pointer: null,
      locators: this.locatorsJson ? JSON.parse(this.locatorsJson) : []
    }
  },
  methods: {
    touchstart(e) {
      this.isMovable = true
      const shade = document.getElementById('edit-location-shade')
      shade.classList.add('shadow-2xl')

      // エレメントの左上からポインターまでの位置
      this.pointer = {
        x: params.toF(e.offsetX, 1),
        y: params.toF(e.offsetY, 1)
      }
    },
    touchmove(e) {
      if (!this.isMovable) return

      // e.offsetXY = １ドラッグ終了時点の座標
      // pointer.xy = クリックオン時点の座標
      const shiftX = params.toF(e.offsetX, 1) - this.pointer.x
      const shiftY = params.toF(e.offsetY, 1) - this.pointer.y
      this.location.x += shiftX
      this.location.y += shiftY
      this.frameOffset.x += shiftX
      this.frameOffset.y += shiftY

      // 外側に出ないように画像の移動を抑制する
      const fieldSize = tags.readSize('edit-location-field')
      const safe_blank = 2
      const limitX = params.toF(fieldSize.w / 2, 1) - safe_blank
      const limitY = params.toF(fieldSize.h / 2, 1) - safe_blank
      if (this.frameOffset.x >= limitX) {
        this.location.x += limitX - this.frameOffset.x
        this.frameOffset.x = limitX
      }
      if (this.frameOffset.x <= -limitX) {
        this.location.x += -limitX - this.frameOffset.x
        this.frameOffset.x = -limitX
      }
      if (this.frameOffset.y >= limitY) {
        this.location.y += limitY - this.frameOffset.y
        this.frameOffset.y = limitY
      }
      if (this.frameOffset.y <= -limitY) {
        this.location.y += -limitY - this.frameOffset.y
        this.frameOffset.y = -limitY
      }

      tags.writePosition('edit-location-frame', this.frameOffset)
      tags.writePosition('edit-location-shade', this.frameOffset)
      tags.writePosition('edit-location-image', this.location)
      tags.layoutLocators(this.locators, 'edit-location-image')
    },
    touchend() {
      this.isMovable = false
      const shade = document.getElementById('edit-location-shade')
      shade.classList.remove('shadow-2xl')
      this.updateLocation()
    },
    handleResize() {
      this.layout()
      this.updateLocation()
    },
    handleScroll() {
      this.layout()
    },
    layout() {
      const fieldSize = tags.readSize('edit-location-field')
      tags.expand(fieldSize, this.fieldFormData, 'edit-location-image')
      this.location = tags.locate(fieldSize, this.locatorFormData, this.fieldFormData, 'edit-location-image')
      this.frameOffset = tags.offset(fieldSize, this.fieldFormData, this.location)
      tags.writePosition('edit-location-frame', this.frameOffset)
      tags.writePosition('edit-location-shade', this.frameOffset)
      tags.layoutLocators(this.locators, 'edit-location-image')

      const locatorRadius = 14
      tags.writePosition('locator-image', {
        x: fieldSize.w / 2 - locatorRadius,
        y: fieldSize.h / 2 - locatorRadius
      })
    },
    updateLocation() {
      const imageSize = tags.readSize('edit-location-image')
      const fieldTarget = this.fieldFormData.get('target')
      const expansion = this.fieldFormData.get(`${fieldTarget}[expansion]`) || 100
      const fieldSize = tags.readSize('edit-location-field')
      const expansionShiftRate = (expansion / 100 - 1) / 2
      const locationRate = {
        x: ((this.location.x + fieldSize.w * expansionShiftRate) / imageSize.w).toFixed(3),
        y: ((this.location.y + fieldSize.h * expansionShiftRate) / imageSize.h).toFixed(3)
      }
      const locatorFormData = params.renewFormData(this.locatorFormData)
      const locatorTarget = locatorFormData.get('target')
      locatorFormData.set(`${locatorTarget}[location]`, JSON.stringify(locationRate))
      this.$emit('emitFormData', locatorFormData)
    },
  },
  mounted() {
    window.addEventListener('resize', this.handleResize)
    window.addEventListener('scroll', this.handleScroll)
    const fieldTarget = this.fieldFormData.get('target')
    this.imageUrl = this.fieldFormData.get(`${fieldTarget}[image_url]`)
    const locatorTarget = this.locatorFormData.get('target')
    const locatorId = this.locatorFormData.get(`${locatorTarget}[id]`)
    tags.generateLocators(this.locators, 'edit-location-field', { except: locatorId, class: ['pointer-events-none'], editMode: true })
    this.layout()
  },
  beforeDestroy: () => {
    window.removeEventListener('resize', this.handleResize)
    window.removeEventListener('scroll', this.handleScroll)
  }
}
</script>
