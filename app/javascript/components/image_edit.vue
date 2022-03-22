<template>
  <section>
    <h2>ImageEdit</h2>
    <div>{{ trimming }}</div>
    <div id="base-edit-field" @mousemove="touchmove($event)"
         @mouseup="touchend($event)"
         @mouseleave="touchend($event)"
         style="width: 600px; height:300px; background-color: black;"
    >
      <img :src="imageUrl" width="200" height="200"/>
<!--      <line v-for="line in list_line"-->
<!--            @mousedown="touchstart($event)"-->
<!--            :x1="line.x1" :y1="line.y1"-->
<!--            :x2="line.x2" :y2="line.y2"-->
<!--            :stroke-width="line.width" :stroke="line.stroke"/>-->
<!--      <rect stroke="darkblue" stroke-width="5" fill="none"-->
<!--            :width="300" :height="300">-->
<!--      </rect>-->
    </div>
    <div></div>
  </section>
</template>
<!--<style>-->
<!--#base-edit-field {-->
<!--  width: 500px;-->
<!--  height: 250px;-->
<!--}-->
<!--</style>-->
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
      // list_line: [
      //   {x1: 0, y1: 0, x2: 100, y2: 100, width: '10', stroke: 'green'}
      // ]
    }
  },
  methods: {
    touchstart(e) {
      console.log('touch start:%d,%d', e.offsetX, e.offsetY)
    },
    touchmove(e) {
      console.log('move')
    },
    touchend(e) {
      console.log('end')
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
