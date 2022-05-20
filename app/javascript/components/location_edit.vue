<template>
  <section id="location-edit">
    <div id="edit-location-field" @pointermove="touchmove($event)" @pointerup="touchend($event)" @pointerleave="touchend($event)"
         class="my-16 edit-size">
      <div class="relative">
        <div id="edit-location-frame"
             class="pointer-events-none absolute z-20 edit-size
             bg-transparent bg-transparent
             outline outline-112 outline-slate-300"></div>
        <div id="edit-location-shade"
             class="pointer-events-none absolute z-20 edit-size
             bg-transparent bg-transparent"></div>
        <img :src="imageUrl" id="edit-location-image" draggable="false" @pointerdown="touchstart($event)"
             class="absolute z-10 edit-size w-full object-contain">
      </div>
      <div class="absolute z-30 edit-size pointer-events-none bg-transparent outline outline-4 outline-lime-500"></div>
      <div class="absolute z-20 edit-size pointer-events-none bg-transparent outline outline-112 outline-slate-200 opacity-40"></div>
    </div>
    <div>fieldClientX{{ fieldClientX }}</div>
    <div>fieldClientY{{ fieldClientY }}</div>
    <div>fieldWidth{{ fieldWidth }}</div>
    <div>fieldHeight{{ fieldHeight }}</div>
    <div>frameOffsetX{{ frameOffsetX }}</div>
    <div>frameOffsetY{{ frameOffsetY }}</div>
    <div>imageOffsetY{{ imageOffsetY }}</div>
    <div>locationx{{ location.x }}</div>
    <div>locationy{{ location.y }}</div>
    <div>imageTrimmingX{{imageTrimmingX}}</div>
  </section>
</template>
<script>
import params from '../modules/params'

export default {
  name: 'LocationEdit',
  props: [
    'formData',
    'mapFormData',
    'targetModel'
  ],
  data() {
    return {
      imageTrimmingX: 0,
      imageTrimmingY: 0,
      imageUrl: null,
      location: {x:0, y:0},
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

        // 移動分の反映
        console.log(`LocationEdit.fieldClientY: ${this.fieldClientY}`)
        this.frame = document.getElementById('edit-location-frame')
        this.shade = document.getElementById('edit-location-shade')
        this.frameOffsetX = Math.floor(this.fieldWidth * this.location.x)
        this.frameOffsetY = Math.floor(this.fieldHeight * this.location.y)
        this.frame.style.left = this.shade.style.left = this.frameOffsetX + 'px'
        this.frame.style.top = this.shade.style.top = this.frameOffsetY + 'px'

        // トリミング分の反映
        const trimming = params.trimming(this.mapFormData, 'map')
        this.imageTrimmingX = Math.floor(this.fieldWidth * trimming.x)
        this.imageTrimmingY = Math.floor(this.fieldHeight * trimming.y)
        this.image = document.getElementById('edit-location-image')
        this.imageOffsetX = this.frameOffsetX + this.imageTrimmingX
        this.imageOffsetY = this.frameOffsetY + this.imageTrimmingY
        this.image.style.left = this.imageOffsetX + 'px'
        this.image.style.top = this.imageOffsetY + 'px'
      }
    },
    updateLocation() {
      this.location.x = (this.frameOffsetX / this.fieldWidth).toFixed(3)
      this.location.y = (this.frameOffsetY / this.fieldHeight).toFixed(3)
      const formData = params.renewFormData(this.formData)
      formData.set(`${this.targetModel}[location]`, JSON.stringify(this.location))
      this.$emit('emitFormData', formData)
    }
  },
  mounted() {
    console.log('ImageEdit#mounted')

    window.addEventListener('resize', this.handleResize)
    window.addEventListener('scroll', this.handleScroll)

    this.imageUrl = this.mapFormData.get('map[image_url]')

    this.location = params.location(this.formData, 'mark')
    console.log(this.location)
    this.getFieldSize()
  },
  async updated() {
    console.log('LocationEdit#updated')
    // const imageFile = this.formData.get(`${this.targetModel}[image]`)
    // if (!imageFile) return
    //
    // const image = document.getElementById( 'location-image' )
    // image.src = await params.getImageUrl(imageFile)
  },
  beforeDestroy: () => {
    window.removeEventListener('resize', this.handleResize)
    window.removeEventListener('scroll', this.handleScroll)
  }
}
</script>
