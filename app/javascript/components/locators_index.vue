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
  methods: {
    generateIndex() {
      const tableContainer = document.getElementById('locators-rows')
      let rows = []
      const elements = tags.generateLocators(JSON.parse(this.locators), { indexMode: true })
      JSON.parse(this.locators).forEach((locator, index) => {
        const number = document.createElement('div')
        number.classList.add('w-1/12', 'flex', 'justify-center', 'items-center')
        number.append(elements[index])

        const thumbnail = document.createElement('div')
        thumbnail.classList.add('bg-transparent', 'w-5/12', 'flex', 'justify-center', 'items-center')
        thumbnail.append(this.generateThumbnail(locator))

        const text = document.createElement('div')
        text.classList.add('w-5/12', 'whitespace-normal', 'bg-transparent', 'text-sm', 'sm:text-base', 'flex', 'flex-col', 'justify-between', 'p-1')
        text.append(this.generateDescription(locator), this.generateCreatedAt(locator))

        const deleteBtn = document.createElement('div')
        deleteBtn.classList.add('bg-transparent', 'w-1/12', 'flex', 'justify-end')
        deleteBtn.append(this.generateX())

        const row = document.createElement('div')
        row.id = `${this.locatorsModel}-${locator.id}`
        row.classList.add('locators-row', 'flex', 'b-slate-400', 'mb-2', 'p-1', 'sm:p-2')
        row.append(number, thumbnail, text)

        if (this.printMode) {
          row.classList.add('border-b')
        } else {
          row.append(deleteBtn)
          row.classList.add('border', 'rounded-lg')
        }

        rows.push(row)

        const page = document.createElement('div')
        page.append(...rows)
        if (index === JSON.parse(this.locators).length - 1) {
          tableContainer.append(page)
          if (this.printMode) {
            tableContainer.append(this.generateFooter(index, { lastPage: true }))
          }
          rows = []
        } else if (this.printMode && index % 5 === 1) {
          tableContainer.append(page)
          tableContainer.append(this.generateFooter(index))
          rows = []
        }
      })
    },
    generateThumbnail(locator) {
      const sizeClass = this.printMode ?
        ['w-print-thumbnail', 'h-print-thumbnail'] :
        ['w-thumbnail', 'h-thumbnail']

      const image = document.createElement('img')
      image.classList.add('thumbnail-image', 'absolute', 'object-contain', 'max-w-none')
      image.classList.add(...sizeClass)
      locator.image_url ||= '/sample_locator.png'
      image.src = locator.image_url

      const imageField = document.createElement('div')
      imageField.classList.add('thumbnail-field', 'border', 'border-slate-200', 'relative', 'overflow-hidden')
      imageField.classList.add(...sizeClass)
      imageField.append(image)

      return imageField
    },
    generateDescription(locator) {
      const description = document.createElement('div')
      description.classList.add('description')
      const max = this.printMode ? 60 : 29
      description.append(this.brief(locator.description, max))
      return description
    },
    generateCreatedAt(locator) {
      const createdAt = document.createElement('div')
      createdAt.classList.add('whitespace-normal', 'bg-transparent', 'w-full', 'text-slate-600', 'text-xs', 'sm:text-sm', 'p-1', 'border-t', 'b-slate-400')
      createdAt.append(params.formatDate(locator.created_at))
      return createdAt
    },
    generateX() {
      const x = document.createElement('a')
      x.classList.add('delete-locators', 'btn', 'btn-ghost', 'btn-xs', 'sm:btn-sm')
      x.append('×')
      return x
    },
    generateFooter(index, options) {
      const maxPage = Math.ceil((JSON.parse(this.locators).length - 2) / 5) + 1
      const nowPage = Math.ceil((index - 1) / 5) + 1

      const pageIndex = document.createElement('div')
      pageIndex.classList.add('p-4', 'w-full', 'text-right')
      if (!options || !options.lastPage) pageIndex.classList.add('break-after-page')
      pageIndex.append(`${nowPage} / ${maxPage}`)

      return pageIndex
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
