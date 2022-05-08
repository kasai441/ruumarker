<template>
  <section>
    <div id="edit-field" @pointermove="touchmove($event)" @pointerup="touchend($event)" class="my-16 edit-size">
      <img :src="imageSrc" id="edit-image" draggable="false" @pointerdown="touchstart($event)"
           class="absolute z-10 edit-size object-contain">
      <div class="relative">
        <div class="absolute z-30 edit-size pointer-events-none bg-transparent outline outline-4 outline-lime-500"></div>
        <div class="absolute z-20 edit-size pointer-events-none bg-transparent outline outline-240 outline-slate-200 opacity-40"></div>
      </div>
      <div>editFieldLeft {{ this.editFieldLeft }}</div>
      <div>editFieldWidth {{ this.editFieldWidth }}</div>
      <div>editImageLeft {{ this.editImageLeft }}</div>
      <div>imageSrc {{ this.imageSrc }}</div>
      <div>trimming {{ this.trimming }}</div>
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
      imageSrc: null,
      isMovable: false,
      editFieldLeft: 0,
      editFieldTop: 0,
      editFieldWidth: 0,
      editFieldHeight: 0,
      editImage: null,
      editImageLeft: 0,
      editImageTop: 0,
      shiftX: 0,
      shiftY: 0
    }
  },
  methods: {
    touchstart(e) {
      this.isMovable = true
      this.shiftX = Math.floor(e.clientX) - this.editImageLeft
      this.shiftY = Math.floor(e.clientY) - this.editImageTop
    },
    touchmove(e) {
      if (!this.isMovable) return
      this.editImageLeft = Math.floor(e.pageX) - this.shiftX
      this.editImageTop = Math.floor(e.pageY) - this.shiftY

      // 外側に出ないように画像の移動を抑制する
      const constrainRangeX = Math.floor(this.editFieldWidth / 3)
      const constrainRangeY = Math.floor(this.editFieldHeight / 3)
      const maxLeft = this.editFieldLeft + constrainRangeX
      const maxTop = this.editFieldTop + constrainRangeY
      const minLeft = maxLeft - constrainRangeX * 2
      const minTop = maxTop - constrainRangeY * 2
      if (this.editImageLeft > maxLeft) this.editImageLeft = maxLeft
      if (this.editImageLeft < minLeft) this.editImageLeft = minLeft
      if (this.editImageTop > maxTop) this.editImageTop = maxTop
      if (this.editImageTop < minTop) this.editImageTop = minTop

      this.editImage.style.left = this.editImageLeft + 'px'
      this.editImage.style.top = this.editImageTop + 'px'
    },
    touchend(e) {
      this.isMovable = false
      this.updateTrimming()
      e.preventDefault()
    },
    handleResize() {
      this.getFieldSize()
      this.updateTrimming()
    },
    getFieldSize() {
      const editField = document.getElementById('edit-field')
      if(editField) {
        this.editFieldLeft = Math.floor(editField.getBoundingClientRect().left)
        this.editFieldTop = Math.floor(editField.getBoundingClientRect().top)
        this.editFieldWidth = Math.floor(editField.getBoundingClientRect().right) - this.editFieldLeft
        this.editFieldHeight = Math.floor(editField.getBoundingClientRect().bottom) - this.editFieldTop

        this.editImage = document.getElementById('edit-image')
        this.editImageLeft = Math.floor(this.editFieldWidth * this.trimming.x) + this.editFieldLeft
        this.editImageTop = Math.floor(this.editFieldHeight * this.trimming.y) + this.editFieldTop
        this.editImage.style.left = this.editImageLeft + 'px'
        this.editImage.style.top = this.editImageTop + 'px'
      }
    },
    updateTrimming() {
      const trimmingX = ((this.editImageLeft - this.editFieldLeft) / this.editFieldWidth).toFixed(3)
      const trimmingY = ((this.editImageTop - this.editFieldTop) / this.editFieldHeight).toFixed(3)
      this.formData.set(`${this.targetModel}[trimming]`, JSON.stringify({x: trimmingX, y: trimmingY}))
      this.$emit('emitFormData', this.formData)
    }
  },
  mounted() {
    window.addEventListener('resize', this.handleResize)
    const imageUrl = this.formData.get(`${this.targetModel}[image_url]`)
    this.imageSrc = imageUrl
    this.trimming = params.trimming(this.formData, this.targetModel)
    this.getFieldSize()
  },
  updated() {
    const imageFile = this.formData.get(`${this.targetModel}[image]`)
    if (!imageFile) return
    const editImage = document.getElementById( 'edit-image' )
    params.readImageUrl(editImage, imageFile)
  },
  beforeDestroy: function () {
    window.removeEventListener('resize', this.handleResize)
  }
}
</script>
