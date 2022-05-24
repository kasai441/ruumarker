<template>
  <section id="image-show">
    <div class="flex flex-col items-center">
      <div id="show-field" class="my-8 edit-size rounded-lg relative outline outline-3 outline-slate-200 overflow-hidden">
        <img :src="imageUrl" id="show-image" class="rounded-lg absolute edit-size w-full object-contain">
      </div>
      <a @click="mapEdit" id="map-edit" class="btn btn-lime">マップ編集</a>
    </div>
  </section>
</template>
<script>
export default {
  name: 'ImageShow',
  props: [
    'roomId',
    'id',
    'targetModel',
    'imageUrl',
    'trimming',
    'marks'
  ],
  data() {
    return {
      showField: null,
      showFieldWidth: 0,
      showFieldHeight: 0
    }
  },
  methods: {
    mapEdit() {
      location.href = `/rooms/${this.roomId}/${this.targetModel}s/${this.id}/edit`
    },
    getFieldSize() {
      this.showField = document.getElementById('show-field')
      if (this.showField) {
        const showFieldLeft = Math.floor(this.showField.getBoundingClientRect().left)
        const showFieldTop = Math.floor(this.showField.getBoundingClientRect().top)
        this.showFieldWidth = Math.floor(this.showField.getBoundingClientRect().right) - showFieldLeft
        this.showFieldHeight = Math.floor(this.showField.getBoundingClientRect().bottom) - showFieldTop

        const showImage = document.getElementById('show-image')
        const trimming = JSON.parse(this.trimming)
        showImage.style.left = Math.floor(this.showFieldWidth * trimming.x) + 'px'
        showImage.style.top = Math.floor(this.showFieldHeight * trimming.y) + 'px'
      }
    },
    locateMarks() {
      const ms = JSON.parse(this.marks)
      Object.keys(ms).forEach((key, index) => {
        const a = document.createElement('a')
        a.append(index + 1)
        const location = ms[key]['location'] ? JSON.parse(ms[key]['location']) : {x: 0, y: 0}
        a.classList.add('absolute', 'bg-white')
        const trimming = JSON.parse(this.trimming)
        console.log(trimming)
        console.log(location)
        console.log(0.5 - location.x + trimming.x)
        a.style.left = Math.floor(this.showFieldWidth * (trimming.x - location.x + 0.5)) + 'px'
        a.style.top = Math.floor(this.showFieldHeight * (trimming.y - location.y + 0.5)) + 'px'
        this.showField.append(a)
      })

    },
    handleResize() {
      this.getFieldSize()
    }
  },
  mounted() {
    window.addEventListener('resize', this.handleResize)
    this.getFieldSize()
    this.locateMarks()
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
  }
}
</script>
