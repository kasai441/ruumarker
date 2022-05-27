<template>
  <section id="image-show">
    <div class="flex flex-col items-center">
      <div id="show-field" @pointerdown="activate($event)"
           class="mb-4 edit-size rounded-lg relative outline outline-3 outline-slate-200 overflow-hidden">
        <img :src="imageUrl"
             id="show-image" class="rounded-lg absolute edit-size w-full object-contain">
      </div>
      <a @click="imageEdit" id="image-edit" class="btn btn-lime">{{ fieldEditName }}</a>
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
        a.style.left = Math.floor(this.showFieldWidth * (0.5 - location.x + Number(trimming.x))) - 10 + 'px'
        a.style.top = Math.floor(this.showFieldHeight * (0.5 - location.y + Number(trimming.y))) - 10 + 'px'
      })
    },
    generateLocators() {
      this.locators.forEach((locator, index) => {
        const img = document.createElement('img')
        img.src = `/${this.locatorsModel}.png`
        img.classList.add('absolute', 'w-5', 'pointer-events-none')

        const number = document.createElement('a')
        number.append(index + 1)
        number.classList.add('relative', 'text-white', 'left-1', '-top-3', 'text-xs', 'pointer-events-none')

        const a = document.createElement('a')
        a.append(img)
        a.append(number)
        a.classList.add('absolute', 'w-5')
        a.id = `locator-${locator.id}`
        this.showField.append(a)
      })
    },
    activate(e) {
      const a = tags.parent('A', e.target)
      const regex = /locator/g
      if (a && a.id.match(regex)) {
        const table = document.getElementById('locators-table')
        const trs = table.getElementsByTagName('tr')
        Array.prototype.forEach.call(trs, tr => {
          // CSS動作中にCSSを停止して再度動かすための処理
          // https://stackoverflow.com/questions/11131875/what-is-the-cleanest-way-to-disable-css-transition-effects-temporarily
          tr.offsetHeight
          tr.classList.remove('animate-fadeout')
        })

        const tr = document.getElementById(a.id.replace(regex, this.locatorsModel))
        tr.classList.add('animate-fadeout')
        table.scrollTo({
          behavior: 'smooth',
          left: 0,
          top: tr.offsetTop
        })
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
