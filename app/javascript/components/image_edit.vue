<template>
  <section>
    <h2>ImageEdit</h2>
    <div>{{ trimming }}</div>
    <div>{{ exX }}</div>
    <div id="base-edit-field" @pointermove="touchmove($event)"
         @pointrup="touchend($event)"
         @pointerleave="touchend($event)"
         style="width: 600px; height:300px; background-color: black;"
    >
      <img :src="imageUrl" id="image" width="200" height="200"
           @pointerdown="touchstart($event)"
           style="position: absolute"
      />
    </div>
    <div></div>
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
      exX: 0,
      exY: 0,
    }
  },
  methods: {
    touchstart(e) {
      console.log('touch start:%d,%d', e.offsetX, e.offsetY)
      this.isMovable = true
    },
    touchmove(e) {
      if (!this.isMovable) return
      console.log('move:%d,%d', e.pageX, e.pageY)
      console.log('moveOffset:%d,%d', e.offsetX, e.offsetY)
      const image = document.getElementById('image')
      console.log(image.style)
      const x = e.offsetX * this.expansion //+ this.dx
      const y = e.offsetY * this.expansion //+ this.dy
      // console.log(x)
      let dx = 0
      let dy = 0
      if (this.exX && this.exY) {
        dx = x - this.exX
        dy = y - this.exY
      }
      this.exX = x
      this.exY = y
      // console.log(this.exX)
      // console.log(dx)
      // console.log(image.style.left)
      // console.log(image.style.left.replace(/[^\d]/g, ''))
      var tempX = dx + Number(image.style.left.replace(/[^\d]/g, ''))
      var tempY = dy + Number(image.style.top.replace(/[^\d]/g, ''))
      console.log(tempX)
      if (tempX > 0) image.style.left = tempX + 'px'
      console.log(image.style.left)
      if (tempY > 0) image.style.top = tempY + 'px'
      e.preventDefault()
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
  updated() {
    this.$emit('emitFormData', this.formData)
  }
}
</script>
