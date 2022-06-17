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
      <img :src="locatorImage" id="locator-image" draggable="false" width="20"
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
import params from '../modules/params'
import tags from '../modules/tags'

export default {
  name: 'LocationEdit',
  props: [
    'locatorsJson',
    'locatorFormData',
    'locatorModel',
    'locatorImage',
    'fieldFormData',
    'fieldModel'
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
      const field = tags.field('edit-location-field')
      const safe_blank = 2
      const limitX = params.toF(field.w / 2, 1) - safe_blank
      const limitY = params.toF(field.h / 2, 1) - safe_blank
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

      tags.styleLeftTop('edit-location-frame', this.frameOffset)
      tags.styleLeftTop('edit-location-shade', this.frameOffset)
      tags.styleLeftTop('edit-location-image', this.location)
      tags.transferLocators(this.locators, 'edit-location-image')
    },
    touchend() {
      this.isMovable = false
      const shade = document.getElementById('edit-location-shade')
      shade.classList.remove('shadow-2xl')
      this.updateLocation()
    },
    handleResize() {
      this.getFieldSize()
      this.updateLocation()
    },
    handleScroll() {
      this.getFieldSize()
    },
    getFieldSize() {
      // 画像の位置
      const field = tags.field('edit-location-field')
      const element = document.getElementById('edit-location-image')

      let expansion = this.fieldFormData.get(`${this.fieldModel}[expansion]`)
      expansion ||= 100
      console.log('expansion')
      console.log(expansion)
      element.style.width = field.w * expansion / 100 + 'px'
      element.style.height = field.h * expansion / 100 + 'px'

      console.log('element.style.width')
      console.log(element.style.width)

      const image = tags.field('edit-location-image')

      const locationRate = params.parseOrInit(this.locatorFormData.get(`${this.locatorModel}[location]`))
      console.log('locationRate')
      console.log(locationRate)

      this.location = params.toPx(image, locationRate)
      console.log('this.location.x')
      console.log(this.location.x)

      console.log('field.w')
      console.log(field.w)
      const expansionShiftRate = (expansion / 100 - 1) / 2
      console.log('field.w * (expansion / 100 - 1) / 2')
      console.log(field.w * (expansion / 100 - 1) / 2)
      this.location.x -= field.w * expansionShiftRate
      this.location.y -= field.h * expansionShiftRate
      console.log('this.location.x')
      console.log(this.location.x)

      element.style.left = this.location.x  + 'px'
      element.style.top = this.location.y + 'px'
      tags.transferLocators(this.locators, 'edit-image')

      // 目隠しフレームの位置
      const trimmingRate = params.parseOrInit(this.fieldFormData.get(`${this.fieldModel}[trimming]`))
      const trimming = params.toPx(field, trimmingRate)
      this.frameOffset = {
        x: this.location.x - trimming.x,
        y: this.location.y - trimming.y
      }
      tags.styleLeftTop('edit-location-frame', this.frameOffset)
      tags.styleLeftTop('edit-location-shade', this.frameOffset)
      tags.transferLocators(this.locators, 'edit-location-image')

      const locatorRadius = 10
      tags.styleLeftTop('locator-image', {
        x: field.w / 2 - locatorRadius,
        y: field.h / 2 - locatorRadius
      })
    },
    updateLocation() {
      const image = tags.field('edit-location-image')
      let expansion = this.fieldFormData.get(`${this.fieldModel}[expansion]`)
      expansion ||= 100
      const field = tags.field('edit-location-field')
      const expansionShiftRate = (expansion / 100 - 1) / 2
      const locationRate = {
        x: ((this.location.x + field.w * expansionShiftRate) / image.w).toFixed(3),
        y: ((this.location.y + field.h * expansionShiftRate) / image.h).toFixed(3)
      }
      console.log('locationRate: update')
      console.log(locationRate)
      const locatorFormData = params.renewFormData(this.locatorFormData)
      locatorFormData.set(`${this.locatorModel}[location]`, JSON.stringify(locationRate))
      this.$emit('emitFormData', locatorFormData)
    },
  },
  mounted() {
    window.addEventListener('resize', this.handleResize)
    window.addEventListener('scroll', this.handleScroll)
    this.imageUrl = this.fieldFormData.get(`${this.fieldModel}[image_url]`)
    const locatorId = this.locatorFormData.get(`${this.locatorModel}[id]`)
    tags.generateLocators(this.locators, 'edit-location-field', { except: locatorId, class: ['pointer-events-none'], editMode: true })
    this.getFieldSize()
  },
  beforeDestroy: () => {
    window.removeEventListener('resize', this.handleResize)
    window.removeEventListener('scroll', this.handleScroll)
  }
}
</script>
