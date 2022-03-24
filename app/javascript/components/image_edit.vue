<template>
  <section>
    <h2>ImageEdit</h2>
    <div>{{ editImageLeft }}</div>
    <div>{{ editImageTop }}</div>
    <div id="edit-field" @pointermove="touchmove($event)"
         @pointerup="touchend($event)"
         @pointerleave="touchend($event)"
         style="width: 400px; height:300px; background-color: black;"
    >
      <img :src="imageUrl" id="edit-image" width="200" draggable="false"
           @pointerdown="touchstart($event)"
           style="position: absolute;"
      />
      <div id="edit-filter"
          style="width: 400px; height:300px;
          background-color: transparent;
          outline: white solid 50px;
          outline-offset: -50px;
          opacity: 70%; pointer-events: none;"
      ></div>
    </div>
  </section>
</template>
<script>

export default {
  name: 'ImageEdit',
  props: [
    'formData'
  ],
  data() {
    return {
      trimming: null,
      imageUrl: null,
      expansion: 1,
      isMovable: false,
      editFieldLeft: null,
      editFieldTop: null,
      editImage: null,
      editImageLeft: 0,
      editImageTop: 0,
      shiftX: null,
      shiftY: null,
      editFilterWidth: 50,
      editFilterHeight: 50
    }
  },
  methods: {
    touchstart(e) {
      this.isMovable = true
      this.shiftX = e.clientX - this.editImage.getBoundingClientRect().left
      this.shiftY = e.clientY - this.editImage.getBoundingClientRect().top
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
      const trimmingX = this.editImageLeft - this.editFieldLeft - this.editFilterWidth
      const trimmingY = this.editImageTop - this.editFieldTop - this.editFilterHeight
      const trimming = JSON.stringify({ x: trimmingX, y: trimmingY })
      this.formData.append('map[trimming]', trimming)
      e.preventDefault()
    }
  },
  created() {
    const trimming = this.formData.get('map[trimming]')
    try {
      this.trimming = JSON.parse(trimming)
    } catch {
      this.trimming = {x: 0, y: 0}
    }
    this.imageUrl = this.formData.get('map[image_url]')
  },
  mounted() {
    const editField = document.getElementById('edit-field')
    this.editFieldLeft = Math.floor(editField.getBoundingClientRect().left)
    this.editFieldTop = Math.floor(editField.getBoundingClientRect().top)

    let editImageLeft = this.editFieldLeft + 100
    let editImageTop =  this.editFieldTop + 50
    if (this.trimming !== null && typeof(this.trimming) === 'object') {
      editImageLeft = this.editFieldLeft + this.editFilterWidth + this.trimming.x
      editImageTop = this.editFieldTop + this.editFilterHeight + this.trimming.y
    }

    this.editImage = document.getElementById('edit-image')
    this.editImage.style.left = editImageLeft + 'px'
    this.editImage.style.top = editImageTop + 'px'
  },
  updated() {
    this.$emit('emitFormData', this.formData)
  }
}
</script>
