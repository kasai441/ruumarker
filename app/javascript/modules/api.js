import axios from 'axios'

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
      await axios.post(url, formData, headers)
    } catch (e) {
      console.error(e)
    }
  },
  async update(url, formData) {
    try {
      await axios.put(url, formData, headers)
    } catch (e) {
      console.error(e)
    }
  },
  async delete(url) {
    try {
      const response = await axios.delete(url, headers)
      return response.data
    } catch (e) {
      console.error(e)
    }
  }
}

export default {
  namespaced: true,
  actions
}
