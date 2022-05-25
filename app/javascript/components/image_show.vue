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
    'marksJSON'
  ],
  data() {
    return {
      showField: null,
      showFieldWidth: 0,
      showFieldHeight: 0,
      marks: JSON.parse(this.marksJSON)
    }
  },
  methods: {
    mapEdit() {
      location.href = `/rooms/${this.roomId}/${this.targetModel}s/${this.id}/edit`
    },
    getFieldSize() {
      const showFieldLeft = Math.floor(this.showField.getBoundingClientRect().left)
      const showFieldTop = Math.floor(this.showField.getBoundingClientRect().top)
      this.showFieldWidth = Math.floor(this.showField.getBoundingClientRect().right) - showFieldLeft
      this.showFieldHeight = Math.floor(this.showField.getBoundingClientRect().bottom) - showFieldTop

      const showImage = document.getElementById('show-image')
      const trimming = JSON.parse(this.trimming)
      showImage.style.left = Math.floor(this.showFieldWidth * trimming.x) + 'px'
      showImage.style.top = Math.floor(this.showFieldHeight * trimming.y) + 'px'
      this.marks.forEach(mark => {
        const div = document.getElementById(`locate-mark-${mark.id}`)
        const location = mark.location ? JSON.parse(mark.location) : {x: 0, y: 0}
        div.style.left = Math.floor(this.showFieldWidth * (0.5 - location.x)) - 10 + 'px'
        div.style.top = Math.floor(this.showFieldHeight * (0.5 - location.y)) - 10 + 'px'
      })
    },
    locateMarks() {
      this.marks.forEach((mark, index) => {
        const a = document.createElement('a')
        a.append(index + 1)
        a.classList.add('relative', 'text-white', 'left-1', '-top-3', 'text-xs')

        const img = document.createElement('img')
        img.src = '/mark.png'
        img.classList.add('absolute', 'w-5')

        const div = document.createElement('div')
        div.append(img)
        div.append(a)
        div.classList.add('absolute', 'w-5')
        div.id = `locate-mark-${mark.id}`
        this.showField.append(div)
      })
    },
    handleResize() {
      this.getFieldSize()
    }
  },
  mounted() {
    window.addEventListener('resize', this.handleResize)
    this.showField = document.getElementById('show-field')
    this.locateMarks()
    this.getFieldSize()
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
  }
}
</script>
