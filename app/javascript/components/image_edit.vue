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
      <img :src="imageUrl" id="image" width="200" height="200" draggable="false"
           @pointerdown="touchstart($event)"
           style="position: relative; top: 50px; left:200px;"
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
      console.log('style.left:')
      console.log(image.style.left)
      const x = Math.floor(e.offsetX * this.expansion) //+ this.dx
      const y = Math.floor(e.offsetY * this.expansion) //+ this.dy
      console.log('x:')
      console.log(x)
      console.log(('exX:'))
      console.log(this.exX)
      let dx = x - this.exX
      let dy = y - this.exY
      this.exX = x
      this.exY = y
      let tempX = dx + Number(image.style.left.match(/^\d+/g))
      let tempY = dy + Number(image.style.top.match(/^\d+/g))
      console.log('tempX:')
      console.log(tempX)
      image.style.left = tempX + 'px'
      image.style.top = tempY + 'px'
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
