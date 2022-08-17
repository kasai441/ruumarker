<template>
  <section>
    <div class="bg-slate-200 print:bg-white">
      <div class="fixed w-full z-10 py-1 bg-black flex justify-center print:hidden">
        <div class="w-show-field flex items-center">
          <a @pointerdown="room" class="w-1/6 text-xl text-slate-400 btn btn btn-ghost">＜</a>
          <h2 class="w-2/3 text-xl text-white text-center">PDF用レイアウト</h2>
          <div class="w-1/6"></div>
        </div>
      </div>
      <div class="fixed relative h-14 print:hidden"></div>
      <div class="fixed w-full z-20 py-2 px-4 bg-white flex justify-center border-b border-slate-900/20 print:hidden">
        <div class="main-screen flex flex-col items-start">
          <p class="text-slate-700">
            「PRINT」から印刷ダイアログを表示してPDF出力を選択できます
          </p>
          <p class="text-sm text-slate-500">
            ※ ダイアログが出ない場合、手動でブラウザの印刷画面を開いてください
          </p>
          <a class="text-sm text-lime-600 underline" @pointerdown="help">各ブラウザのPDF出力方法</a>
        </div>
      </div>
      <div class="fixed relative h-32 sm:h-20 print:hidden"></div>
      <div class="relative z-10 py-2 text-center print:hidden">
        <p>＜印刷プレビュー＞</p>
      </div>
      <div class="flex justify-center print:block print:justify-start">
        <div class="main-screen print:w-full outline outline-112 outline-slate-200 overflow-scroll bg-white print:outline-0">
          <div class="w-full pt-12 print:pt-0 px-8">
            <div class="w-print-field py-6 pb-2 flex justify-between">
              <div class="flex flex-col">
                <h1 class="font-bold text-xl">入居時チェック表</h1>
                <p class="pt-1 text-xs sm:text-sm text-zinc-700 text-right">作成ツール: Ruumarker (https://ruumarker.herokuapp.com)</p>
              </div>
              <p class="pt-2 text-xs sm:text-sm text-zinc-700 text-right">{{ printedAt }}</p>
            </div>
            <p class="font-p pb-2">入居時に以下の箇所に確認事項がありました。</p>
            <div class="font-bold text-lg pt-2 pb-1">間取り図</div>
            <image-show :room-id="roomId" :form-data="formData"
                        locators-model="mark" :locators-json="marks"
                        :print-mode="true"
                        @emit-form-data="getFormData"></image-show>
            <div v-if="marksPresent">
              <div class="font-bold text-lg pt-2 pb-1">詳細情報</div>
              <p class="font-p pb-2">間取り図の各番号の詳細情報は以下の通りです。</p>
              <locators-index :room-id="roomId" :locators="marks" locators-model="mark"
                              :print-mode="true"></locators-index>
            </div>
          </div>
        </div>
      </div>
      <div class="relative z-10 h-24vh print:hidden"></div>
      <div class="relative z-10 h-8 print:hidden"></div>
      <div class="show-footer fixed z-10 p-4 sm:pt-5 flex justify-center print:hidden">
        <div @pointerdown="print" class="w-1/2 btn btn-lime">
          print
        </div>
      </div>

    </div>
  </section>
</template>

<script>
import ImageShow from '../components/image_show.vue'
import LocatorsIndex from '../components/locators_index.vue'
import params from '../modules/params'
import visuals from '../modules/visuals'

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
      marksPresent: this.areMarks(),
      printedAt: null
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
      const screenScroll = document.getElementById('screen-scroll')
      screenScroll.addEventListener('scroll', this.scroll)
      screenScroll.scrollTo({
        left: 0,
        top: 0
      })

      window.print()
    },
    help() {
      location.href = '/help#pdf'
    }
  },
  created() {
    this.formData = params.initFormData(this.map)
    this.printedAt = params.formatDate()
  },
  mounted() {
    visuals.hideBars()
  }
}
</script>
