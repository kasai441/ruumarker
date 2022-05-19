<template>
  <section id="location-edit">
    <div id="location-field" @pointermove="touchmove($event)" @pointerup="touchend($event)" @pointerleave="touchend($event)"
         class="my-16 edit-size">
      <div class="relative">
        <div id="show-frame"
             class="pointer-events-none absolute z-20 edit-size
             rounded-lg bg-transparent bg-transparent outline outline-112 opacity-40 outline-white"></div>
        <img :src="imageUrl" id="show-image" draggable="false" @pointerdown="touchstart($event)"
             class="rounded-lg absolute z-10 edit-size w-full object-contain">
      </div>
      <div class="absolute z-30 edit-size pointer-events-none bg-transparent outline outline-4 outline-lime-500"></div>
      <div class="absolute z-20 edit-size pointer-events-none bg-transparent outline outline-112 outline-slate-200 opacity-40"></div>
    </div>
    <div>editFieldLeft{{ editFieldLeft }}</div>
    <div>editFieldTop{{ editFieldTop }}</div>
    <div>editFieldWidth{{ editFieldWidth }}</div>
    <div>editFieldHeight{{ editFieldHeight }}</div>
    <div>editImageLeft{{ editImageLeft }}</div>
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
      // this.editImage.classList.add('shadow-2xl')
      this.shiftX = Math.floor(e.clientX) - this.editImageLeft - this.editFieldLeft
      this.shiftY = Math.floor(e.clientY) - this.editImageTop -this.editFieldTop
      console.log(e.clientX)
      console.log(this.shiftX)
    },
    touchmove(e) {
      if (!this.isMovable) return
      this.editImageLeft = Math.floor(e.offsetX) - this.shiftX
      this.editImageTop = Math.floor(e.offsetY) - this.shiftY
      console.log(e.offsetX)

      // // 外側に出ないように画像の移動を抑制する
      // const constrainRangeX = Math.floor(this.editFieldWidth / 4)
      // const constrainRangeY = Math.floor(this.editFieldHeight / 4)
      // const maxLeft = this.editFieldLeft + constrainRangeX
      // const maxTop = this.editFieldTop + constrainRangeY
      // const minLeft = maxLeft - constrainRangeX * 2
      // const minTop = maxTop - constrainRangeY * 2
      // if (this.editImageLeft > maxLeft) this.editImageLeft = maxLeft
      // if (this.editImageLeft < minLeft) this.editImageLeft = minLeft
      // if (this.editImageTop > maxTop) this.editImageTop = maxTop
      // if (this.editImageTop < minTop) this.editImageTop = minTop

      this.editImage.style.left = this.editImageLeft + 'px'
      this.editImage.style.top = this.editImageTop + 'px'
    },
    touchend() {
      this.isMovable = false
      // this.editImage.classList.remove('shadow-2xl')
      this.updateLocation()
    },
    handleResize() {
      this.getFieldSize()
      this.updateLocation()
    },
    getFieldSize() {
      const editField = document.getElementById('location-field')
      if(editField) {
        this.editFieldLeft = Math.floor(editField.getBoundingClientRect().left)
        this.editFieldTop = Math.floor(editField.getBoundingClientRect().top)
        this.editFieldWidth = Math.floor(editField.getBoundingClientRect().right) - this.editFieldLeft
        this.editFieldHeight = Math.floor(editField.getBoundingClientRect().bottom) - this.editFieldTop

        console.log(`ImageEdit.editFieldTop: ${this.editFieldTop}`)
        this.editImage = document.getElementById('show-frame')
        this.editImageLeft = Math.floor(this.editFieldWidth * this.location.x)
        this.editImageTop = Math.floor(this.editFieldHeight * this.location.y)
        this.editImage.style.left = this.editImageLeft + 'px'
        this.editImage.style.top = this.editImageTop + 'px'
      }
    },
    trimBaseImage() {
      const showImage = document.getElementById('show-image')
      showImage.style.left = Math.floor(this.editFieldWidth * this.trimming.x) + 'px'
      showImage.style.top = Math.floor(this.showFieldHeight * this.trimming.y) + 'px'
    },
    updateLocation() {
      const locationX = ((this.editImageLeft - this.editFieldLeft) / this.editFieldWidth).toFixed(3)
      const locationY = ((this.editImageTop - this.editFieldTop) / this.editFieldHeight).toFixed(3)
      const formData = params.renewFormData(this.formData)
      formData.set(`${this.targetModel}[location]`, JSON.stringify({x: locationX, y: locationY}))
      // this.$emit('emitFormData', formData)
    }
  },
  mounted() {
    console.log('ImageEdit#mounted')

    window.addEventListener('resize', this.handleResize)

    this.imageUrl = this.mapFormData.get('map[image_url]')
    this.trimming = params.trimming(this.mapFormData, 'map')
    console.log(this.trimming)
    // this.location = this.formData.get(`${this.targetModel}[location]`)
    this.getFieldSize()
    this.trimBaseImage()
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
  }
}
</script>
