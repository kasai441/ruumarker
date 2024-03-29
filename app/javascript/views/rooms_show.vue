<template>
  <section>
    <div class="flex flex-col items-center">
      <div class="main-screen flex justify-between items-center">
        <h2 id="room-title" class="font-h2 pb-2">入居時チェック表</h2>
        <p class="pt-3 text-xs sm:text-sm text-zinc-700 text-right">{{ createdAt }} 作成</p>
      </div>
      <div class="main-screen">
        <p class="text-xs sm:text-sm text-zinc-500">※ URLにアクセスすれば編集閲覧が可能です</p>
        <p class="text-xs sm:text-sm text-zinc-500">※ URLは秘密情報として保管してください</p>
        <p class="text-xs sm:text-sm text-zinc-500 pb-2">※ 作成から約10日で全データが自動削除されます</p>
      </div>
      <image-show :room-id="roomId" :form-data="formData"
                  locators-model="mark" :locators-json="marks"
                  @emit-form-data="getFormData"></image-show>
      <div v-if="marksPresent">
        <locators-index :room-id="roomId" :locators="marks" locators-model="mark"></locators-index>
      </div>
      <div v-else class="w-show-field h-28 rounded-lg bg-slate-100 flex justify-center items-center">
        <a id="create-mark" class="w-2/3 btn btn-lime" @click='createMark'>キズを登録する</a>
      </div>
    </div>
    <div v-if="marksPresent" id="show-footer" class="show-footer fixed z-10 p-4 sm:pt-5 flex justify-center border-t border-slate-900/10">
      <div class="main-screen flex justify-center">
        <div class="w-1/2">
          <div class="pr-1">
            <a id="add-mark" @click='createMark' class="w-full btn btn-lime">キズを登録する</a>
          </div>
        </div>
        <div class="w-1/2">
          <div class="pl-1">
            <a id="download" @click='download' class="w-full btn btn-lime">
              <div class="sm:hidden">
                チェック表を<br>印刷する
              </div>
              <div class="hidden sm:block">
                チェック表を印刷する
              </div>
            </a>
          </div>
        </div>
      </div>
    </div>
    <a id="scroll-above" @click='scrollAbove'
       class="scroll-above hidden fixed z-10 flex flex-col items-center mt-3">
      <a class="btn btn-sm text-2xl pt-1 opacity-60">^</a>
      <svg viewBox="0 0 32 17" width="32" height="17">
        <text x="3" y="0" dominant-baseline="text-before-edge" class="font-btn font-bg">TOP</text>
        <text x="3" y="0" dominant-baseline="text-before-edge" class="font-btn fill-slate-600">TOP</text>
      </svg>
    </a>
    <div class="h-24"></div>
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
      const response = await api.actions.create(`/api/rooms/${this.roomId}/marks`)
      if (response !== 'error') location.href = `/rooms/${this.roomId}/marks/${response.data['id']}/edit`
    },
    download(e) {
      tags.parent('A', e.target).classList.add('animate-fadeout')
      location.href = `/rooms/${this.roomId}/reports`
    },
    scrollAbove() {
      const screenScroll = document.getElementById('screen-scroll')
      screenScroll.scrollTo({
        behavior: 'smooth',
        left: 0,
        top: 0
      })
    },
    areMarks() {
      return JSON.parse(this.marks).length > 0
    },
    scroll() {
      const roomTitle = document.getElementById('room-title')
      if (roomTitle.getBoundingClientRect().top < 64) {
        this.slidein()
      } else {
        this.slideout()
      }
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
    const screenScroll = document.getElementById('screen-scroll')
    screenScroll.addEventListener('scroll', this.scroll)
  },
  beforeDestroy() {
    const screenScroll = document.getElementById('screen-scroll')
    screenScroll.removeEventListener('scroll', this.scroll)
  }
}
</script>
