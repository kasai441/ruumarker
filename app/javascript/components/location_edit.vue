<template>
  <section id="location-edit">
    <div id="edit-location-field" @pointermove="touchmove($event)" @pointerup="touchend($event)" @pointerleave="touchend($event)"
         class="my-16 w-field h-field">
      <div class="relative">
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
        <img :src="locatorImage" id="locators-image" draggable="false" width="20"
             class="pointer-events-none absolute">
        <div class="absolute w-field h-field pointer-events-none bg-transparent outline outline-240 outline-slate-200 opacity-40"></div>
        <div class="absolute w-field h-field pointer-events-none bg-transparent outline outline-4 outline-lime-500"></div>
      </div>
    </div>
  </section>
</template>
<script>
import params from '../modules/params'

export default {
  name: 'LocationEdit',
  props: [
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
      trimming: null,
      location: null,
      isMovable: false,
      fieldClientX: 0,
      fieldClientY: 0,
      fieldWidth: 0,
      fieldHeight: 0,
      frame: null,
      shade: null,
      frameOffsetX: 0,
      frameOffsetY: 0,
      image: null,
      imageOffsetX: 0,
      imageOffsetY: 0,
      pointerX: 0,
      pointerY: 0
    }
  },
  methods: {
    touchstart(e) {
      this.isMovable = true
      this.shade.classList.add('shadow-2xl')

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
      this.imageOffsetX += shiftX
      this.imageOffsetY += shiftY
      this.frameOffsetX += shiftX
      this.frameOffsetY += shiftY

      // 外側に出ないように画像の移動を抑制する
      const safe_blank = 2
      const constrainFrameRangeX = Math.floor(this.fieldWidth / 2) - safe_blank
      const constrainFrameRangeY = Math.floor(this.fieldHeight / 2) - safe_blank
      if (this.frameOffsetX >= constrainFrameRangeX) {
        this.frameOffsetX = constrainFrameRangeX
        this.imageOffsetX = constrainFrameRangeX + this.imageTrimmingX
      }
      if (this.frameOffsetX <= -constrainFrameRangeX) {
        this.frameOffsetX = -constrainFrameRangeX
        this.imageOffsetX = -constrainFrameRangeX + this.imageTrimmingX
      }
      if (this.frameOffsetY >= constrainFrameRangeY) {
        this.frameOffsetY = constrainFrameRangeY
        this.imageOffsetY = constrainFrameRangeY + this.imageTrimmingY
      }
      if (this.frameOffsetY <= -constrainFrameRangeY) {
        this.frameOffsetY = -constrainFrameRangeY
        this.imageOffsetY = -constrainFrameRangeY + this.imageTrimmingY
      }

      this.frame.style.left = this.shade.style.left = this.frameOffsetX + 'px'
      this.frame.style.top = this.shade.style.top = this.frameOffsetY + 'px'
      this.image.style.left = this.imageOffsetX + 'px'
      this.image.style.top = this.imageOffsetY + 'px'
    },
    touchend() {
      this.isMovable = false
      this.shade.classList.remove('shadow-2xl')
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
      const field = document.getElementById('edit-location-field')
      if(field) {
        this.fieldClientX = Math.floor(field.getBoundingClientRect().left)
        this.fieldClientY = Math.floor(field.getBoundingClientRect().top)
        this.fieldWidth = Math.floor(field.getBoundingClientRect().right) - this.fieldClientX
        this.fieldHeight = Math.floor(field.getBoundingClientRect().bottom) - this.fieldClientY

        // 目隠しフレームの位置
        console.log(`LocationEdit.fieldClientY: ${this.fieldClientY}`)
        this.frame = document.getElementById('edit-location-frame')
        this.shade = document.getElementById('edit-location-shade')
        this.frameOffsetX = Math.floor(this.fieldWidth * (this.location.x - this.trimming.x))
        this.frameOffsetY = Math.floor(this.fieldHeight * (this.location.y - this.trimming.y))
        this.frame.style.left = this.shade.style.left = this.frameOffsetX + 'px'
        this.frame.style.top = this.shade.style.top = this.frameOffsetY + 'px'

        // 画像の位置
        this.imageTrimmingX = Math.floor(this.fieldWidth * this.trimming.x)
        this.imageTrimmingY = Math.floor(this.fieldHeight * this.trimming.y)
        this.image = document.getElementById('edit-location-image')
        this.imageOffsetX = this.frameOffsetX + this.imageTrimmingX
        this.imageOffsetY = this.frameOffsetY + this.imageTrimmingY
        this.image.style.left = this.imageOffsetX + 'px'
        this.image.style.top = this.imageOffsetY + 'px'

        const locators_image = document.getElementById('locators-image')
        locators_image.style.left = this.fieldWidth / 2 - 10 + 'px'
        locators_image.style.top = this.fieldHeight / 2 - 10 + 'px'
      }
    },
    updateLocation() {
      this.location.x = (this.frameOffsetX / this.fieldWidth + Number(this.trimming.x)).toFixed(3)
      this.location.y = (this.frameOffsetY / this.fieldHeight + Number(this.trimming.y)).toFixed(3)
      const locatorFormData = params.renewFormData(this.locatorFormData)
      locatorFormData.set(`${this.locatorModel}[location]`, JSON.stringify(this.location))
      this.$emit('emitFormData', locatorFormData)
    }
  },
  mounted() {
    console.log('LocationEdit#mounted')

    window.addEventListener('resize', this.handleResize)
    window.addEventListener('scroll', this.handleScroll)

    this.imageUrl = this.fieldFormData.get(`${this.fieldModel}[image_url]`)
    this.trimming = params.fromJson(this.fieldFormData, this.fieldModel, 'trimming')
    this.location = params.fromJson(this.locatorFormData, this.locatorModel, 'location')
    this.getFieldSize()
  },
  beforeDestroy: () => {
    window.removeEventListener('resize', this.handleResize)
    window.removeEventListener('scroll', this.handleScroll)
  }
}
</script>
