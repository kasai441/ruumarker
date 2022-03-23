<template>
  <section>
    <h2>ImageEdit</h2>
    <div>{{ trimmingX }}</div>
    <div>{{ trimmingY }}</div>
    <div id="base-edit-field" @pointermove="touchmove($event)"
         @pointerup="touchend($event)"
         @pointerleave="touchend($event)"
         style="width: 600px; height:300px; background-color: black;"
    >
      <img :src="imageUrl" id="edit-image" width="200" height="200" draggable="false"
           @pointerdown="touchstart($event)"
           style="position: absolute;"
      />
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
      fieldX: null,
      fieldY: null,
      shiftX: null,
      shiftY: null,
      trimmingX: 0,
      trimmingY: 0
    }
  },
  methods: {
    touchstart(e) {
      console.log('touch start:%d,%d', e.offsetX, e.offsetY)
      this.isMovable = true
      const editImage = document.getElementById('edit-image')
      if (editImage) console.log('page:%d,%d', editImage.offsetWidth, editImage.offsetHeight)
      this.shiftX = e.clientX - editImage.getBoundingClientRect().left
      this.shiftY = e.clientY - editImage.getBoundingClientRect().top
    },
    touchmove(e) {
      if (!this.isMovable) return
      const editImage = document.getElementById('edit-image')
      const x = Math.floor(e.pageX * this.expansion)
      const y = Math.floor(e.pageY * this.expansion)
      this.trimmingX = x - this.shiftX
      this.trimmingY = y - this.shiftY
      editImage.style.left = this.trimmingX + 'px'
      editImage.style.top = this.trimmingY + 'px'
    },
    touchend(e) {
      console.log('end')
      this.isMovable = false
      const trimming = JSON.stringify({ x: this.trimmingX, y: this.trimmingY })
      this.formData.append('map[trimming]', trimming)
      // this.$emit('emitFormData', this.formData)
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
    const baseEditField = document.getElementById('base-edit-field')
    const editImage = document.getElementById('edit-image')
    this.fieldX = Math.floor(baseEditField.getBoundingClientRect().left)
    this.fieldY = Math.floor(baseEditField.getBoundingClientRect().top)
    let trimmingX = this.fieldX + 200
    let trimmingY =  this.fieldY + 50
    if (this.trimming !== null && typeof(this.trimming) === 'object') {
      trimmingX = this.trimming.x
      trimmingY = this.trimming.y
    }
    editImage.style.left = trimmingX + 'px'
    editImage.style.top = trimmingY + 'px'
  },
  updated() {
    this.$emit('emitFormData', this.formData)
  }
}
</script>
