<template>
  <section>
    <div class="flex flex-col items-center">
      <div class="fixed w-full z-10
      border-b border-slate-900/10 p-4 bg-white
      flex justify-center  print:hidden">
        <div class="w-field flex items-center">
          <a @click="room" class="w-1/6 text-xl text-slate-400 btn btn btn-ghost">＜</a>
          <h2 class="w-2/3 text-xl text-center">印刷用レイアウト</h2>
          <div class="w-1/6"></div>
        </div>
      </div>
      <div class="relative h-20"></div>
      <div class="w-field font-bold text-lg p-6">キズ点検表</div>
      <image-show :room-id="roomId" :id="mapId" field-model="map" :image-url="mapImageUrl" :trimming="mapTrimming"
                  locators-model="mark" :locators-json="marks"
                  @emit-form-data="getFormData"></image-show>
      <div v-if="marksPresent">
        <locators-index :room-id="roomId" :locators="marks" locators-model="mark"></locators-index>
      </div>
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
    room() {
      location.href = `/rooms/${this.roomId}`
    }
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
