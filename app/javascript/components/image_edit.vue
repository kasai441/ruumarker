<template>
  <section>
    <h2>ImageEdit</h2>
    <div>{{ trimmingX }}</div>
    <div>{{ trimmingY }}</div>
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
      trimmingX: 0,
      trimmingY: 0,
      imageUrl: null,
      expansion: 1,
      isMovable: false,
      editImage: null,
      editFieldX: null,
      editFieldY: null,
      shiftX: null,
      shiftY: null
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
      this.trimmingX = x - this.shiftX
      this.trimmingY = y - this.shiftY
      this.editImage.style.left = this.trimmingX + 'px'
      this.editImage.style.top = this.trimmingY + 'px'
    },
    touchend(e) {
      this.isMovable = false
      const trimming = JSON.stringify({ x: this.trimmingX, y: this.trimmingY })
      this.formData.append('map[trimming]', trimming)
      e.preventDefault()
    }
  },
  created() {
    const trimming = this.formData.get('map[trimming]')
    try {
      this.trimming = JSON.parse(trimming)
    } catch {
      this.trimming = {}
    }
    this.imageUrl = this.formData.get('map[image_url]')
  },
  mounted() {
    const editField = document.getElementById('edit-field')
    this.editImage = document.getElementById('edit-image')
    this.editFieldX = Math.floor(editField.getBoundingClientRect().left)
    this.editFieldY = Math.floor(editField.getBoundingClientRect().top)
    let editImageX = this.editFieldX + 100
    let editImageY =  this.editFieldY + 50
    if (this.trimming !== null && typeof(this.trimming) === 'object') {
      editImageX = this.trimming.x
      editImageY = this.trimming.y
    }
    this.editImage.style.left = editImageX + 'px'
    this.editImage.style.top = editImageY + 'px'
  },
  updated() {
    this.$emit('emitFormData', this.formData)
  }
}
</script>
