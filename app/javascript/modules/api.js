import axios from 'axios'

const headers = { 'Content-Type': 'multipart/form-data' }
axios.defaults.headers.common = {
  'X-Requested-With': 'XMLHttpRequest',
  'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
}

const actions = {
  async fetch(url) {
    try {
      const response = await axios.get(url)
      return response.data
    } catch (e) {
      console.error(e)
    }
  },
  async create(url, formData) {
    try {
      const response = await axios.post(url, formData, headers)
      return response.data
    } catch (e) {
      console.error(e)
    }
  },
  async delete(url, id) {
    try {
      axios.delete(`${url}/${id}`)
    } catch (e) {
      console.error(e)
    }
  }
}

export default {
  namespaced: true,
  actions
}
