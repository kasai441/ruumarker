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
           style="position: absolute; top: 250px; left:200px;"
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
    }
  },
  methods: {
    touchstart(e) {
      console.log('touch start:%d,%d', e.offsetX, e.offsetY)
      this.isMovable = true
      const image = document.getElementById('image')
      if (image) console.log('page:%d,%d', image.offsetWidth, image.offsetHeight)
    },
    touchmove(e) {
      if (!this.isMovable) return
      console.log('movePage:%d,%d', e.pageX, e.pageY)
      console.log('moveOffset:%d,%d', e.offsetX, e.offsetY)
      const image = document.getElementById('image')
      console.log(image.style)
      console.log('style.left:')
      console.log(image.style.left)
      const x = Math.floor(e.pageX * this.expansion)
      const y = Math.floor(e.pageY * this.expansion)
      image.style.left = x + 'px'
      image.style.top = y + 'px'
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
