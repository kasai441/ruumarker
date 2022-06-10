<template>
  <section>
    <div class="break-after-page">page-break-after</div>
    <div class="fixed w-full z-10
    p-4 bg-black
    flex flex-col items-center print:hidden">
      <div class="w-field flex items-center">
        <a @click="room" class="w-1/6 text-xl text-slate-400 btn btn btn-ghost">＜</a>
        <h2 class="w-2/3 text-xl text-white text-center">PDF用レイアウト</h2>
        <div @click="print" class="w-1/6 btn btn-lime flex flex-auto py-0">
          print
        </div>
      </div>
    </div>
    <div class="relative h-20 print:hidden"></div>
    <div class="w-full p-2 border-b border-slate-900/20 print:hidden">
      <p class="text-slate-500">
        「PRINT」から印刷ダイアログを表示してPDF出力を選択できます
      </p>
      <p class="text-sm text-slate-500">
        ※ ダイアログが出ない場合、手動でブラウザの印刷画面を開いてください
        <span class="text-lime-600">各ブラウザのPDF出力方法</span>
      </p>
    </div>
    <div class="w-field font-bold text-lg p-6">キズ点検表</div>
    <div class="break-after-page">page-break-after</div>
    <image-show :room-id="roomId" :id="mapId" field-model="map" :image-url="mapImageUrl" :trimming="mapTrimming"
                locators-model="mark" :locators-json="marks"
                @emit-form-data="getFormData"
                :print-mode="true"></image-show>
    <div v-if="marksPresent">
      <locators-index :room-id="roomId" :locators="marks" locators-model="mark"
                      :print-mode="true"></locators-index>
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
    },
    print() {
      window.print()
    },
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
