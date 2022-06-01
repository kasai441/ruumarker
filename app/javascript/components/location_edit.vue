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
      imageTrimmingX: 0,
      imageTrimmingY: 0,
      imageUrl: null,
      locationX: 0,
      locationY: 0,
      isMovable: false,
      frameOffsetX: 0,
      frameOffsetY: 0,
      pointerX: 0,
      pointerY: 0,
      locators: this.locatorsJson ? JSON.parse(this.locatorsJson) : []
    }
  },
  methods: {
    touchstart(e) {
      this.isMovable = true
      const shade = document.getElementById('edit-location-shade')
      shade.classList.add('shadow-2xl')

      // エレメントの左上からポインターまでの位置
      this.pointerX = Math.floor(e.offsetX)
      this.pointerY = Math.floor(e.offsetY)
    },
    touchmove(e) {
      if (!this.isMovable) return

      // 動かす画像の左上からポインターまでの距離
      // framePointerXY = クリック時点
      // e.offsetXY = ドラッグ中
      const shiftX = Math.floor(e.offsetX) - this.pointerX
      const shiftY = Math.floor(e.offsetY) - this.pointerY
      this.locationX += shiftX
      this.locationY += shiftY
      this.frameOffsetX += shiftX
      this.frameOffsetY += shiftY
      const field = tags.field('edit-location-field')

      // 外側に出ないように画像の移動を抑制する
      const safe_blank = 2
      const constrainFrameRangeX = Math.floor(field.w / 2) - safe_blank
      const constrainFrameRangeY = Math.floor(field.h / 2) - safe_blank
      if (this.frameOffsetX >= constrainFrameRangeX) {
        this.frameOffsetX = constrainFrameRangeX
        this.locationX = constrainFrameRangeX + this.imageTrimmingX
      }
      if (this.frameOffsetX <= -constrainFrameRangeX) {
        this.frameOffsetX = -constrainFrameRangeX
        this.locationX = -constrainFrameRangeX + this.imageTrimmingX
      }
      if (this.frameOffsetY >= constrainFrameRangeY) {
        this.frameOffsetY = constrainFrameRangeY
        this.locationY = constrainFrameRangeY + this.imageTrimmingY
      }
      if (this.frameOffsetY <= -constrainFrameRangeY) {
        this.frameOffsetY = -constrainFrameRangeY
        this.locationY = -constrainFrameRangeY + this.imageTrimmingY
      }

      const frame = document.getElementById('edit-location-frame')
      const shade = document.getElementById('edit-location-shade')
      const image = document.getElementById('edit-location-image')
      frame.style.left = shade.style.left = this.frameOffsetX + 'px'
      frame.style.top = shade.style.top = this.frameOffsetY + 'px'
      image.style.left = this.locationX + 'px'
      image.style.top = this.locationY + 'px'

      tags.transferLocators(this.locators,
        { x: this.locationX, y: this.locationY },
        { w: field.w, h: field.h }
      )
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
      const field = tags.field('edit-location-field')
      const trimming = params.fromJson(this.fieldFormData, this.fieldModel, 'trimming')
      const locationRate = params.fromJson(this.locatorFormData, this.locatorModel, 'location')

      this.imageTrimmingX = Math.floor(field.w * trimming.x)
      this.imageTrimmingY = Math.floor(field.h * trimming.y)
      this.locationX = Math.floor(field.w * locationRate.x)
      this.locationY = Math.floor(field.h * locationRate.y)

      // 目隠しフレームの位置
      const frame = document.getElementById('edit-location-frame')
      const shade = document.getElementById('edit-location-shade')
      this.frameOffsetX = this.locationX - this.imageTrimmingX
      this.frameOffsetY = this.locationY - this.imageTrimmingY
      frame.style.left = shade.style.left = this.frameOffsetX + 'px'
      frame.style.top = shade.style.top = this.frameOffsetY + 'px'

      // 画像の位置
      const image = document.getElementById('edit-location-image')
      // this.imageOffsetX = this.frameOffsetX + this.imageTrimmingX
      // this.imageOffsetY = this.frameOffsetY + this.imageTrimmingY
      image.style.left = this.locationX + 'px'
      image.style.top = this.locationY + 'px'

      tags.transferLocators(this.locators,
        { x: this.locationX, y: this.locationY },
        { w: field.w, h: field.h }
      )

      const locator_image = document.getElementById('locator-image')
      const r = 10
      locator_image.style.left = field.w / 2 - r + 'px'
      locator_image.style.top = field.h / 2 - r + 'px'

    },
    updateLocation() {
      const field = tags.field('edit-location-field')
      const locationRate = {
        x: (this.locationX / field.w).toFixed(3),
        y: (this.locationY / field.h).toFixed(3)
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
