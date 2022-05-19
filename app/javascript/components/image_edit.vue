<template>
  <section id="image-edit">
    <div id="edit-field" @pointermove="touchmove($event)" @pointerup="touchend($event)" @pointerleave="touchend($event)"
         class="my-16 edit-size">
      <img :src="imageUrl" id="edit-image" draggable="false" @pointerdown="touchstart($event)"
           class="absolute z-10 edit-size object-contain">
      <div class="relative">
        <div class="absolute z-30 edit-size pointer-events-none bg-transparent outline outline-4 outline-lime-500"></div>
        <div class="absolute z-20 edit-size pointer-events-none bg-transparent outline outline-112 outline-slate-200 opacity-40"></div>
      </div>
    </div>
  </section>
</template>
<script>
import params from '../modules/params'

export default {
  name: 'ImageEdit',
  props: [
    'formData',
    'targetModel'
  ],
  data() {
    return {
      trimming: null,
      imageUrl: null,
      isMovable: false,
      fieldClientX: 0,
      fieldClientY: 0,
      fieldWidth: 0,
      fieldHeight: 0,
      image: null,
      imageLeft: 0,
      imageTop: 0,
      pointerX: 0,
      pointerY: 0
    }
  },
  methods: {
    touchstart(e) {
      this.isMovable = true
      this.image.classList.add('shadow-2xl')

      // エレメントの左上からポインターまでの位置
      this.pointerX = Math.floor(e.clientX) - this.imageLeft
      this.pointerY = Math.floor(e.clientY) - this.imageTop
    },
    touchmove(e) {
      if (!this.isMovable) return

      // 移動距離
      this.imageLeft = Math.floor(e.pageX) - this.pointerX
      this.imageTop = Math.floor(e.pageY) - this.pointerY

      // 外側に出ないように画像の移動を抑制する
      const constrainRangeX = Math.floor(this.fieldWidth / 4)
      const constrainRangeY = Math.floor(this.fieldHeight / 4)
      const maxLeft = this.fieldClientX + constrainRangeX
      const maxTop = this.fieldClientY + constrainRangeY
      const minLeft = maxLeft - constrainRangeX * 2
      const minTop = maxTop - constrainRangeY * 2
      if (this.imageLeft > maxLeft) this.imageLeft = maxLeft
      if (this.imageLeft < minLeft) this.imageLeft = minLeft
      if (this.imageTop > maxTop) this.imageTop = maxTop
      if (this.imageTop < minTop) this.imageTop = minTop

      this.image.style.left = this.imageLeft + 'px'
      this.image.style.top = this.imageTop + 'px'
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
    getFieldSize() {
      const field = document.getElementById('edit-field')
      if(field) {
        this.fieldClientX = Math.floor(field.getBoundingClientRect().left)
        this.fieldClientY = Math.floor(field.getBoundingClientRect().top)
        this.fieldWidth = Math.floor(field.getBoundingClientRect().right) - this.fieldClientX
        this.fieldHeight = Math.floor(field.getBoundingClientRect().bottom) - this.fieldClientY

        console.log(`ImageEdit.fieldClientY: ${this.fieldClientY}`)
        this.image = document.getElementById('edit-image')
        this.imageLeft = Math.floor(this.fieldWidth * this.trimming.x) + this.fieldClientX
        this.imageTop = Math.floor(this.fieldHeight * this.trimming.y) + this.fieldClientY
        this.image.style.left = this.imageLeft + 'px'
        this.image.style.top = this.imageTop + 'px'
      }
    },
    updateTrimming() {
      const trimmingX = ((this.imageLeft - this.fieldClientX) / this.fieldWidth).toFixed(3)
      const trimmingY = ((this.imageTop - this.fieldClientY) / this.fieldHeight).toFixed(3)
      const formData = params.renewFormData(this.formData)
      formData.set(`${this.targetModel}[trimming]`, JSON.stringify({x: trimmingX, y: trimmingY}))
      this.$emit('emitFormData', formData)
    }
  },
  mounted() {
    console.log('ImageEdit#mounted')

    window.addEventListener('resize', this.handleResize)

    this.imageUrl = this.formData.get(`${this.targetModel}[image_url]`)
    this.trimming = params.trimming(this.formData, this.targetModel)
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
  }
}
</script>
