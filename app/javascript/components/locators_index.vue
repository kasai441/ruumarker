<template>
  <section id="locators-index">
    <div class="py-4 flex flex-col items-center">
      <div id="locators-table" class="w-field">
        <table class="table table-compact">
          <thead>
          <tr>
            <th></th>
            <th>キズ</th>
            <th></th>
            <th>作成日</th>
            <th></th>
          </tr>
          </thead>
          <tbody id="locators-tbody"></tbody>
        </table>
      </div>
    </div>
  </section>
</template>

<script>
import tags from '../modules/tags'
import api from '../modules/api'

export default {
  name: 'LocatorsIndex',
  props: [
    'roomId',
    'locators',
    'locatorsModel'
  ],
  data() {
    return {
    }
  },
  methods: {
    generateTbody() {
      const tbody = document.getElementById('locators-tbody')
      JSON.parse(this.locators).forEach((locator, index) => {
        const number = tags.generateElement('td', {
          class: ['bg-transparent'],
          append: [index + 1]
        })
        const image = tags.generateElement('td', {
          class: ['bg-transparent'],
          append: [tags.generateElement('div', {
            class: ['w-thumbnail', 'h-thumbnail', 'border', 'border-slate-100', 'rounded-lg'],
            append: [tags.generateElement('img', {
              class: ['w-thumbnail', 'h-thumbnail', 'rounded-lg', 'object-contain'],
              src: locator.image_url
            })]
          })]
        })
        const description = tags.generateElement('td', {
          class: ['description', 'bg-transparent'],
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
          class: ['hover'],
          append: [number, image, description, createdAt, deleteBtn]
        })
        tbody.append(tr)
      })
    },
    brief(description) {
      if (!description || description.length === 0) {
        return '説明なし'
      } else if (description.length > 10) {
        return `${description.substr(0, 10)}…`
      } else {
        return description
      }
    },
    formatDate(str) {
      const d = new Date(str)
      const date = `${d.getFullYear()}/${d.getMonth()+1}/${d.getDate()}`.replace(/\\s/g, '')
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

      console.log(tr)
      const description = tr.getElementsByClassName('description')[0].innerHTML
      if (!confirm(`「${this.brief(description)}」を削除します。よろしいですか？`)) return

      const id = tr.id.replace(regex, '')
      await api.actions.delete(`/api/rooms/${this.roomId}/${this.locatorsModel}s/${id}`)
      location.href = `/rooms/${this.roomId}`
    }
  },
  mounted() {
    this.generateTbody()
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
