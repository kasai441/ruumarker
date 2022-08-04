<template>
  <section>
    <div class="flex flex-col items-center">
      <div class="w-field flex justify-between items-center">
        <h2 id="room-title" class="font-h2 pb-2">入居時チェック表</h2>
        <p class="pt-3 text-xs sm:text-sm text-zinc-700 text-right">{{ createdAt }} 作成</p>
      </div>
      <p class="w-field text-xs sm:text-sm text-zinc-500">※ URLにアクセスすれば編集閲覧が可能です</p>
      <p class="w-field text-xs sm:text-sm text-zinc-500">※ URLは秘密情報として保管してください</p>
      <p class="w-field text-xs sm:text-sm text-zinc-500 pb-2">※ 作成から約10日で全データが自動削除されます</p>
      <image-show :room-id="roomId" :form-data="formData"
                  locators-model="mark" :locators-json="marks"
                  @emit-form-data="getFormData"></image-show>
      <div v-if="marksPresent">
        <locators-index :room-id="roomId" :locators="marks" locators-model="mark"></locators-index>
      </div>
      <div v-else class="w-field h-28 rounded-lg bg-slate-100 flex justify-center items-center">
        キズを追加できます
      </div>
    </div>
    <a id="create-mark" @click='createMark'
       class="new-mark fixed z-10 flex flex-col items-center">
      <img src="/new_mark.png" width="50">
      <svg viewBox="0 0 58 17" width="58" height="17">
        <text x="3" y="0" dominant-baseline="text-before-edge" class="font-btn font-bg">キズ追加</text>
        <text x="3" y="0" dominant-baseline="text-before-edge" class="font-btn fill-lime-600">キズ追加</text>
      </svg>
    </a>
    <a id="scroll-above" @click='scrollAbove'
       class="scroll-above hidden fixed z-10 flex flex-col items-center mt-3">
      <a class="btn btn-sm text-2xl pt-1 opacity-60">^</a>
      <svg viewBox="0 0 32 17" width="32" height="17">
        <text x="3" y="0" dominant-baseline="text-before-edge" class="font-btn font-bg">TOP</text>
        <text x="3" y="0" dominant-baseline="text-before-edge" class="font-btn fill-slate-600">TOP</text>
      </svg>
    </a>
    <div class="h-20"></div>
  </section>
</template>

<script>
import ImageShow from '../components/image_show.vue'
import LocatorsIndex from '../components/locators_index.vue'
import api from '../modules/api'
import params from '../modules/params'
import tags from '../modules/tags'

export default {
  name: 'RoomsShow',
  inject: [
    'roomId',
    'roomCreatedAt',
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
      createdAt: null
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
    async createMark(e) {
      tags.parent('A', e.target).classList.add('animate-fadeout')
      await api.actions.create(`/api/rooms/${this.roomId}/marks`)
      // location.href = `/rooms/${this.roomId}/marks`
    },
    scrollAbove() {
      window.scrollTo({
        behavior: 'smooth',
        left: 0,
        top: 0
      })
    },
    areMarks() {
      return JSON.parse(this.marks).length > 0
    },
    print() {
      const download = document.getElementById('download')
      download.classList.add('animate-fadeout')
      location.href = `/rooms/${this.roomId}/reports`
    },
    scroll() {
      const roomTitle = document.getElementById('room-title')
      if (roomTitle.getBoundingClientRect().top < 64) {
        this.slidein()
      } else {
        this.slideout()
      }
    },
    browserBack() {
      tags.browserBack()
    },
    slidein() {
      const scrollAbove = document.getElementById('scroll-above')
      scrollAbove.classList.remove('hidden')
      scrollAbove.classList.add('animate-slidein')
      scrollAbove.classList.remove('animate-slideout')
    },
    slideout() {
      const scrollAbove = document.getElementById('scroll-above')
      scrollAbove.classList.remove('animate-slidein')
      scrollAbove.classList.add('animate-slideout')
      setTimeout(() => {
        scrollAbove.classList.add('hidden')
      }, 500)
    }
  },
  created() {
    this.formData = params.initFormData(this.map)
    this.createdAt = params.formatDate(JSON.parse(this.roomCreatedAt))
  },
  mounted() {
    const download = document.getElementById('download')
    download.classList.remove('hidden')
    download.addEventListener('click', this.print)

    window.addEventListener('scroll', this.scroll)
    window.addEventListener('popstate', this.browserBack)
  },
  beforeDestroy() {
    const download = document.getElementById('download')
    download.removeEventListener('click', this.print)

    window.removeEventListener('scroll', this.scroll)
    window.removeEventListener('popstate', this.browserBack)
  }
}
</script>
