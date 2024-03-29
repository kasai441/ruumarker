<template>
  <section id="image-edit">
    <div id="edit-field"
      @pointermove="touchmove($event)" @pointerup="touchend($event)"
      @pointerleave="touchend($event)"
      class="my-6 w-field h-field relative">
      <img :src="imageUrl" id="edit-image" draggable="false"
        @pointerdown="touchstart($event)" @touchmove.prevent
        class="absolute w-field h-field max-w-none longpress-none
        outline outline-slate-200 object-contain">
      <div class="absolute w-field h-field pointer-events-none bg-transparent outline outline-240 outline-slate-200 opacity-40"></div>
      <div class="absolute w-field h-field pointer-events-none bg-transparent outline outline-4 outline-lime-500"></div>
      <div v-if="isLoading" class="w-field h-field flex justify-center items-center">
        <div class="animate-ping h-20 w-20 bg-white rounded-full"></div>
      </div>
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
    'locatorsJson',
    'isLoading'
  ],
  data() {
    return {
      isMovable: false,
      imageUrl: null,
      trimming: null,
      expansion: 100,
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
        x: e.offsetX,
        y: e.offsetY
      }
    },
    touchmove(e) {
      if (!this.isMovable) return

      // e.offsetXY = １ドラッグ終了時点の座標
      // pointer.xy = クリックオン時点の座標
      this.trimming.x += e.offsetX - this.pointer.x
      this.trimming.y += e.offsetY - this.pointer.y

      // 外側に出ないように画像の移動を抑制する
      const fieldSize = tags.readSize('edit-field')
      const limitX = fieldSize.w / 4
      const limitY = fieldSize.h / 4
      if (this.trimming.x > limitX) this.trimming.x = limitX
      if (this.trimming.x < -limitX) this.trimming.x = -limitX
      if (this.trimming.y > limitY) this.trimming.y = limitY
      if (this.trimming.y < -limitY) this.trimming.y = -limitY

      const element = document.getElementById('edit-image')
      const target = this.formData.get('target')
      const expansion = this.formData.get(`${target}[expansion]`) || 100
      element.style.left = this.trimming.x - fieldSize.w * (expansion / 100 - 1) / 2 + 'px'
      element.style.top = this.trimming.y - fieldSize.h * (expansion / 100 - 1) / 2 + 'px'

      tags.layoutLocators(this.locators, 'edit-image')
    },
    touchend() {
      this.isMovable = false
      const image = document.getElementById('edit-image')
      image.classList.remove('shadow-2xl')
      this.updateTrimming()
    },
    handleResize() {
      this.layout()
      this.updateTrimming()
    },
    handleScroll() {
      this.layout()
    },
    layout() {
      const fieldSize = tags.readSize('edit-field')
      tags.expand(fieldSize, this.formData, 'edit-image')
      this.trimming = tags.trim(fieldSize, this.formData, 'edit-image')
      tags.layoutLocators(this.locators, 'edit-image')
    },
    updateTrimming() {
      const fieldSize = tags.readSize('edit-field')
      if (!fieldSize) return

      const trimmingRate = {
        x: (this.trimming.x / fieldSize.w).toFixed(3),
        y: (this.trimming.y / fieldSize.h).toFixed(3)
      }
      const formData = params.renewFormData(this.formData)
      const target = formData.get('target')
      formData.set(`${target}[trimming]`, JSON.stringify(trimmingRate))
      this.$emit('emitFormData', formData)
    },
  },
  mounted() {
    window.addEventListener('resize', this.handleResize)
    window.addEventListener('scroll', this.handleScroll)
    const target = this.formData.get('target')
    this.imageUrl = this.formData.get(`${target}[image_url]`)
    const elements = tags.generateLocators(this.locators, { class: ['pointer-events-none'] })
    document.getElementById('edit-field').append(...elements)
    this.layout()
  },
  async updated() {
    const target = this.formData.get('target')
    const imageFile = this.formData.get(`${target}[image]`)
    if (!imageFile) return

    const image = document.getElementById( 'edit-image' )
    image.src = await params.getImageUrl(imageFile)
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
    window.removeEventListener('scroll', this.handleScroll)
  }
}
</script>
