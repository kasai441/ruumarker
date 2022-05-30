<template>
  <section id="image-show">
    <div class="flex flex-col items-center">
      <div id="show-field" @pointerdown="scrollTable($event)" @pointerup="unbindFadeout($event)"
           class="mb-4 w-field h-field rounded-lg relative border border-1 border-slate-300 overflow-hidden">
        <img :src="imageUrl" id="show-image"
             class="rounded-lg absolute w-field h-field
             object-contain">
        <img src="/camera.png" @click='imageEdit' @pointerdown="unbindHalfvanish" @pointerup="halfvanish"
             id="image-edit" class="absolute z-10" width="40">
      </div>
    </div>
  </section>
</template>
<script>
import params from '../modules/params'
import tags from '../modules/tags'

export default {
  name: 'ImageShow',
  props: [
    'roomId',
    'id',
    'fieldModel',
    'imageUrl',
    'trimming',
    'fieldEditName',
    'locatorsModel',
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
      location.href = `/rooms/${this.roomId}/${this.fieldModel}s/${this.id}/edit`
    },
    halfvanish(e) {
      tags.parent('IMG', e.target).classList.add('animate-halfvanish')
    },
    unbindHalfvanish(e) {
      tags.parent('IMG', e.target).classList.remove('animate-halfvanish')
    },
    getFieldSize() {
      const showFieldLeft = Math.floor(this.showField.getBoundingClientRect().left)
      const showFieldTop = Math.floor(this.showField.getBoundingClientRect().top)
      this.showFieldWidth = Math.floor(this.showField.getBoundingClientRect().right) - showFieldLeft
      this.showFieldHeight = Math.floor(this.showField.getBoundingClientRect().bottom) - showFieldTop

      const showImage = document.getElementById('show-image')
      const trimming = params.parseOrInit(this.trimming)
      showImage.style.left = Math.floor(this.showFieldWidth * trimming.x) + 'px'
      showImage.style.top = Math.floor(this.showFieldHeight * trimming.y) + 'px'
      this.locators.forEach(locator => {
        const a = document.getElementById(`locator-${locator.id}`)
        const location = params.parseOrInit(locator.location)
        a.style.left = Math.floor(this.showFieldWidth * (0.5 - location.x + Number(trimming.x))) - 10 + 'px'
        a.style.top = Math.floor(this.showFieldHeight * (0.5 - location.y + Number(trimming.y))) - 10 + 'px'
      })

      const camera = document.getElementById('image-edit')
      camera.style.left = this.showFieldWidth - 45 + 'px'
      camera.style.top = this.showFieldHeight - 45 + 'px'
    },
    generateLocators() {
      this.locators.forEach((locator, index) => {
        const img = document.createElement('img')
        img.src = `/${this.locatorsModel}s.png`
        img.classList.add('absolute', 'w-5', 'pointer-events-none')

        const number = document.createElement('a')
        number.append(index + 1)
        number.classList.add('relative', 'text-white', 'text-sm', 'pointer-events-none')

        const a = document.createElement('a')
        a.append(img)
        a.append(number)
        a.classList.add('absolute', 'w-5', 'flex', 'justify-center', 'items-center')
        a.id = `locator-${locator.id}`
        this.showField.append(a)
      })
    },
    scrollTable(e) {
      const a = tags.parent('A', e.target)
      const regex = /locator/g
      if (a && a.id.match(regex)) {
        const table = document.getElementById('locators-table')
        const trs = table.getElementsByTagName('tr')
        Array.prototype.forEach.call(trs, tr => {
          tr.classList.remove('active', 'animate-fadeout')
        })

        const tr = document.getElementById(a.id.replace(regex, this.locatorsModel))
        tr.classList.add('active')
        table.scrollTo({
          behavior: 'smooth',
          left: 0,
          top: tr.offsetTop
        })
      }
    },
    unbindFadeout(e) {
      const a = tags.parent('A', e.target)
      const regex = /locator/g
      if (a && a.id.match(regex)) {
        const tr = document.getElementById(a.id.replace(regex, this.locatorsModel))
        tr.classList.remove('active')
        tr.classList.add('animate-fadeout')
      }
    },
    visitLocators(e) {
      if (e.target.classList.value.includes('btn')) return
      const tr = tags.parent('TR', e.target)
      const regex = `${this.locatorsModel}-`
      if (tr && tr.id.match(regex)) {
        const id = tr.id.replace(regex, '')
        location.href = `/rooms/${this.roomId}/${this.locatorsModel}s/${id}/edit`
      }
    },
    handleResize() {
      this.getFieldSize()
    }
  },
  mounted() {
    const table = document.getElementById('locators-table')
    const trs = table.getElementsByTagName('tr')
    Array.prototype.forEach.call(trs, tr => {
      tr.addEventListener('click', this.visitLocators)
    })
    window.addEventListener('resize', this.handleResize)

    this.showField = document.getElementById('show-field')
    this.generateLocators()
    this.getFieldSize()
  },
  beforeDestroy() {
    const table = document.getElementById('locators-table')
    const trs = table.getElementsByTagName('tr')
    Array.prototype.forEach.call(trs, tr => {
      tr.removeEventListener('click', this.visitLocators)
    })

    window.removeEventListener('resize', this.handleResize)
  }
}
</script>
