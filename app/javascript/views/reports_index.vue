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
      <p class="text-slate-700">
        「PRINT」から印刷ダイアログを表示してPDF出力を選択できます
      </p>
      <p class="text-sm text-slate-500 pl-4">
        ※ ダイアログが出ない場合、手動でブラウザの印刷画面を開いてください
      </p>
      <a class="text-sm text-lime-600 pl-6" @pointerdown="help">各ブラウザのPDF出力方法</a>
    </div>
    <div class="fixed relative h-28 sm:h-20 print:hidden"></div>
    <div class="w-full px-8">
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
  </section>
</template>

<script>
import ImageShow from '../components/image_show.vue'
import LocatorsIndex from '../components/locators_index.vue'
import params from '../modules/params'
import tags from '../modules/tags'

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
    tags.hideBars()
  }
}
</script>
