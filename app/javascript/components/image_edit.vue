<template>
  <section>
    <div id="edit-field"
         @pointermove="touchmove($event)"
         @pointerup="touchend($event)"
         @pointerleave="touchend($event)"
         class="my-16 edit-size">
      <img :src="imageUrl" id="edit-image" draggable="false"
           @pointerdown="touchstart($event)"
           class="absolute z-10 edit-size object-contain">
      <div class="relative">
        <div class="absolute z-30 edit-size pointer-events-none bg-transparent outline outline-4 outline-lime-500"></div>
        <div class="absolute z-20 edit-size pointer-events-none bg-transparent outline outline-240 outline-slate-200 opacity-40"></div>
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
      imageFile: null,
      imageUrl: null,
      expansion: 1,
      isMovable: false,
      editFieldLeft: 0,
      editFieldTop: 0,
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
      const x = Math.floor(e.pageX * this.expansion)
      const y = Math.floor(e.pageY * this.expansion)
      this.editImageLeft = x - this.shiftX
      this.editImageTop = y - this.shiftY
      this.editImage.style.left = this.editImageLeft + 'px'
      this.editImage.style.top = this.editImageTop + 'px'
    },
    touchend(e) {
      this.isMovable = false
      const trimmingX = this.editImageLeft - this.editFieldLeft
      const trimmingY = this.editImageTop - this.editFieldTop
      this.formData.set(`${this.targetModel}[trimming]`, JSON.stringify({x: trimmingX, y: trimmingY}))
      this.$emit('emitFormData', this.formData)
      e.preventDefault()
    }
  },
  created() {
    this.trimming = params.trimming(this.formData, this.targetModel)
    this.imageFile = this.formData.get(`${this.targetModel}[image]`)
    this.imageUrl = this.formData.get(`${this.targetModel}[image_url]`)
  },
  mounted() {
    if (this.imageFile) {
      const uploadedTag = document.getElementById( 'edit-image' )
      params.readImageUrl(uploadedTag, this.imageFile)
    }

    const editField = document.getElementById('edit-field')
    this.editFieldLeft = Math.floor(editField.getBoundingClientRect().left)
    this.editFieldTop = Math.floor(editField.getBoundingClientRect().top)

    this.editImage = document.getElementById('edit-image')
    this.editImage.style.left = this.editFieldLeft + this.trimming.x + 'px'
    this.editImage.style.top = this.editFieldTop + this.trimming.y + 'px'
    this.editImageLeft = Math.floor(this.editImage.getBoundingClientRect().left)
    this.editImageTop = Math.floor(this.editImage.getBoundingClientRect().top)
  },
}
</script>
