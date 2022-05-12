<template>
  <section id="image-show">
    <div class="flex flex-col items-center">
      <div id="show-field" class="my-8 edit-size rounded-lg relative">
        <div class="absolute -z-10 edit-size rounded-lg bg-transparent bg-transparent outline outline-3 outline-slate-200"></div>
        <div class="absolute -z-20 edit-size rounded-lg bg-transparent bg-transparent outline outline-112 outline-white"></div>
        <img :src="imageUrl" id="show-image" class="rounded-lg absolute -z-30 edit-size w-full object-contain">
      </div>
      <div class="submit_container relative z-60">
        <a @click="mapEdit" id="map-edit" class="btn btn-primary">マップ編集</a>
      </div>
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
    'trimming'
  ],
  data() {
    return {
      showFieldWidth: 0,
      showFieldHeight: 0
    }
  },
  methods: {
    mapEdit() {
      location.href = `/rooms/${this.roomId}/${this.targetModel}s/${this.id}/edit`
    },
    getFieldSize() {
      const showField = document.getElementById('show-field')
      if (showField) {
        const showFieldLeft = Math.floor(showField.getBoundingClientRect().left)
        const showFieldTop = Math.floor(showField.getBoundingClientRect().top)
        this.showFieldWidth = Math.floor(showField.getBoundingClientRect().right) - showFieldLeft
        this.showFieldHeight = Math.floor(showField.getBoundingClientRect().bottom) - showFieldTop

        const showImage = document.getElementById('show-image')
        const trimming = JSON.parse(this.trimming)
        showImage.style.left = Math.floor(this.showFieldWidth * trimming.x) + 'px'
        showImage.style.top = Math.floor(this.showFieldHeight * trimming.y) + 'px'
      }
    },
    handleResize() {
      this.getFieldSize()
    }
  },
  mounted() {
    window.addEventListener('resize', this.handleResize)
    this.getFieldSize()
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
  }
}
</script>
