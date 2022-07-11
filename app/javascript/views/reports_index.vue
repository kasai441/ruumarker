<template>
  <section>
    <div class="fixed w-full z-10
    p-4 px-8 bg-black print:hidden">
      <div class="w-field flex items-center">
        <a @pointerdown="room" class="w-1/6 text-xl text-slate-400 btn btn btn-ghost">＜</a>
        <h2 class="w-2/3 text-xl text-white text-center">PDF用レイアウト</h2>
        <div @pointerdown="print" class="w-1/6 btn btn-lime flex flex-auto py-0">
          print
        </div>
      </div>
    </div>
    <div class="fixed relative h-20 print:hidden"></div>
    <div class="fixed w-full z-10
    p-2 px-8 bg-white border-b border-slate-900/20 print:hidden">
      <p class="text-slate-500">
        「PRINT」から印刷ダイアログを表示してPDF出力を選択できます
      </p>
      <p class="text-sm text-slate-500">
        ※ ダイアログが出ない場合、手動でブラウザの印刷画面を開いてください
        <span class="text-lime-600">各ブラウザのPDF出力方法</span>
      </p>
    </div>
    <div class="fixed relative h-28 sm:h-10 print:hidden"></div>
    <div class="w-full px-8">
      <div class="w-print-field font-bold text-lg p-6">キズ点検表</div>
      <image-show :room-id="roomId" :form-data="formData"
                  locators-model="mark" :locators-json="marks"
                  :print-mode="true"
                  @emit-form-data="getFormData"></image-show>
      <div v-if="marksPresent">
        <locators-index :room-id="roomId" :locators="marks" locators-model="mark"
                        :print-mode="true"></locators-index>
      </div>
    </div>
  </section>
</template>

<script>
import ImageShow from '../components/image_show.vue'
import LocatorsIndex from '../components/locators_index.vue'
import params from '../modules/params'

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
    this.formData = params.initFormData(this.map)
  },
  mounted() {
    const titleBar = document.getElementById('title-bar')
    titleBar.classList.add('hidden')
    const titleBarSpace = document.getElementById('title-bar-space')
    titleBarSpace.classList.add('hidden')
    const footerBar = document.getElementById('footer-bar')
    footerBar.classList.add('hidden')
  }
}
</script>
