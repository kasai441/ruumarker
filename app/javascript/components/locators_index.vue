<template>
  <section id="locators-index">
    <div class="py-4">
      <div id="locators-table" class="w-field"></div>
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
    generateTbody() {
      const tableContainer = document.getElementById('locators-table')
      let trs = []
      JSON.parse(this.locators).forEach((locator, index) => {
        const number = tags.generateElement('td', {
          class: ['bg-transparent'],
          append: [index + 1]
        })
        locator.image_url ||= '/sample.png'
        const image = tags.generateElement('td', {
          class: ['bg-transparent'],
          append: [tags.generateElement('div', {
            class: ['thumbnail-field', 'w-thumbnail', 'h-thumbnail', 'border', 'border-slate-200', 'rounded-lg', 'relative', 'overflow-hidden'],
            append: [tags.generateElement('img', {
              class: ['thumbnail-image', 'w-thumbnail', 'h-thumbnail', 'rounded-lg', 'absolute', 'object-contain'],
              src: locator.image_url
            })]
          })]
        })
        const description = tags.generateElement('td', {
          class: ['whitespace-normal', 'description', 'bg-transparent'],
          append: [this.brief(locator.description)]
        })
        const createdAt = tags.generateElement('td', {
          class: ['whitespace-normal', 'bg-transparent'],
          append: [this.formatDate(locator.created_at)]
        })
        const deleteBtn = tags.generateElement('td', {
          class: ['bg-transparent'],
          append: [tags.generateElement('a', {
            class: ['delete-locators', 'btn', 'btn-circle', 'btn-outline', 'btn-sm'],
            append: ['×']
          })]
        })
        const tr = tags.generateElement('tr', {
          id: `${this.locatorsModel}-${locator.id}`,
          class: this.printMode ? [] : ['hover'],
          append: this.printMode ?
            [number, image, description, createdAt]:
            [number, image, description, createdAt, deleteBtn]
        })

        trs.push(tr)

        if (index === JSON.parse(this.locators).length - 1) {
          tableContainer.append(this.generateTable(trs))
          if (this.printMode) {
            tableContainer.append(this.generateFooter(index, { lastPage: true }))
          }
          trs = []
        } else if (this.printMode && index % 5 === 1) {
          tableContainer.append(this.generateTable(trs))
          tableContainer.append(this.generateFooter(index))
          trs = []
        }
      })
    },
    generateTable(trs) {
      const tds = [tags.generateElement('td', {
        append: ['番号']
      }), tags.generateElement('td', {
        append: ['画像']
      }), tags.generateElement('td', {
        append: ['説明']
      }), tags.generateElement('td', {
        append: ['作成日']
      })]
      if (!this.printMode) tds.push(tags.generateElement('td', {
        append: ['削除']
      }))

      return tags.generateElement('table', {
        class: ['table', 'table-compact', 'w-full'],
        append: [tags.generateElement('thead', {
          append: [tags.generateElement('tr', {
            append: tds
          })]
        }), tags.generateElement('tbody', {
          append: trs
        })]
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
    brief(description) {
      if (!description || description.length === 0) {
        return '-'
      } else if (description.length > 10) {
        return `${description.substr(0, 10)}…`
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

      const tr = tags.parent('TR', e.target)
      const regex = `${this.locatorsModel}-`
      if (tr && tr.id.match(regex)) {
        const id = tr.id.replace(regex, '')
        location.href = `/rooms/${this.roomId}/${this.locatorsModel}s/${id}/edit`
      }
    },
    async deleteLocators(e) {
      const tr = tags.parent('TR', e.target)
      const regex = `${this.locatorsModel}-`
      if (!tr || !tr.id.match(regex)) return

      const description = tr.getElementsByClassName('description')[0].innerHTML
      if (!confirm(`「${this.brief(description)}」を削除します。よろしいですか？`)) return

      const id = tr.id.replace(regex, '')
      await api.actions.delete(`/api/rooms/${this.roomId}/${this.locatorsModel}s/${id}`)
      location.href = `/rooms/${this.roomId}`
    },
    styleThumbnail() {
      const field = tags.readSize(null, document.getElementsByClassName('thumbnail-field')[0])
      const images = document.getElementsByClassName('thumbnail-image')
      JSON.parse(this.locators).forEach((locator, index) => {
        const trimmingRate = params.parseOrInit(locator.trimming)
        const trimming = params.toPixel(field, trimmingRate)
        tags.styleLeftTop(null, trimming, images[index])
      })
    },
    handleResize() {
      this.styleThumbnail()
    }
  },
  mounted() {
    this.generateTbody()
    this.styleThumbnail()
    window.addEventListener('resize', this.handleResize)
    if (this.printMode) return

    const as = document.getElementsByClassName('delete-locators')
    Array.prototype.forEach.call(as, a => {
      a.addEventListener('click', this.deleteLocators)
    })

    const table = document.getElementById('locators-table')
    const trs = table.getElementsByTagName('tr')
    Array.prototype.forEach.call(trs, tr => {
      tr.addEventListener('click', this.visitLocators)
    })
  },
  beforeDestroy() {
    window.removeEventListener('resize', this.handleResize)
    if (this.printMode) return

    const as = document.getElementsByClassName('delete-locators')
    Array.prototype.forEach.call(as, a => {
      a.removeEventListener('click', this.deleteLocators)
    })

    const table = document.getElementById('locators-table')
    const trs = table.getElementsByTagName('tr')
    Array.prototype.forEach.call(trs, tr => {
      tr.removeEventListener('click', this.visitLocators)
    })
  }
}
</script>
