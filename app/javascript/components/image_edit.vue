<template>
  <section id="image-edit">
    <div id="edit-field" @pointermove="touchmove($event)" @pointerup="touchend($event)" @pointerleave="touchend($event)"
         class="my-16 w-field h-field relative">
      <img :src="imageUrl" id="edit-image" draggable="false"
           @pointerdown="touchstart($event)" @touchmove.prevent
           class="absolute w-field h-field
         outline outline-slate-200 object-contain">
      <div class="absolute w-field h-field pointer-events-none bg-transparent outline outline-240 outline-slate-200 opacity-40"></div>
      <div class="absolute w-field h-field pointer-events-none bg-transparent outline outline-4 outline-lime-500"></div>
    </div>
  </section>
</template>
<script>
import params from '../modules/params'
import tags from '../modules/tags'

export default {
  name: 'ImageEdit',
  props: [
    'formData',
    'targetModel',
    'locatorsJson'
  ],
  data() {
    return {
      isMovable: false,
      imageUrl: null,
      trimming: null,
      pointer: null,
      locators: this.locatorsJson ? JSON.parse(this.locatorsJson) : []
    }
  },
  methods: {
    touchstart(e) {
      this.isMovable = true
      const image = document.getElementById('edit-image')
      image.classList.add('shadow-2xl')

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
      this.trimming.x += params.toF(e.offsetX, 1) - this.pointer.x
      this.trimming.y += params.toF(e.offsetY, 1) - this.pointer.y

      // 外側に出ないように画像の移動を抑制する
      const field = tags.field('edit-field')
      const limitX = params.toF(field.w / 4, 1)
      const limitY = params.toF(field.h / 4, 1)
      if (this.trimming.x > limitX) this.trimming.x = limitX
      if (this.trimming.x < -limitX) this.trimming.x = -limitX
      if (this.trimming.y > limitY) this.trimming.y = limitY
      if (this.trimming.y < -limitY) this.trimming.y = -limitY

      tags.styleLeftTop('edit-image', this.trimming)
      tags.transferLocators(this.locators, this.trimming, field)
    },
    touchend() {
      this.isMovable = false
      const image = document.getElementById('edit-image')
      image.classList.remove('shadow-2xl')
      this.updateTrimming()
    },
    handleResize() {
      this.getFieldSize()
      this.updateTrimming()
    },
    handleScroll() {
      this.getFieldSize()
    },
    getFieldSize() {
      // 画像の位置
      const field = tags.field('edit-field')
      const trimmingRate = params.fromJson(this.formData, this.targetModel, 'trimming')
      this.trimming = params.toPx(field, trimmingRate)
      tags.styleLeftTop('edit-image', this.trimming)
      tags.transferLocators(this.locators, this.trimming, field)
    },
    updateTrimming() {
      const field = tags.field('edit-field')
      const trimmingRate = {
        x: (this.trimming.x / field.w).toFixed(3),
        y: (this.trimming.y / field.h).toFixed(3)
      }
      const formData = params.renewFormData(this.formData)
      formData.set(`${this.targetModel}[trimming]`, JSON.stringify(trimmingRate))
      this.$emit('emitFormData', formData)
    },
  },
  mounted() {
    window.addEventListener('resize', this.handleResize)
    window.addEventListener('scroll', this.handleScroll)
    this.imageUrl = this.formData.get(`${this.targetModel}[image_url]`)
    tags.generateLocators(this.locators, 'edit-field', { class: ['pointer-events-none'] })
    this.getFieldSize()
  },
  async updated() {
    const imageFile = this.formData.get(`${this.targetModel}[image]`)
    if (!imageFile) return

    const image = document.getElementById( 'edit-image' )
    image.src = await params.getImageUrl(imageFile)
  },
  beforeDestroy: () => {
    window.removeEventListener('resize', this.handleResize)
    window.removeEventListener('scroll', this.handleScroll)
  }
}
</script>
