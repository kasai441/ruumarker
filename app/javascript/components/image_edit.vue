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
      trimming: null,
      imageUrl: null,
      isMovable: false,
      image: null,
      imageOffsetX: 0,
      imageTop: 0,
      pointerX: 0,
      pointerY: 0,
      locators: this.locatorsJson ? JSON.parse(this.locatorsJson) : []
    }
  },
  methods: {
    touchstart(e) {
      this.isMovable = true
      this.image.classList.add('shadow-2xl')

      // エレメントの左上からポインターまでの位置
      this.pointerX = Math.floor(e.offsetX)
      this.pointerY = Math.floor(e.offsetY)
    },
    touchmove(e) {
      if (!this.isMovable) return

      // 動かす画像の左上からポインターまでの距離
      // pointerXY = クリック時点
      // e.offsetXY =  ドラッグ中
      this.imageOffsetX += Math.floor(e.offsetX) - this.pointerX
      this.imageOffsetY += Math.floor(e.offsetY) - this.pointerY
      const field = tags.field('edit-field')

      // 外側に出ないように画像の移動を抑制する
      const constrainRangeX = Math.floor(field.w / 4)
      const constrainRangeY = Math.floor(field.h / 4)
      if (this.imageOffsetX > constrainRangeX) this.imageOffsetX = constrainRangeX
      if (this.imageOffsetX < -constrainRangeX) this.imageOffsetX = -constrainRangeX
      if (this.imageOffsetY > constrainRangeY) this.imageOffsetY = constrainRangeY
      if (this.imageOffsetY < -constrainRangeY) this.imageOffsetY = -constrainRangeY

      this.image.style.left = this.imageOffsetX + 'px'
      this.image.style.top = this.imageOffsetY + 'px'

      tags.transferLocators(this.locators,
        { x: this.imageOffsetX, y: this.imageOffsetY },
        { w: field.w, h: field.h }
      )
    },
    touchend() {
      this.isMovable = false
      this.image.classList.remove('shadow-2xl')
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
      const field = tags.field('edit-field')

      // 移動分の反映
      this.image = document.getElementById('edit-image')
      this.imageOffsetX = Math.floor(field.w * this.trimming.x)
      this.imageOffsetY = Math.floor(field.h * this.trimming.y)
      this.image.style.left = this.imageOffsetX + 'px'
      this.image.style.top = this.imageOffsetY + 'px'

      tags.transferLocators(this.locators,
        { x: this.imageOffsetX, y: this.imageOffsetY },
        { w: field.w, h: field.h }
      )
    },
    updateTrimming() {
      const field = tags.field('edit-field')
      this.trimming.x = (this.imageOffsetX / field.w).toFixed(3)
      this.trimming.y = (this.imageOffsetY / field.h).toFixed(3)
      const formData = params.renewFormData(this.formData)
      formData.set(`${this.targetModel}[trimming]`, JSON.stringify({x: this.trimming.x, y: this.trimming.y}))
      this.$emit('emitFormData', formData)
    },
    generateLocators() {
      const field = document.getElementById('edit-field')
      tags.generateLocators(this.locators, field, { class: ['pointer-events-none'] })
    }
  },
  mounted() {
    console.log('ImageEdit#mounted')

    window.addEventListener('resize', this.handleResize)
    window.addEventListener('scroll', this.handleScroll)

    this.imageUrl = this.formData.get(`${this.targetModel}[image_url]`)
    this.trimming = params.fromJson(this.formData, this.targetModel, 'trimming')
    this.generateLocators()
    this.getFieldSize()
  },
  async updated() {
    console.log('ImageEdit#updated')
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
