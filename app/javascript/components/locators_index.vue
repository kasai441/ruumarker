<template>
  <section id="locators-index">
    <div class="py-4">
      <div id="locators-rows" class="w-field"></div>
    </div>
  </section>
</template>

<script>
import api from '../modules/api'
import params from '../modules/params'
import tags from '../modules/tags'

export default {
  name: 'LocatorsIndex',
  props: [
    'roomId',
    'locators',
    'locatorsModel',
    'printMode'
  ],
  data() {
    return {
    }
  },
  methods: {
    generateIndex() {
      const tableContainer = document.getElementById('locators-rows')
      let rows = []
      const src = this.printMode ? '/locators_white.png' : '/locators.png'
      JSON.parse(this.locators).forEach((locator, index) => {
        const numberImg = tags.generateElement('img', {
          class: ['absolute', 'w-7', 'h-7', 'pointer-events-none'],
          src: src
        })

        const numberValue = tags.generateElement('a', {
          class: ['relative', 'w-7', 'text-sm', 'text-center', 'pointer-events-none'],
          append: [index + 1]
        })
        if (!this.printMode) numberValue.classList.add('text-white')

        const classA = ['absolute', 'w-7', 'h-7', 'flex', 'flex-col', 'items-center', 'justify-center']

        const a = tags.generateElement('a', {
          class: classA,
          append: [numberImg, numberValue]
        })

        const number = tags.generateElement('div', {
          class: ['w-1/12', 'flex', 'justify-center', 'items-center'],
          append: [a]
        })

        locator.image_url ||= '/sample_locator.png'
        const sizeClass = this.printMode ?
          ['w-print-thumbnail', 'h-print-thumbnail'] :
          ['w-thumbnail', 'h-thumbnail']
        const image = tags.generateElement('div', {
          class: ['bg-transparent', 'w-5/12', 'flex', 'justify-center', 'items-center'],
          append: [tags.generateElement('div', {
            class: ['thumbnail-field', 'border', 'border-slate-200', 'relative', 'overflow-hidden'].concat(sizeClass),
            append: [tags.generateElement('img', {
              class: ['thumbnail-image', 'absolute', 'object-contain', 'max-w-none'].concat(sizeClass),
              src: locator.image_url
            })]
          })]
        })
        const createdAt = tags.generateElement('div', {
          class: ['whitespace-normal', 'bg-transparent', 'w-full', 'text-slate-600', 'text-xs', 'sm:text-sm', 'p-1', 'border-t', 'b-slate-400'],
          append: [this.formatDate(locator.created_at)]
        })

        const max = this.printMode ? 60 : 29
        const description = tags.generateElement('div', {
          class: ['description'],
          append: [this.brief(locator.description, max)]
        })

        const text = tags.generateElement('div', {
          class: ['whitespace-normal', 'bg-transparent', 'w-5/12', 'text-sm', 'sm:text-base', 'flex', 'flex-col', 'justify-between', 'p-1'],
          append: [description, createdAt]
        })

        const deleteBtn = tags.generateElement('a', {
          class: ['bg-transparent', 'w-1/12', 'flex', 'justify-end'],
          append: [tags.generateElement('a', {
            class: ['delete-locators', 'btn', 'btn-ghost', 'btn-xs', 'sm:btn-sm'],
            append: ['×']
          })]
        })
        const row = tags.generateElement('div', {
          id: `${this.locatorsModel}-${locator.id}`,
          class: ['locators-row', 'flex', 'b-slate-400', 'mb-2', 'p-1', 'sm:p-2'],
          append: [number, image, text]
        })
        if (this.printMode) {
          row.classList.add('border-b')
        } else {
          row.append(deleteBtn)
          row.classList.add('border', 'rounded-lg')
        }

        rows.push(row)

        if (index === JSON.parse(this.locators).length - 1) {
          tableContainer.append(tags.generateElement('div', {append: rows}))
          if (this.printMode) {
            tableContainer.append(this.generateFooter(index, { lastPage: true }))
          }
          rows = []
        } else if (this.printMode && index % 5 === 1) {
          tableContainer.append(tags.generateElement('div', {append: rows}))
          tableContainer.append(this.generateFooter(index))
          rows = []
        }
      })
    },
    generateFooter(index, options) {
      const maxPage = Math.ceil((JSON.parse(this.locators).length - 2) / 5) + 1
      const nowPage = Math.ceil((index - 1) / 5) + 1

      return tags.generateElement('div', {
        class: options && options.lastPage ?
          ['p-4', 'w-full', 'text-right'] :
          ['p-4', 'w-full', 'text-right', 'break-after-page'],
        append: [`${nowPage} / ${maxPage}`]
      })
    },
    brief(description, max) {
      if (!description || description.length === 0) {
        return '-'
      } else if (description.length > max) {
        return `${description.substr(0, max)}…`
      } else {
        return description
      }
    },
    formatDate(str) {
      const d = new Date(str)
      const date = `${d.getFullYear()} ${d.getMonth()+1}/${d.getDate()}`.replace(/\\s/g, '')
      let minutes = String(d.getMinutes())
      if (minutes.length === 1) minutes = `0${minutes}`
      const time = `${d.getHours()}:${minutes}`.replace(/\s/g, '')
      return `${date} ${time}`
    },
    visitLocators(e) {
      if (e.target.classList.value.includes('btn')) return

      const row = tags.parent(null, e.target, 'locators-row')
      const regex = `${this.locatorsModel}-`
      if (row && row.id.match(regex)) {
        const id = row.id.replace(regex, '')
        location.href = `/rooms/${this.roomId}/${this.locatorsModel}s/${id}/edit`
      }
    },
    async deleteLocators(e) {
      const row = tags.parent(null, e.target, 'locators-row')
      const regex = `${this.locatorsModel}-`
      if (!row || !row.id.match(regex)) return

      const description = row.getElementsByClassName('description')[0].innerText
      console.log(row.getElementsByClassName('description')[0].innerText)
      if (!confirm(`「${this.brief(description, 10)}」を削除します。よろしいですか？`)) return

      const id = row.id.replace(regex, '')
      await api.actions.delete(`/api/rooms/${this.roomId}/${this.locatorsModel}s/${id}`)
      location.href = `/rooms/${this.roomId}`
    },
    layoutThumbnail() {
      const fieldSize = tags.readSize(null, document.getElementsByClassName('thumbnail-field')[0])
      const images = document.getElementsByClassName('thumbnail-image')
      JSON.parse(this.locators).forEach((locator, index) => {
        const formData = params.initFormData(locator)
        tags.expand(fieldSize, formData, null, images[index])
        tags.trim(fieldSize, formData,null, images[index])
      })
    },
    handleResize() {
      this.layoutThumbnail()
    }
  },
  mounted() {
    if (this.printMode) {
      const locators_rows = document.getElementById('locators-rows')
      locators_rows.classList.remove('w-field')
      locators_rows.classList.add('w-print-field')
    }

    this.generateIndex()
    this.layoutThumbnail()
    window.addEventListener('resize', this.handleResize)
    if (this.printMode) return

    const as = document.getElementsByClassName('delete-locators')
    Array.prototype.forEach.call(as, a => {
      a.addEventListener('click', this.deleteLocators)
    })

    const rows = document.getElementsByClassName('locators-row')
    Array.prototype.forEach.call(rows, row => {
      row.addEventListener('click', this.visitLocators)
    })
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
    if (this.printMode) return

    const as = document.getElementsByClassName('delete-locators')
    Array.prototype.forEach.call(as, a => {
      a.removeEventListener('click', this.deleteLocators)
    })

    const rows = document.getElementsByClassName('locators-row')
    Array.prototype.forEach.call(rows, row => {
      row.removeEventListener('click', this.visitLocators)
    })
  }
}
</script>
