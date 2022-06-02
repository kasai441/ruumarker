<template>
  <section id="location-edit">
    <div id="edit-location-field" @pointermove="touchmove($event)" @pointerup="touchend($event)" @pointerleave="touchend($event)"
         class="my-16 w-field h-field relative">
      <img :src="imageUrl" id="edit-location-image" draggable="false" @pointerdown="touchstart($event)" @touchmove.prevent
           class="absolute w-field h-field object-contain">
      <div id="edit-location-frame"
           class="pointer-events-none absolute w-field h-field
         bg-transparent bg-transparent
         outline outline-112 outline-slate-300"></div>
      <div id="edit-location-shade"
           class="pointer-events-none absolute w-field h-field
         outline outline-slate-100
         bg-transparent bg-transparent"></div>
      <img :src="locatorImage" id="locator-image" draggable="false" width="20"
           class="pointer-events-none absolute z-10">
      <div class="absolute w-field h-field pointer-events-none bg-transparent outline outline-240 outline-slate-200 opacity-40"></div>
      <div class="absolute w-field h-field pointer-events-none bg-transparent outline outline-4 outline-lime-500"></div>
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

      const frame = document.getElementById('edit-location-frame')
      const shade = document.getElementById('edit-location-shade')
      const image = document.getElementById('edit-location-image')
      frame.style.left = shade.style.left = this.frameOffset.x + 'px'
      frame.style.top = shade.style.top = this.frameOffset.y + 'px'
      image.style.left = this.location.x + 'px'
      image.style.top = this.location.y + 'px'

      tags.transferLocators(this.locators, this.location, field)
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
      const locationRate = params.fromJson(this.locatorFormData, this.locatorModel, 'location')
      this.location = params.toPx(field, locationRate)
      const image = document.getElementById('edit-location-image')
      image.style.left = this.location.x + 'px'
      image.style.top = this.location.y + 'px'

      // 目隠しフレームの位置
      const trimmingRate = params.fromJson(this.fieldFormData, this.fieldModel, 'trimming')
      const trimming = params.toPx(field, trimmingRate)
      this.frameOffset = {
        x: this.location.x - trimming.x,
        y: this.location.y - trimming.y
      }
      const frame = document.getElementById('edit-location-frame')
      const shade = document.getElementById('edit-location-shade')
      frame.style.left = shade.style.left = this.frameOffset.x + 'px'
      frame.style.top = shade.style.top = this.frameOffset.y + 'px'

      tags.transferLocators(this.locators, this.location, field)

      const locator_image = document.getElementById('locator-image')
      const locatorRadius = 10
      locator_image.style.left = field.w / 2 - locatorRadius + 'px'
      locator_image.style.top = field.h / 2 - locatorRadius + 'px'
    },
    updateLocation() {
      const field = tags.field('edit-location-field')
      const locationRate = {
        x: (this.location.x / field.w).toFixed(3),
        y: (this.location.y / field.h).toFixed(3)
      }
      const locatorFormData = params.renewFormData(this.locatorFormData)
      locatorFormData.set(`${this.locatorModel}[location]`, JSON.stringify(locationRate))
      this.$emit('emitFormData', locatorFormData)
    },
    generateLocators() {
      const field = document.getElementById('edit-location-field')
      const locatorId = this.locatorFormData.get(`${this.locatorModel}[id]`)
      tags.generateLocators(this.locators, field, { except: locatorId, class: ['pointer-events-none'] })
    }
  },
  mounted() {
    console.log('LocationEdit#mounted')

    window.addEventListener('resize', this.handleResize)
    window.addEventListener('scroll', this.handleScroll)
    this.imageUrl = this.fieldFormData.get(`${this.fieldModel}[image_url]`)
    this.generateLocators()
    this.getFieldSize()
  },
  beforeDestroy: () => {
    window.removeEventListener('resize', this.handleResize)
    window.removeEventListener('scroll', this.handleScroll)
  }
}
</script>
