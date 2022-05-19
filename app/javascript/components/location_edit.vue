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
    <div>editFieldLeft{{ editFieldLeft }}</div>
    <div>editFieldTop{{ editFieldTop }}</div>
    <div>editFieldWidth{{ editFieldWidth }}</div>
    <div>editFieldHeight{{ editFieldHeight }}</div>
    <div>editFrameLeft{{ editFrameLeft }}</div>
    <div>editFrameTop{{ editFrameTop }}</div>
    <div>editImageTop{{ editImageTop }}</div>
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
      editFieldLeft: 0,
      editFieldTop: 0,
      editFieldWidth: 0,
      editFieldHeight: 0,
      editFrame: null,
      editFrameLeft: 0,
      editFrameTop: 0,
      editImageLeft: 0,
      editImageTop: 0,
      shiftX: 0,
      shiftY: 0
    }
  },
  methods: {
    touchstart(e) {
      this.isMovable = true
      // this.editFrame.classList.add('shadow-2xl')
      this.shiftX = Math.floor(e.clientX) - this.editFrameLeft - this.editFieldLeft
      this.shiftY = Math.floor(e.clientY) - this.editFrameTop - this.editFieldTop
      console.log(e.clientX)
      console.log(this.shiftX)
    },
    touchmove(e) {
      if (!this.isMovable) return
      this.editFrameLeft = Math.floor(e.offsetX) - this.shiftX + this.editImageLeft
      this.editFrameTop = Math.floor(e.offsetY) - this.shiftY + this.editImageTop
      console.log(e.offsetX)

      // // 外側に出ないように画像の移動を抑制する
      // const constrainRangeX = Math.floor(this.editFieldWidth / 4)
      // const constrainRangeY = Math.floor(this.editFieldHeight / 4)
      // const maxLeft = this.editFieldLeft + constrainRangeX
      // const maxTop = this.editFieldTop + constrainRangeY
      // const minLeft = maxLeft - constrainRangeX * 2
      // const minTop = maxTop - constrainRangeY * 2
      // if (this.editFrameLeft > maxLeft) this.editFrameLeft = maxLeft
      // if (this.editFrameLeft < minLeft) this.editFrameLeft = minLeft
      // if (this.editFrameTop > maxTop) this.editFrameTop = maxTop
      // if (this.editFrameTop < minTop) this.editFrameTop = minTop

      this.editFrame.style.left = this.editFrameLeft + 'px'
      this.editFrame.style.top = this.editFrameTop + 'px'
    },
    touchend() {
      this.isMovable = false
      // this.editFrame.classList.remove('shadow-2xl')
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
      const editField = document.getElementById('edit-location-field')
      if(editField) {
        this.editFieldLeft = Math.floor(editField.getBoundingClientRect().left)
        this.editFieldTop = Math.floor(editField.getBoundingClientRect().top)
        this.editFieldWidth = Math.floor(editField.getBoundingClientRect().right) - this.editFieldLeft
        this.editFieldHeight = Math.floor(editField.getBoundingClientRect().bottom) - this.editFieldTop

        console.log(`ImageEdit.editFieldTop: ${this.editFieldTop}`)
        this.editFrame = document.getElementById('edit-location-frame')
        this.editFrameLeft = Math.floor(this.editFieldWidth * this.location.x)
        this.editFrameTop = Math.floor(this.editFieldHeight * this.location.y)
        this.editFrame.style.left = this.editFrameLeft + 'px'
        this.editFrame.style.top = this.editFrameTop + 'px'

        const editImage = document.getElementById('edit-location-image')
        this.editImageLeft = Math.floor(this.editFieldWidth * this.trimming.x)
        this.editImageTop = Math.floor(this.editFieldHeight * this.trimming.y)
        editImage.style.left = this.editImageLeft + 'px'
        editImage.style.top = this.editImageTop + 'px'
      }
    },
    updateLocation() {
      this.location.x = (this.editFrameLeft / this.editFieldWidth).toFixed(3)
      this.location.y = (this.editFrameTop / this.editFieldHeight).toFixed(3)
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
    // const editImage = document.getElementById( 'location-image' )
    // editImage.src = await params.getImageUrl(imageFile)
  },
  beforeDestroy: () => {
    window.removeEventListener('resize', this.handleResize)
    window.removeEventListener('scroll', this.handleScroll)
  }
}
</script>
