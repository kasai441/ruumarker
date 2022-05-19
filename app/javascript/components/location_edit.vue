<template>
  <section id="location-edit">
    <div id="edit-location-field" @pointermove="touchmove($event)" @pointerup="touchend($event)" @pointerleave="touchend($event)"
         class="my-16 edit-size">
      <div class="relative">
        <div id="edit-location-frame"
             class="pointer-events-none absolute z-20 edit-size
             rounded-lg bg-transparent bg-transparent outline outline-112 opacity-40 outline-white"></div>
        <img :src="imageUrl" id="edit-location-image" draggable="false" @pointerdown="touchstart($event)"
             class="rounded-lg absolute z-10 edit-size w-full object-contain">
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
      trimming: null,
      imageUrl: null,
      location: {x:0, y:0},
      isMovable: false,
      fieldClientX: 0,
      fieldClientY: 0,
      fieldWidth: 0,
      fieldHeight: 0,
      frame: null,
      frameOffsetX: 0,
      frameOffsetY: 0,
      imageOffsetX: 0,
      imageOffsetY: 0,
      pointerX: 0,
      pointerY: 0
    }
  },
  methods: {
    touchstart(e) {
      this.isMovable = true
      // this.frame.classList.add('shadow-2xl')

      // エレメントの左上からポインターまでの位置
      this.pointerX = Math.floor(e.clientX) - this.frameOffsetX - this.fieldClientX
      this.pointerY = Math.floor(e.clientY) - this.frameOffsetY - this.fieldClientY
      console.log(e.clientX)
      console.log(this.pointerX)
    },
    touchmove(e) {
      if (!this.isMovable) return

      // 移動距離
      this.frameOffsetX = Math.floor(e.offsetX) - this.pointerX + this.imageOffsetX
      this.frameOffsetY = Math.floor(e.offsetY) - this.pointerY + this.imageOffsetY
      console.log(e.offsetX)

      // // 外側に出ないように画像の移動を抑制する
      // const constrainRangeX = Math.floor(this.fieldWidth / 4)
      // const constrainRangeY = Math.floor(this.fieldHeight / 4)
      // const maxLeft = this.fieldClientX + constrainRangeX
      // const maxTop = this.fieldClientY + constrainRangeY
      // const minLeft = maxLeft - constrainRangeX * 2
      // const minTop = maxTop - constrainRangeY * 2
      // if (this.frameOffsetX > maxLeft) this.frameOffsetX = maxLeft
      // if (this.frameOffsetX < minLeft) this.frameOffsetX = minLeft
      // if (this.frameOffsetY > maxTop) this.frameOffsetY = maxTop
      // if (this.frameOffsetY < minTop) this.frameOffsetY = minTop

      this.frame.style.left = this.frameOffsetX + 'px'
      this.frame.style.top = this.frameOffsetY + 'px'
    },
    touchend() {
      this.isMovable = false
      // this.frame.classList.remove('shadow-2xl')
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
        console.log(`ImageEdit.fieldClientY: ${this.fieldClientY}`)
        this.frame = document.getElementById('edit-location-frame')
        this.frameOffsetX = Math.floor(this.fieldWidth * this.location.x)
        this.frameOffsetY = Math.floor(this.fieldHeight * this.location.y)
        this.frame.style.left = this.frameOffsetX + 'px'
        this.frame.style.top = this.frameOffsetY + 'px'

        // トリミング分の反映
        const image = document.getElementById('edit-location-image')
        this.imageOffsetX = Math.floor(this.fieldWidth * this.trimming.x)
        this.imageOffsetY = Math.floor(this.fieldHeight * this.trimming.y)
        image.style.left = this.imageOffsetX + 'px'
        image.style.top = this.imageOffsetY + 'px'
      }
    },
    updateLocation() {
      this.location.x = (this.frameOffsetX / this.fieldWidth).toFixed(3)
      this.location.y = (this.frameOffsetY / this.fieldHeight).toFixed(3)
      const formData = params.renewFormData(this.formData)
      formData.set(`${this.targetModel}[location]`, JSON.stringify({x: this.location.x, y: this.location.y}))
      // this.$emit('emitFormData', formData)
    }
  },
  mounted() {
    console.log('ImageEdit#mounted')

    window.addEventListener('resize', this.handleResize)
    window.addEventListener('scroll', this.handleScroll)

    this.imageUrl = this.mapFormData.get('map[image_url]')
    this.trimming = params.trimming(this.mapFormData, 'map')
    console.log(this.trimming)
    // this.location = this.formData.get(`${this.targetModel}[location]`)
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
