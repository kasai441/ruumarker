<template>
  <section>
    <h2>ImageEdit</h2>
    <div>{{ trimming }}</div>
    <div>{{ exX }}</div>
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
      shiftY: null
    }
  },
  methods: {
    touchstart(e) {
      console.log('touch start:%d,%d', e.offsetX, e.offsetY)
      this.isMovable = true
      const image = document.getElementById('edit-image')
      if (image) console.log('page:%d,%d', image.offsetWidth, image.offsetHeight)
      this.shiftX = e.clientX - image.getBoundingClientRect().left
      this.shiftY = e.clientY - image.getBoundingClientRect().top
    },
    touchmove(e) {
      if (!this.isMovable) return
      const image = document.getElementById('edit-image')
      console.log('movePage:%d,%d', e.pageX, e.pageY)
      console.log('moveOffset:%d,%d', e.offsetX, e.offsetY)
      console.log(image.style)
      console.log('style.left:')
      console.log(image.style.left)
      const x = Math.floor(e.pageX * this.expansion)
      const y = Math.floor(e.pageY * this.expansion)
      image.style.left = x - this.shiftX + 'px'
      image.style.top = y - this.shiftY + 'px'
    },
    touchend(e) {
      console.log('end')
      this.isMovable = false
      e.preventDefault()
    }
  },
  created() {
    this.trimming = this.formData.get('[map]trimming')
    this.imageUrl = this.formData.get('[map]image_url')
  },
  mounted() {
    const baseEditField = document.getElementById('base-edit-field')
    const editImage = document.getElementById('edit-image')
    this.fieldX = Math.floor(baseEditField.getBoundingClientRect().left)
    this.fieldY = Math.floor(baseEditField.getBoundingClientRect().top)
    editImage.style.left = this.fieldX + 200 + 'px'
    editImage.style.top = this.fieldY + 50 + 'px'
  },
  updated() {
    this.$emit('emitFormData', this.formData)
  }
}
</script>
