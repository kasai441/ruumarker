<template>
  <section id="image-show">
    <div class="flex flex-col items-center">
      <div id="show-field" class="my-8 edit-size rounded-lg relative outline outline-3 outline-slate-200 overflow-hidden">
        <img :src="imageUrl" id="show-image" class="rounded-lg absolute edit-size w-full object-contain">
      </div>
      <a @click="imageEdit" id="image-edit" class="btn btn-lime">変更</a>
    </div>
  </section>
</template>
<script>
import params from '../modules/params'

export default {
  name: 'ImageShow',
  props: [
    'roomId',
    'id',
    'targetModel',
    'locatorModel',
    'imageUrl',
    'trimming',
    'locatorsJson'
  ],
  data() {
    return {
      showField: null,
      showFieldWidth: 0,
      showFieldHeight: 0,
      locators: JSON.parse(this.locatorsJson)
    }
  },
  methods: {
    imageEdit() {
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
      this.locators.forEach(locator => {
        const a = document.getElementById(`locator-${locator.id}`)
        const location = params.parseOrInit(locator.location)
        a.style.left = Math.floor(this.showFieldWidth * (0.5 - location.x)) - 10 + 'px'
        a.style.top = Math.floor(this.showFieldHeight * (0.5 - location.y)) - 10 + 'px'
      })
    },
    generateLocators() {
      this.locators.forEach((locator, index) => {
        const img = document.createElement('img')
        img.src = `/${this.locatorModel}.png`
        img.classList.add('absolute', 'w-5')

        const number = document.createElement('a')
        number.append(index + 1)
        number.classList.add('relative', 'text-white', 'left-1', '-top-3', 'text-xs')

        const a = document.createElement('a')
        a.append(img)
        a.append(number)
        a.classList.add('absolute', 'w-5')
        a.id = `locator-${locator.id}`
        a.href = `/rooms/${this.roomId}/${this.locatorModel}s/${locator.id}/edit`
        this.showField.append(a)
      })
    },
    handleResize() {
      this.getFieldSize()
    }
  },
  mounted() {
    window.addEventListener('resize', this.handleResize)
    this.showField = document.getElementById('show-field')
    this.generateLocators()
    this.getFieldSize()
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
  }
}
</script>
