<template>
  <section>
    <div class="border-b border-slate-900/10 p-6 print:hidden">
      <h2 class="text-xl print:hidden">印刷用レイアウト</h2>
    </div>
    <div class="font-bold text-lg p-6">キズ点検表</div>
    <image-show :room-id="roomId" :id="mapId" field-model="map" :image-url="mapImageUrl" :trimming="mapTrimming"
                locators-model="mark" :locators-json="marks"
                @emit-form-data="getFormData"></image-show>
    <div v-if="marksPresent">
      <locators-index :room-id="roomId" :locators="marks" locators-model="mark"></locators-index>
    </div>
  </section>
</template>

<script>
import ImageShow from '../components/image_show.vue'
import LocatorsIndex from '../components/locators_index.vue'

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
    LocatorsIndex,
    ImageShow
  },
  methods: {
    getFormData(formData) {
      this.formData = formData
    },
    areMarks() {
      return JSON.parse(this.marks).length > 0
    },
    // print() {
    //   location.href = `/rooms/${this.roomId}/reports`
    // },
  },
  created() {
    const map = JSON.parse(this.map)
    this.mapId = map['id']
    this.mapImageUrl = map['image_url']
    this.mapTrimming = map['trimming']
  },
  mounted() {
    const titleBar = document.getElementById('title-bar')
    titleBar.classList.add('hidden')
    // titleBar.addEventListener('click', this.print)
  },
  beforeDestroy() {
    // const download = document.getElementById('download')
    // download.removeEventListener('click', this.print)
  }
}
</script>
