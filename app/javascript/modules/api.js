import axios from 'axios'
import visuals from './visuals'

const x_csrf_token = document.querySelector('meta[name="csrf-token"]')
const headers = {
  headers: {
    'Content-Type': 'multipart/form-data',
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-TOKEN' : x_csrf_token ? x_csrf_token.getAttribute('content') : null
  }
}

const actions = {
  async create(url, formData) {
    try {
      return await axios.post(url, formData, headers)
    } catch (e) {
      visuals.alertError('登録に失敗しました。お手数ですが再度登録してください。')
      console.error(e)
    }
  },
  async update(url, formData) {
    try {
      await axios.put(url, formData, headers)
    } catch (e) {
      visuals.alertError('保存に失敗しました。お手数ですが再度保存してください。')
      console.error(e)
    }
  },
  async delete(url) {
    try {
      await axios.delete(url, headers)
    } catch (e) {
      visuals.alertError('削除に失敗しました。お手数ですが再度削除してください。')
      console.error(e)
    }
  }
}

export default {
  namespaced: true,
  actions
}
