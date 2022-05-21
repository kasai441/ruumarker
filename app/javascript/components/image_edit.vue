<template>
  <section id="image-edit">
    <div id="edit-field" @pointermove="touchmove($event)" @pointerup="touchend($event)" @pointerleave="touchend($event)"
         class="my-16 edit-size">
      <div class="relative">
        <img :src="imageUrl" id="edit-image" draggable="false" @pointerdown="touchstart($event)"
             class="absolute edit-size object-contain">
        <div class="absolute edit-size pointer-events-none bg-transparent outline outline-240 outline-slate-200 opacity-40"></div>
        <div class="absolute edit-size pointer-events-none bg-transparent outline outline-4 outline-lime-500"></div>
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
      imageOffsetX: 0,
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

      // 外側に出ないように画像の移動を抑制する
      const constrainRangeX = Math.floor(this.fieldWidth / 4)
      const constrainRangeY = Math.floor(this.fieldHeight / 4)
      if (this.imageOffsetX > constrainRangeX) this.imageOffsetX = constrainRangeX
      if (this.imageOffsetX < -constrainRangeX) this.imageOffsetX = -constrainRangeX
      if (this.imageOffsetY > constrainRangeY) this.imageOffsetY = constrainRangeY
      if (this.imageOffsetY < -constrainRangeY) this.imageOffsetY = -constrainRangeY

      this.image.style.left = this.imageOffsetX + 'px'
      this.image.style.top = this.imageOffsetY + 'px'
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
      const field = document.getElementById('edit-field')
      if(field) {
        this.fieldClientX = Math.floor(field.getBoundingClientRect().left)
        this.fieldClientY = Math.floor(field.getBoundingClientRect().top)
        this.fieldWidth = Math.floor(field.getBoundingClientRect().right) - this.fieldClientX
        this.fieldHeight = Math.floor(field.getBoundingClientRect().bottom) - this.fieldClientY

        // 移動分の反映
        console.log(`ImageEdit.fieldClientY: ${this.fieldClientY}`)
        this.image = document.getElementById('edit-image')
        this.imageOffsetX = Math.floor(this.fieldWidth * this.trimming.x)
        this.imageOffsetY = Math.floor(this.fieldHeight * this.trimming.y)
        this.image.style.left = this.imageOffsetX + 'px'
        this.image.style.top = this.imageOffsetY + 'px'
      }
    },
    updateTrimming() {
      this.trimming.x = (this.imageOffsetX / this.fieldWidth).toFixed(3)
      this.trimming.y = (this.imageOffsetY / this.fieldHeight).toFixed(3)
      const formData = params.renewFormData(this.formData)
      formData.set(`${this.targetModel}[trimming]`, JSON.stringify({x: this.trimming.x, y: this.trimming.y}))
      this.$emit('emitFormData', formData)
    }
  },
  mounted() {
    console.log('ImageEdit#mounted')

    window.addEventListener('resize', this.handleResize)
    window.addEventListener('scroll', this.handleScroll)

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
    window.removeEventListener('scroll', this.handleScroll)
  }
}
</script>
