<template>
  <section>
    <div class="flex flex-col items-center. pt-1">
      <h2 class="w-field font-h2">キズ点検表</h2>
    </div>
    <image-show :room-id="roomId" :id="mapId" field-model="map" :image-url="mapImageUrl" :trimming="mapTrimming"
                locators-model="mark" :locators-json="marks"
                @emit-form-data="getFormData"></image-show>
    <div class="py-4 flex flex-col items-center">
      <div id="locators-table" class="h-28">
        <div v-if="marksPresent">
          <table class="table table-compact">
            <thead>
              <tr>
                <th></th>
                <th>キズ</th>
                <th>作成日</th>
                <th></th>
              </tr>
            </thead>
            <tbody id="locators-tbody"></tbody>
          </table>
        </div>
        <div v-else class="w-field h-28 rounded-lg bg-slate-100 flex justify-center items-center">キズを追加できます</div>
      </div>
    </div>
    <div class="flex flex-col items-center">
      <div class="absolute w-field h-48 flex flex-row-reverse items-end">
        <img src="/new_mark.png" @click='newMark' @pointerdown="unbindHalfvanish" @pointerup="halfvanish"
           id="create-mark" class="absolute z-10" width="50">
      </div>
    </div>
    <div class="h-20"></div>
  </section>
</template>

<script>
import ImageShow from '../components/image_show.vue'
import tags from '../modules/tags'
import api from '../modules/api'

export default {
  name: 'RoomsShow',
  inject: [
    'roomId',
    'marks',
    'map',
  ],
  data() {
    return {
      mapId: null,
      mapImageUrl: null,
      mapTrimming: null,
      formData: null,
      marksPresent: this.areMarks()
    }
  },
  components: {
    ImageShow
  },
  methods: {
    getFormData(formData) {
      this.formData = formData
    },
    newMark() {
      location.href = `/rooms/${this.roomId}/marks/new`
    },
    halfvanish(e) {
      tags.parent('IMG', e.target).classList.add('animate-halfvanish')
    },
    unbindHalfvanish(e) {
      tags.parent('IMG', e.target).classList.remove('animate-halfvanish')
    },
    areMarks() {
      return JSON.parse(this.marks).length > 0
    },
    generateTbody() {
      const tbody = document.getElementById('locators-tbody')
      JSON.parse(this.marks).forEach((mark, index) => {
        const number = tags.generateElement('td', {
          append: [index + 1]
        })
        const description = tags.generateElement('td', {
          class: ['description'],
          append: [this.brief(mark.description)]
        })
        const createdAt = tags.generateElement('td', {
          class: ['whitespace-normal'],
          append: [this.formatDate(mark.created_at)]
        })
        const deleteBtn = tags.generateElement('td', {
          class: [],
          append: [tags.generateElement('a', {
            class: ['delete-locators', 'btn', 'btn-circle', 'btn-outline', 'btn-sm'],
            append: ['×']
          })]
        })
        const tr = tags.generateElement('tr', {
          id: `mark-${mark.id}`,
          class: ['hover'],
          append: [number, description, createdAt, deleteBtn]
        })
        tbody.append(tr)
      })
    },
    brief(description) {
      console.log(description)

      if (!description || description.length === 0) {
        return '説明なし'
      } else if (description.length > 10) {
        return `${description.substr(0, 10)}…`
      } else {
        return description
      }
    },
    formatDate(date) {
      const d = new Date(date)
      return `${d.getFullYear()}/
      ${d.getMonth()+1}/
      ${d.getDate()}`.replace(/\n|\r/g, '')
    },
    print() {
      window.print()
    },
    visitLocators(e) {
      const locatorsModel = 'mark'
      console.log('visit')
      if (e.target.classList.value.includes('btn')) return

      console.log('vvvvv')
      const tr = tags.parent('TR', e.target)
      const regex = `${locatorsModel}-`
      if (tr && tr.id.match(regex)) {
        console.log('iiiii')
        const id = tr.id.replace(regex, '')
        location.href = `/rooms/${this.roomId}/${locatorsModel}s/${id}/edit`
      }
    },
    async deleteLocators(e) {
      const locatorsModel = 'mark'
      const tr = tags.parent('TR', e.target)
      const regex = `${locatorsModel}-`
      if (!tr || !tr.id.match(regex)) return

      const description = tr.getElementsByClassName('description')[0].innerHTML
      if (!confirm(`「${this.brief(description)}」を削除します。よろしいですか？`)) return

      const id = tr.id.replace(regex, '')
      await api.actions.delete(`/api/rooms/${this.roomId}/marks/${id}`)
      location.href = `/rooms/${this.roomId}`
    }
  },
  created() {
    const map = JSON.parse(this.map)
    this.mapId = map['id']
    this.mapImageUrl = map['image_url']
    this.mapTrimming = map['trimming']
  },
  mounted() {
    const download = document.getElementById('download')
    download.classList.remove('hidden')
    download.addEventListener('click', this.print)
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
    const download = document.getElementById('download')
    download.removeEventListener('click', this.print)
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
